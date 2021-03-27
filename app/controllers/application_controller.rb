class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id]) 
  end
  
  # 一般ユーザの場合、URLを直接入力しても遷移しない
  def authenticate_user
    unless @current_user == nil
      # flash[:notice] = "ログインしてください。"
      redirect_to root_url
    end
  end
  
end
