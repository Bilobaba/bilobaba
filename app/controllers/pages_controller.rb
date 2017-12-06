require 'pry'

class PagesController < ApplicationController
  def home
  end

  def contact
  end

  def send_mail_contact
    author = params[:message][:name]
    email = params[:message][:email]
    message = params[:message][:message]

    ContactMailer.contact(author,email,message).deliver_now

    flash[:notice] = "Votre message a bien été envoyé."
    redirect_to root_path
  end
end
