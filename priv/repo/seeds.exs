# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaskTracker.Repo.insert!(%TaskTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaskTracker.Repo
alias TaskTracker.Tasks.Task
alias TaskTracker.Users.User

Repo.insert!(%User{name: "foo", is_manager: true})
Repo.insert!(%User{name: "bar", is_manager: false, manager: 1})
Repo.insert!(%Task{title: "bart", assignee: 2})
