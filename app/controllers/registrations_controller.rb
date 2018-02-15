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

  def update_resource(resource, params)
    if resource.facebook_id
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end

    if params[:type_member] == MEMBER_TYPE_PRO
      resource.remove_role(:amateur)
      resource.add_role(:professional)
    else
      resource.remove_role(:professional)
      resource.add_role(:amateur) if params[:type_member] == MEMBER_TYPE_AMATEUR
    end
  end
end
