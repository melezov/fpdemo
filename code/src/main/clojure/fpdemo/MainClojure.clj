(import [fpdemo Boot]
        [fpdemo.social Person]
        [fpdemo.social.repositories PersonRepository])

(println "Hi from MainClojure!")

(let [locator (Boot/configure "jdbc:postgresql://fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass")]
  (def person
    (doto (new Person)
      (.setName "Clojure Person")))

  (def personRepository
    (.resolve locator PersonRepository))

  (.insert personRepository person)
  (println (.count personRepository))

  (def persons (.search personRepository))
  (doseq [p persons] (println (.getName p)))
)

(System/exit 0)
