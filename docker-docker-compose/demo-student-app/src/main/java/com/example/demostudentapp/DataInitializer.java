package com.example.demostudentapp;

import com.example.demostudentapp.entity.Student;
import com.example.demostudentapp.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final StudentRepository studentRepository;

    @Override
    public void run(String... args) {
        if (studentRepository.count() == 0) {
            studentRepository.save(Student.builder().firstName("Alice").lastName("Martin").email("alice.martin@school.com").age(21).major("Computer Science").build());
            studentRepository.save(Student.builder().firstName("Bob").lastName("Dupont").email("bob.dupont@school.com").age(22).major("Mathematics").build());
            studentRepository.save(Student.builder().firstName("Clara").lastName("Benoit").email("clara.benoit@school.com").age(20).major("Physics").build());
            studentRepository.save(Student.builder().firstName("David").lastName("Leroy").email("david.leroy@school.com").age(23).major("Computer Science").build());
        }
    }
}
