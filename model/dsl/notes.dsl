module notes
{
    aggregate Note {
        List<URL> urls;
        String markup;
        List<Task> tasks;
        Bucket? *bucket;

        specification nadjiPoBucketNameu 'it => it.bucket.name == ime' {
            String ime;
        }
    }

    event AddTask {
        String name;
        int noteID;
    }

    value Task {
        String name;
        String body;
        Status status;
    }

    aggregate Bucket {
        String name;
        detail<Note.bucket> notes;
    }

    enum Status {
        Pending;
        Finished;
    }
}
