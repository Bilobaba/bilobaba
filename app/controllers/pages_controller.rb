require 'pry'

class PagesController < ApplicationController
  def home
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
    @h1_title = 'Donnez-nous votre avis'
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
end
