package fpdemo;

import fpdemo.social.*;
import fpdemo.social.repositories.*;

import org.revenj.patterns.PersistableRepository;
import org.revenj.patterns.ServiceLocator;

import java.util.*;

class MainJava {
    public static void main(final String[] args) throws Exception {
        System.out.println("Hi from MainJava!");

        final ServiceLocator locator = Boot.configure("jdbc:postgresql://fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass");

        final Person person = new Person()
          .setName("Java Person");

        final PersistableRepository<Person> personRepository = locator.resolve(PersonRepository.class);
        personRepository.insert(person);

        final long count = personRepository.count();
        System.out.println(count);

        final List<Person> persons = personRepository.search();
        for (final Person p : persons) {
            System.out.println(p.getName());
        }

        System.exit(0);
    }
}
