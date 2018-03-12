require 'pry'

class RegistrationsController < Devise::RegistrationsController

  def new
    @h1_title = 'Formulaire d\'inscription'
    super
  end

  def create
    super
    resource.add_role(:professional) if params[:type_member] == MEMBER_TYPE_PRO
    resource.add_role(:amateur) if params[:type_member] == MEMBER_TYPE_AMATEUR
    # OPTIMIZE only send email if member is actually really created (saved)
    ContactMailer.new_user_action('Nouveau membre', 'http://www.bilobaba.com/members/' + resource.id.to_s).deliver_now
  end

  protected

  #http://bit.ly/1owLKwX
  def update_resource(resource, params)
# verifier que le pseudo n est pas deja utilise
    if resource.pseudo != params[:pseudo]
      if (Tag.find_by_name(params[:pseudo]))
        flash[:alert] = "Ce pseudo n\'est pas disponible"
        redirect_to edit_member_registration
      else
        old_pseudo = resource.pseudo
      end
    end

    if session['facebook_login']
      updated = resource.update_without_password(params)
    else
      updated = resource.update_with_password(params)
    end

    if params[:type_member] == MEMBER_TYPE_PRO
      resource.remove_role(:amateur)
      resource.add_role(:professional)
    else
      resource.remove_role(:professional)
      resource.add_role(:amateur) if params[:type_member] == MEMBER_TYPE_AMATEUR
    end

    if updated
      tag = Tag.find_by_name('old_pseudo')
      tag.name = resource.pseudo
      tag.save
    end

  end
end
