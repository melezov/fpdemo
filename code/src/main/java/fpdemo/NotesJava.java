package fpdemo;

import fpdemo.notes.*;
import fpdemo.notes.repositories.*;
import org.revenj.patterns.*;

import java.net.URI;
import java.util.*;

class NotesJava {
    public static void main(final String[] args) throws Exception {
        System.out.println("Hi from NotesJava!");

        final ServiceLocator locator = Boot.configure("jdbc:postgresql://fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass");

        final Bucket bucket = new Bucket()
            .setName("moje");

        final PersistableRepository<Bucket> bucketRepository = locator.resolve(BucketRepository.class);
        bucketRepository.insert(bucket);

        final Task task1 = new Task("ime1", "puno texta", Status.Pending);
        final Task task2 = new Task("ime2", "puno texta", Status.Finished);

        final List<Note> notes = new ArrayList<Note>();
        for (int i = 0; i < 3; i ++ ) {
            notes.add(new Note()
                    .setUrls(Arrays.asList(
                            new URI("https://reddit.com/r/programming/" + i),
                            new URI("https://twitter.com/")))
                    .setMarkup("Parsiraj i indexiraj ovo: https://twitter.com/")
                    .setTasks(Arrays.asList(task1, task2))
                    .setBucket(bucket));
        }

        final PersistableRepository<Note> noteRepository = locator.resolve(NoteRepository.class);
        noteRepository.insert(notes);

        final Specification<Note> spec = new Note.nadjiPoBucketNameu("moje");
        for (final Note n : noteRepository.search(spec, 2, 5)) {
            System.out.println(n);
        }

        System.exit(0);
    }
}
