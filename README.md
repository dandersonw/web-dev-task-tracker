# TaskTracker

Web dev homework.

Design decisions:
* How to structure the DB: Originally I set up a table for mapping users to
  tasks, but had a lot of trouble getting it to work with the Phoenix ORM. It
  was simpler, implementation wise, to just have `assignee` as a field on the
  Task.
* Presentation of tasks: I oriented the default presentation around what I
  figured was the most common flow - a user looking at his unfinished
  tasks. Other tasks can be made visible with toggle buttons on the page.
