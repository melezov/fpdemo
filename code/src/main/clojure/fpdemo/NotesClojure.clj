(import [fpdemo Boot]
        [fpdemo.notes Note Task Bucket Status]
        [fpdemo.notes.repositories NoteRepository BucketRepository])

(println "Hi from NotesClojure!")

(let [locator (Boot/configure "jdbc:postgresql://fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass")]
  (def bucket
    (doto (new Bucket)
      (.setName "Clojure Bucket")))

  (def bucketRepository
    (.resolve locator BucketRepository))
  (.insert bucketRepository bucket)

  (def task1 (doto (new Task "ime1" "puno texta" Status/Pending)))
  (def task2 (doto (new Task "ime2" "puno texta" Status/Pending)))

  (def notes
    (for [i (range 0 3)]
      (doto (new Note)
        (.setUrls [
          (new java.net.URI (str "https://reddit.com/r/programming/" i))
          (new java.net.URI "https://twitter.com/")])
        (.setMarkup "Parsiraj i indexiraj ovo: https://twitter.com/")
        (.setTasks [task1, task2])
        (.setBucket bucket))))

  (def noteRepository
    (.resolve locator NoteRepository))
  (.insert noteRepository notes)

  (def spec
    (new fpdemo.notes.Note$nadjiPoBucketNameu "moje"))

  (doseq [n (.search noteRepository spec (int 2) (int 5))]
    (println n))
)

(System/exit 0)
