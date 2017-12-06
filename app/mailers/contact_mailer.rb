class ContactMailer < ApplicationMailer

  def contact(author,email,message)
    @author = author
    @email = email
    @message = message
    mail(to: 'contact@test.fr', subject: 'sujet de test')
  end
end
