class ContactMailer < ApplicationMailer

  #OPTIMIZE use a tool like Sidekiq to avoid latency due to emails sending

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

  def new_user_action(action, link)
    @link = link
    mail(to: 'hello.bilobaba@gmail.com', subject: 'Nouvelle action : ' + action)
  end

end
