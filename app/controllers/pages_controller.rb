require 'pry'

class PagesController < ApplicationController

  def home
  end

  # home from webflow
  def home_awesome
    @count_events_next_week = Event.next_week.count
    @count_professionals = Member.pros.count
    @coutn_testimonials = Testimonial.count
    @list_events = Event.next_events.first(4)
    @list_testimonials = Testimonial.published.last(3)
  end

  def team
    @h1_title = 'Notre équipe'
  end

  def smihug
    @h1_title = 'Smihug devient Bilobaba'
  end

  def search
    @h1_title = 'Trouvez vos envies'
    render partial "events_search"
  end

  def contact
    @h1_title = "Contactez l'équipe du site"
  end

  def send_mail_contact
    @author = params[:message][:name]
    @email = params[:message][:email]
    @message = params[:message][:message]

    ContactMailer.contact_confirm(@author,@email,@message).deliver_now
    ContactMailer.contact('hello.bilobaba@gmail.com',@author,@email,@message).deliver_now

    flash[:notice] = "Votre message a bien été envoyé."
    redirect_to root_path
  end

  def permission
  end

  def cgu
  end

  def confidentiality
  end

  def test
  end

  def faqs
  end

end
