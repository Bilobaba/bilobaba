
connection = ActiveRecord::Base.connection
connection.execute(File.read('db//smihug_import/members.backup'))
connection.execute(File.read('db//smihug_import/members_roles.backup'))
connection.execute(File.read('db//smihug_import/events.backup'))
connection.execute(File.read('db//smihug_import/roles.backup'))

Member.create(email: 'souaybou.k@live.fr', password: 'coucou', password_confirmation: 'coucou', pseudo: 'souya', address: ' Ici ')
Member.create(email: 'contact.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'nicou', address: ' Ici ')
Member.create(email: 'hello.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'hello', address: ' Ici ')
Member.create(email: 'alex@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'alex', address: ' Ici ')
Member.create(email: 'juju@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'juju', address: ' Ici ')
Member.create(email: 'naula@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'naula', address: ' Ici ')

# Example to create an event to tests in Rails c
# e = Event.create(
#   title: 'RestoXXX',
#   description: 'Tres bon restaurant vegetarien',
#   adress: 'Ici et la bas',
#   town: 'Here',
#   organizer: Member.first,
#   begin: Time.now + 7.hours,
#   end: Time.now + 9.hours,
#   price_min: 15,
#   price_max: 15,
#   members_max: 10,
#   zip: '94300'
# )

# f = Event.create(
#   title: 'Resto',
#   description: 'Tres bon restaurant vegetarien',
#   adress: 'Ici et la bas',
#   town: 'Here',
#   organizer: Member.first,
#   begin: Time.now + 17.hours,
#   end: Time.now + 19.hours,
#   price_min: 15,
#   price_max: 15,
#   members_max: 10,
#   zip: '94300'
# )
