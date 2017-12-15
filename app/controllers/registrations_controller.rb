class RegistrationsController < Devise::RegistrationsController
  
  def new
    @h1_title = 'Formulaire d\'inscription'
    super
  end

  def create
    super
    resource.add_role(:professional) if params[:member][:roles] == '1'
  end
end
