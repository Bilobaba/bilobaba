# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Member.create(email: 'tao.zen.duy@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'didou')
Member.create(email: 'kevin.arnoult@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'kevain')
Member.create(email: 'souaybou.k@live.fr', password: 'coucou', password_confirmation: 'coucou', pseudo: 'souya')
Member.create(email: 'contact.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'nicou')
Member.create(email: 'hello.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'alex')
Member.create(email: 'salut.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'juju')

Event.create(title: 'Resto', organizer: Member.first)
Event.create(title: 'Cine', organizer: Member.first)
Event.create(title: 'Picnik', organizer: Member.first)
Event.create(title: 'Danse', organizer: Member.second)
Event.create(title: 'Meditation', organizer: Member.second)
