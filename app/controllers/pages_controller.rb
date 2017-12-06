require 'pry'

class PagesController < ApplicationController
  def home
  end

  def contact
  end

  def send_mail_contact
    binding.pry
    author = params[:message][:name]
    email = params[:message][:email]
    message = params[:message][:message]

    ContactMailer.contact(author,email,message).deliver_now

  end
end
