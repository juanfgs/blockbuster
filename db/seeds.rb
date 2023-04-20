# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

juan = User.create(name: 'Juan', email: 'juanfgs@gmail.com', password: 'secreto', role: :admin)
juan.api_keys.create! token: '719196b8b8ea693ec2d0a046aca9ee50'
pepito = User.create(name: 'Pepito', email: 'pepito@gmail.com', password: 'secreto2', role: :user)
pepito.api_keys.create! token: '8291b1ae24eae940b882cc15498bd02d'
