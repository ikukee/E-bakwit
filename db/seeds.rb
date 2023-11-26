# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(fname: "superuser", lname: "superuser", password_digest: BCrypt::Password.create("@Super1208!?"), email: "superuser@gmail.com", user_type: "ADMIN", bdate: Date.today, address:"1",cnum: "09380261902" )
