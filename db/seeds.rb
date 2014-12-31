# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.where(user_name: "Yifan").first_or_create!
user2 = User.where(user_name: "Felicia").first_or_create!
user3 = User.where(user_name: "John").first_or_create!

poll1 = Poll.where(title: "What is Ruby?", author_id: user1.id).first_or_create!

question1 = Question.where(text: "validates vs validate?", poll_id: poll1.id).first_or_create!
question2 = Question.where(text: "includes vs join?", poll_id: poll1.id).first_or_create!

a1 = AnswerChoice.where(text: "a", question_id: question1.id).first_or_create!
a2 = AnswerChoice.where(text: "c", question_id: question1.id).first_or_create!
a3 = AnswerChoice.where(text: "d", question_id: question1.id).first_or_create!

b1 = AnswerChoice.where(text: "d", question_id: question2.id).first_or_create!
b2 = AnswerChoice.where(text: "e", question_id: question2.id).first_or_create!
b3 = AnswerChoice.where(text: "f", question_id: question2.id).first_or_create!

r1 = Response.where(user_id: user2.id, answer_choice_id: a1.id).first_or_create!
r2 = Response.where(user_id: user3.id, answer_choice_id: a2.id).first_or_create!
