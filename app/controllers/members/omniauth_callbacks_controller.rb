class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @member = Member.from_facebook(request.env['omniauth.auth'])
    if @member && @member.persisted?
      session['facebook_login'] = 1
      # TODO: add flash msg showing the FB account used
      sign_in_and_redirect @member, event: :authentication
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      # TODO: add msg showing the FB account used
      redirect_to new_member_registration_path
    end
  end
end
