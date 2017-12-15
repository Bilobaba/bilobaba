class SessionsController < Devise::SessionsController
  
  def new
    @h1_title = 'Formulaire de connexion'
    super
  end

  def edit
    @h1_title = 'Formulaire d\'édition'
    super
  end

  def create
    super
    resource.add_role(:professional) if params[:member][:roles] == '1'
  end
end
