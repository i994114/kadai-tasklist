class TasksController < ApplicationController
  before_action :set_task,only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in  #Twitter課題の追加箇所
  before_action :correct_user, only: [:destroy,:show] #Twitter課題の追加箇所
  
  def index
    #@tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
    #下記をＴｗｉｔｔｅｒの課題で追加
    if logged_in?
      @user=current_user
      @task=current_user.tasks.build
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to root_url
      
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクを登録できませんでした'
      render 'toppages/index'
=begin
    @task = Task.new(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクを登録できませんでした'
      render :new
=end
    end

    
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    #redirect_back(fallback_location: root_path)
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  #Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
