# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.destroy_all

user1 = User.create(first_name: "Steve", last_name: "Jobs", email: "steve@gmail.com", address: "12345 street st.", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a very good programmer")
user2 = User.create(first_name: "Ethan", last_name: "Bustamante", email: "Ethan@gmail.com", address: "Ethan street st.", lat: "1.12", lon: "1.12", is_remote: "true", about: "I am a also very good programmer")

steveskill1 = Skill.create(name: "Apple", proficiency: 5, user_id: user1.id)
steveskill2 = Skill.create(name: "Swift", proficiency: 5, user_id: user1.id)

ethanskill1 = Skill.create(name: "Ruby", proficiency: 5, user_id: user2.id)
ethanskill2 = Skill.create(name: "Rails", proficiency: 5, user_id: user2.id)