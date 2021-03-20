class TasksController < ApplicationController
  # before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :admin_or_correct_user, only: [:show]
  
  # 一覧ページ
  def index
    @user = User.find(params[:user_id])
    # @tasks = Task.all
    @tasks = @user.tasks.all
  end
  
  # 詳細画面
  def show
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    # @task = @user.tasks
    # @task = Task.find(params[:id])
  end
  
  # 新規作成ページ
  def new
    @user = User.find(params[:user_id])
    @task = @user.tasks.new
    # @task = Task.new
    # @task = @user, Task.new
  end
  
  # 新規保存
  def create
    @user = User.find(params[:user_id])
    @task = @user.tasks.new(task_params)
    if @task.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to user_tasks_url 
    else
      render :new
    end
  end

  # 編集ページ
  def edit
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
  end
  
  # 更新
  def update
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    # @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました。"
      redirect_to user_tasks_url
    else
      render :edit
    end
  end
  
  # 削除
  def destroy
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    @task.destroy
    flash[:success] = "#{@task.name}のタスクデータを削除しました。"
    redirect_to user_tasks_url
    # @task = Task.find(params[:id])
  end  
  
  private
  
    def task_params
      params.require(:task).permit(:name, :description)
    end
    
    # paramsハッシュからユーザーを取得します。
    # def set_user
    #   @user = User.find(params[:id])
    # end
    
    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
    
end


