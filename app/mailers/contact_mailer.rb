class ContactMailer < ApplicationMailer

  def contact(contact_bilobaba,author, email, message)
    @author = author
    @email = email
    @message = message
    @contact = contact_bilobaba
    mail(to: @contact, subject: 'Message de contact de Bilobaba')
  end

  def contact_confirm(author, email, message)
    @author = author
    @email = email
    @message = message
    mail(to: @email, subject: 'Confirmation de votre formulaire Bilobaba')
  end

  def event_leave(author, email, message)
    @author = author
    @email = email
    @message = message
    mail(to: 'hello.bilobaba@gmail.com', subject: 'Désinscription évènement')
  end

end
