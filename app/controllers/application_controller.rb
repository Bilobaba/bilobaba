require 'pry'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :last_request
  after_action :visited_pages

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) {
      |u| u.permit(
        :email, :password, :password_confirmation,
        :gender, :pseudo, :first_name, :name,:bio, :birth_date,
        :address, :zip, :city, :country, :avatar, :site
      )
    }
    devise_parameter_sanitizer.permit(:account_update) {
      |u| u.permit(
        :email, :password, :password_confirmation,
        :gender, :pseudo, :first_name, :name, :bio, :birth_date,
        :address, :zip, :city, :country, :avatar, :site, :current_password
      )
    }
  end

  def last_request
    session[:request_back] ||= request.url
    session[:request_back] = request.referer if (request.url != request.referer) &&  request.referer
  end

  def visited_pages
    if request.url.include?(ENV["ROOT_URL"])
      cookies[VIEWED_ANY] = true
    end
    if request.url ==  ENV["ROOT_URL"] + testimonials_path
      cookies[VIEWED_TESTIMONIALS] = true
    end
    if request.url ==  ENV["ROOT_URL"] + new_testimonial_path
      cookies[VIEWED_NEW_TESTIMONIAL] = true
    end
  end
end

