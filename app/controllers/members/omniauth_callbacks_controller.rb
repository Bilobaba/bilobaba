class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @member = Member.from_facebook(request.env['omniauth.auth'])
    if @member && @member.persisted?
      sign_in_and_redirect @member, event: :authentication
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_member_registration_path
    end
  end
end
