require 'pry'

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Devise::Controllers::Rememberable

  protect_from_forgery with: :exception
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :last_request
  after_action :visited_pages

  def after_sign_in_remember_me(resource)
    remember_me resource
  end

  def after_sign_in_path_for(resource)
    session[:request_back]
  end

  def after_confirmation_path_for(resource)
    session[:request_back]
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) {
      |u| u.permit(
        :email, :password, :password_confirmation,
        :gender, :pseudo, :first_name, :name,:bio, :birth_date,
        :address, :zip, :city, :country, :avatar, :site,
        :category_list, :tag, { tag_ids: [] }, :tag_ids, :title
      )
    }
    devise_parameter_sanitizer.permit(:account_update) {
      |u| u.permit(
        :email, :password, :password_confirmation,
        :gender, :pseudo, :first_name, :name, :bio, :birth_date,
        :address, :zip, :city, :country, :avatar, :site, :current_password,
        :category_list, :tag, { tag_ids: [] }, :tag_ids, :title
      )
    }
  end

  # to back if not login loggout authentification
  # request.url not update by devise controller
  def last_request

    session[:request_back] ||= request.url

    if ( request.referer &&
        !request.url.include?('/auth') &&
        !request.url.include?('sign_up') &&
        !request.url.include?('sign_in') &&
        !request.referer.include?('/auth') &&
        !request.referer.include?('sign_up') &&
        !request.referer.include?('forbidden') &&
        !request.referer.include?('sign_in')
        )
      session[:request_back] = request.referer if (request.url != request.referer) &&  request.referer
    end
  end

  def visited_pages
    if request.url.include?(ENV["ROOT_URL"])
      cookies.permanent[VIEWED_ANY] = true
    end
    if request.url ==  ENV["ROOT_URL"] + testimonials_path
      cookies.permanent[VIEWED_TESTIMONIALS] = true
    end
    if request.url ==  ENV["ROOT_URL"] + new_testimonial_path
      cookies.permanent[VIEWED_NEW_TESTIMONIAL] = true
    end
  end
end

