package fpdemo

import scala.collection.JavaConversions._
import social._
import repositories._

case object MainScala extends App {
  System.out.println("Hi from " + MainScala)

  val locator = Boot.configure("jdbc:postgresql://fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass")

  val person = new Person()
    .setName("Marko")

  val personRepository = locator.resolve(classOf[PersonRepository])
  personRepository.insert(person)

  val count = personRepository.count()
  println(count)

  val persons = personRepository.search()
  persons map (_.getName) foreach println

  sys.exit(0)
}
