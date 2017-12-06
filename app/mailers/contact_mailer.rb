class ContactMailer < ApplicationMailer

  def contact(author,email,message)
    @author = author
    @email = email
    @message = message
    mail(to: 'hello.bilobaba@gmail.com', subject: 'Message de contact')
  end
end
