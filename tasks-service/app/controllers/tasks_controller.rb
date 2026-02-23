class TasksController < ApplicationController
  before_action :check_user_id
  before_action :set_task, only: [:show, :update, :destroy, :toggle]
  
  # GET /projects/:project_id/tasks
  def index
    # Le Gateway a déjà vérifié que le projet existe
    # On fait confiance au Gateway
    tasks = Task.where(project_id: params[:project_id], user_id: @user_id)
    render json: tasks
  end
  
  # GET /tasks/:id
  def show
    render json: @task
  end
  
  # POST /projects/:project_id/tasks
  def create
    # Le Gateway a déjà vérifié que le projet existe
    # On fait confiance au Gateway
    task = Task.new(task_params)
    task.user_id = @user_id
    task.project_id = params[:project_id]
    
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT /tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end
  
  # PATCH /tasks/:id/toggle
  def toggle
    @task.update(completed: !@task.completed)
    render json: @task
  end
  
  private
  
  def check_user_id
    @user_id = request.headers['X-User-Id']
    
    if @user_id.blank?
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end
    
    @user_id = @user_id.to_i
  end
  
  def set_task
    @task = Task.find_by(id: params[:id], user_id: @user_id)
    
    unless @task
      render json: { error: 'Task not found' }, status: :not_found
    end
  end
  
  def task_params
    params.require(:task).permit(:title, :description, :completed, :priority, :due_date)
  rescue ActionController::ParameterMissing
    params.permit(:title, :description, :completed, :priority, :due_date)
  end
end