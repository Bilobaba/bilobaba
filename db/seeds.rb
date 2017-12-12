connection = ActiveRecord::Base.connection
connection.execute(File.read('db//smihug_import/members.backup'))
connection.execute(File.read('db//smihug_import/members_roles.backup'))
connection.execute(File.read('db//smihug_import/events.backup'))
connection.execute(File.read('db//smihug_import/roles.backup'))

Member.create(email: 'tao.zen.duy@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'didou')
Member.create(email: 'kevin.arnoult@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'kevain', avatar: 'image/upload/v1513088284/kxwjxlmo878gnwibhqwx.jpg')
Member.create(email: 'souaybou.k@live.fr', password: 'coucou', password_confirmation: 'coucou', pseudo: 'souya')
Member.create(email: 'contact.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'nicou')
Member.create(email: 'hello.bilobaba@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'hello')
Member.create(email: 'alex@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'alex')
Member.create(email: 'juju@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'juju')
Member.create(email: 'naula@gmail.com', password: 'coucou', password_confirmation: 'coucou', pseudo: 'naula')
