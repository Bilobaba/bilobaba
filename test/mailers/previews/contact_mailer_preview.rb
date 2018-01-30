# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  def contact
    ContactMailer.contact(Member.first.pseudo, Member.first.email, 'yoyo')
  end

end
