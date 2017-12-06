class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.add_role(:professional) if params[:member][:roles] == '1'
  end
end
