class LoginsController < ApplicationController
  def new
  end

  def create
    if user = authenticate_with_google
      sign_in(:user, user)
      redirect_to logged_in_path
    else
      redirect_to root_path, alert: 'authentication_failed'
    end
  end

  private
  def authenticate_with_google
    if id_token = flash[:google_sign_in]["id_token"]
      auth = {google_id: GoogleSignIn::Identity.new(id_token).user_id, email: GoogleSignIn::Identity.new(id_token).email_address }
      User.find_by(google_id: auth[:google_id]) ? User.find_by(google_id: auth[:google_id]) : User.create(google_id: auth[:google_id], email: auth[:email])
    elsif error = flash[:google_sign_in]["error"]
      logger.error "Google authentication error: #{error}"
      nil
    end
  end
end
