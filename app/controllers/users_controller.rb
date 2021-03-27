class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # ログイン済みのユーザーか確認します。
  # before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show]
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  before_action :correct_user, only: [:edit, :new, :update]
  # システム管理権限所有かどうか判定します。
  before_action :admin_user, only: [:indx, :destroy]
  # 一般ユーザの場合、URLを直接入力しても遷移しない
  before_action :authenticate_user, only: [:new]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def show
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end  
  

  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # beforeフィルター

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
    
    # def limitation_correct_user
    #   unless @current_user.id == params[:id].to_i
    #     flash[:notice] = "他のユーザーの編集はできません。"
    #     redirect_to root_url
    #   end
    #   # @user = User.find(params[:id]) # この行に注目！！
    #   # unless @user.user_id == @current_user.id
    #   #   flash[:notice]= "自分以外のユーザーの投稿は編集できません。"
    #   #   redirect_to signup_url(@user)
    #   # end
    #   # unless current_user.try(:admin?) && current_user?(@user)
    #   #   redirect_to signup_url(@user)
    #   # end
    #   # @user = User.find(params[:id])
    #   # @user = User.find(params[:id])
    #   # unless @user.user_id && current_user?(@user)
    #   #   redirect_to signup_url
    #   # end
    # # redirect_to signup_url @user unless current_user.try(:admin?) && current_user?(@user)
    # # redirect_to new_user_url unless current_user.try(:admin?) && current_user?(@user)
    # # render :new unless current_user.try(:admin?) && current_user?(@user)
    # end
    
end