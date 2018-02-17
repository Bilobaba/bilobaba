class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    facebook_id = request.env['omniauth.auth'].uid
    @member = Member.from_facebook(facebook_id)
    if @member
      sign_in_with_facebook(@member)
    else
      @member = Member.from_email(request.env['omniauth.auth'].info.email)
      if @member
        save_facebook_id(@member, facebook_id)
        sign_in_with_facebook(@member)
      else
        session['devise.facebook_data'] = request.env['omniauth.auth']
        redirect_to new_member_registration_path
      end
    end
  end

  protected

  def sign_in_with_facebook(member)
    session['facebook_login'] = 1
    sign_in_and_redirect member, event: :authentication
  end

  def save_facebook_id(member, facebook_id)
    member.facebook_id = facebook_id
    member.save
  end

end
