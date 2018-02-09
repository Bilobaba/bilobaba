require 'pry'

class RegistrationsController < Devise::RegistrationsController

  def new
    @h1_title = 'Formulaire d\'inscription'
    if flash['devise.facebook_data']
      @facebook_login = {
        password_auto_generated: Devise.friendly_token,
        email: flash['devise.facebook_data']['info']['email']
      }
      flash['facebook_id'] = flash['devise.facebook_data']['uid']
    end
    super
  end

  def create
    super
    binding.pry
    # OPTIMIZE only send email if member is actually really created (saved)
    ContactMailer.new_user_action('Nouveau membre', 'http://www.bilobaba.com/members/' + resource.id.to_s).deliver_now
    resource.facebook_id = session['facebook_id']
    session['facebook_id'] = nil
    resource.save(validate: false)
    resource.add_role(:professional) if params[:type_member] == MEMBER_TYPE_PRO
    resource.add_role(:amateur) if params[:type_member] == MEMBER_TYPE_AMATEUR
    # OPTIMIZE only send email if member is actually really created (saved)
    ContactMailer.new_user_action('Nouveau membre', 'http://www.bilobaba.com/members/' + resource.id.to_s).deliver_now
  end
end
