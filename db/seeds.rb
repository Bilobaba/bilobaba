# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Tables of  pros
ProTable = ['omar','marc','peter','lucie','garance','amelie','lise','silke','carine','cyrill','veronique','david']

# Delete tables
Event.destroy_all
Member.destroy_all

# Populate with pros
ProTable.each do |p|
  Member.create(email: p + '@gmailpro.com', pseudo: p.capitalize, password: 'coucou', password_confirmation: 'coucou')
  Member.last.add_role(:professional)
end

# Members of team
Member.create(email: 'tao.zen.duy@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'didou')
Member.create(email: 'kevin.arnoult@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'kevain')
Member.create(email: 'souaybou.k@live.fr', password: 'coucou', password_confirmation: 'coucou', pseudo: 'souya')
Member.create(email: 'contact.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'nicou')
Member.create(email: 'hello.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'hello')
Member.create(email: 'alex@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'alex')
Member.create(email: 'juju@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'juju')
Member.create(email: 'naula@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'naula')


5.times do
  Event.create(
    title: 'Resto',
    organizer: Member.find_by_pseudo(ProTable[rand(0..ProTable.size-1)].capitalize),
    begin: '2017-12-04 18:30',
    end: '2017-12-04 20:30',
    price_min: 15,
    price_max: 15,
    members_max: 10,
    zip: '94300'
  )

  Event.create(
    title: 'Cine',
    organizer: Member.find_by_pseudo(ProTable[rand(0..ProTable.size-1)].capitalize),
    begin: '2017-12-04 18:30',
    end: '2017-12-04 20:30',
    price_min: 15,
    price_max: 15,
    members_max: 10,
    zip: '75011'
  )

  Event.create(
    title: 'Picnik',
    organizer: Member.find_by_pseudo(ProTable[rand(0..ProTable.size-1)].capitalize),
    begin: '2017-12-04 18:30',
    end: '2017-12-04 20:30',
    price_min: 10,
    price_max: 10,
    members_max: 30,
    zip: '75002'
  )

  Event.create(
    title: 'Danse',
    organizer: Member.find_by_pseudo(ProTable[rand(0..ProTable.size-1)].capitalize),
    begin: '2017-12-04 18:30',
    end: '2017-12-04 20:30',
    price_min: 20,
    price_max: 20,
    members_max: 10,
    zip: '75011'
  )

  Event.create(
    title: 'Meditation',
    organizer: Member.find_by_pseudo(ProTable[rand(0..ProTable.size-1)].capitalize),
    begin: '2017-12-04 18:30',
    end: '2017-12-04 20:30',
    price_min: 30,
    price_max: 30,
    members_max: 7,
    zip: '94300'
  )
end

md = Member.find_by(pseudo: 'didou')
mk = Member.find_by(pseudo: 'kevain')
ms = Member.find_by(pseudo: 'souya')
mn = Member.find_by(pseudo: 'naula')
ma = Member.find_by(pseudo: 'alex')
mj = Member.find_by(pseudo: 'juju')

er = Event.find_by(title: 'Resto')
ec = Event.find_by(title: 'Cine')
ep = Event.find_by(title: 'Picnik')
ed = Event.find_by(title: 'Danse')
em = Event.find_by(title: 'Meditation')
