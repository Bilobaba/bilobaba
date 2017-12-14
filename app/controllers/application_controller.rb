require 'pry'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :last_request

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up){|u| u.permit(:email, :password, :password_confirmation,
                                                              :pseudo, :first_name, :name,:bio, :birth_date,
                                                              :adress, :zip, :town, :country, :avatar, roles: [] )}
    devise_parameter_sanitizer.permit(:account_update){|u| u.permit(:email, :password, :password_confirmation,
                                                              :pseudo, :first_name, :name,:bio, :birth_date,
                                                              :adress, :zip, :town, :country, :avatar, :current_password )}
  end

  def last_request
    a = 1
    # binding.pry
    session[:request_back] ||= request.url
    session[:request_back] = request.referer if (request.url != request.referer) &&  request.referer
  end
end

