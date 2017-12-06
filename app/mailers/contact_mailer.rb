class ContactMailer < ApplicationMailer

  def contact(author,email,message)
    @author = author
    @email = email
    @message = message
    mail(to: 'hello.bilobaba@gmail.com', subject: 'Message de contact')
  end

  def contact_confirm(author,email,message)
    @author = author
    @email = email
    @message = message
    mail(to: @email, subject: 'Confirmation de votre formulaire Bilobaba')
  end

end
