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
end
