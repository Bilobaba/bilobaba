Member.create(email: 'kevin.arnoult@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'kevain', avatar: 'image/upload/v1513088284/kxwjxlmo878gnwibhqwx.jpg')
Member.create(email: 'francoise.sauzet@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'francoise')
Member.create(email: 'anonyme@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'anonyme')


connection = ActiveRecord::Base.connection
connection.execute(File.read('db//smihug_import/members.backup'))
connection.execute(File.read('db//smihug_import/members_roles.backup'))
connection.execute(File.read('db//smihug_import/events.backup'))
connection.execute(File.read('db//smihug_import/roles.backup'))

Member.create(email: 'souaybou.k@live.fr', password: 'coucou', password_confirmation: 'coucou', pseudo: 'souya')
Member.create(email: 'contact.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'nicou')
Member.create(email: 'hello.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'hello')
Member.create(email: 'alex@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'alex')
Member.create(email: 'juju@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'juju')
Member.create(email: 'naula@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'naula')

# Example to create an event to tests in Rails c
# Event.create(
#   title: 'Resto',
#   organizer: Member.find_by_pseudo('didou'),
#   begin: Time.now + 7.hours,
#   end: Time.now + 9.hours,
#   price_min: 15,
#   price_max: 15,
#   members_max: 10,
#   zip: '94300'
# )
