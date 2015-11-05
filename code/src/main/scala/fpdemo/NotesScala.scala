package fpdemo

import scala.collection.JavaConversions._
import fpdemo.notes._
import fpdemo.notes.repositories._
import java.net.URI

object NotesScala extends App {
  System.out.println("Hi from NotesScala!")

  val locator = Boot.configure("jdbc:postgresql://fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass")

  val bucket = new Bucket()
    .setName("moje")

  val bucketRepository = locator.resolve(classOf[BucketRepository])
  bucketRepository.insert(bucket)

  val task1 = new Task("ime1", "puno texta", Status.Pending)
  val task2 = new Task("ime2", "puno texta", Status.Finished)

  val notes = (1 to 3) map { i =>
    new Note()
      .setUrls(Seq(
        new URI("https://reddit.com/r/programming/" + i),
        new URI("https://twitter.com/")))
      .setMarkup("Parsiraj i indexiraj ovo: https://twitter.com/")
      .setTasks(Seq(task1, task2))
      .setBucket(bucket)
  }

  val noteRepository = locator.resolve(classOf[NoteRepository])
  noteRepository.insert(notes)

  val spec = new Note.nadjiPoBucketNameu("moje")
  for (n <- noteRepository.search(spec, 2, 5)) {
    println(n)
  }

  System.exit(0)
}
