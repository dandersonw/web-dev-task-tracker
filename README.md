# TaskTracker

Web dev homework.

Design decisions for the latest homework:
* How to structure the DB: It was convenient to have manager as a nullable field
  on User. task_id was a mandatory field on TimeBlock.
* Presentation of tasks: Since I already had some options on the task index
  page, "underling tasks" was a natural extension.
* csrf_token: I added it to the app.html.eex header, since it could
  hypothetically be used in AJAX forms all over the application.
