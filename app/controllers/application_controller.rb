class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  
  before_action :set_current_user

  def set_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id] 
  end
  
  # # ログインしていない状態でのアクセス制限
  def authenticate_user
    unless @current_user
      flash[:success] = "ログインしてくださいよ。"
      redirect_to login_url
    end
  end
  
  def fobid_login_user
    # 一般ユーザー
    if !current_user.try(:admin?) && !current_user?(@user)
      flash[:success] = "すでにログイン状態ですね。"
      redirect_to user_url(id: current_user)
    # adminと未ログインの設定
    elsif current_user.try(:admin?) && current_user?(@user)
      redirect_to signup_url
    end
  end
  
  #   # @user = User.find(params[:id]) if @user.blank?
  #   unless current_user?(@user) || correct_user.admin?
  #     # flash[:notice] = "権限がありません"
  #     redirect_to(root_url)
      
  #   end
  # #     flash[:successe] = "すでにログインしていますよ。"
  # #     # redirect_to("/posts/index")
  # #     redirect_to user_url(id: current_user)
  # #     # redirect_to user_url
  # #   end
  # end
  
  def limitation_login_user
    if @current_user
      flash[:success] = "すでにログイン状態です。"
      redirect_to user_url(id: current_user)
    end
  end
# elsif admin_user
# redirect_to signup_url
      
      
    # beforフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
end
