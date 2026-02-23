class ProjectsController < ApplicationController
  before_action :check_user_id
  before_action :set_project, only: [:show, :update, :destroy]
  
  # GET /projects
  def index
    projects = Project.where(user_id: @user_id)
    render json: projects
  end
  
  # GET /projects/:id
  def show
    render json: @project
  end
  
  # POST /projects
  def create
    project = Project.new(project_params)
    project.user_id = @user_id
    
    if project.save
      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT /projects/:id
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /projects/:id
  def destroy
    @project.destroy
    head :no_content
  end
  
  private
  
  # Vérifie que le Gateway a envoyé le user_id
  def check_user_id
    @user_id = request.headers['X-User-Id']
    
    if @user_id.blank?
      render json: { error: 'Unauthorized - No user ID provided' }, status: :unauthorized
      return
    end
    
    @user_id = @user_id.to_i
  end
  
  # Trouve le projet appartenant au user
  def set_project
    @project = Project.find_by(id: params[:id], user_id: @user_id)
    
    unless @project
      render json: { error: 'Project not found' }, status: :not_found
    end
  end
  
  # Paramètres autorisés
  def project_params
    params.require(:project).permit(:name, :description, :color)
  rescue ActionController::ParameterMissing
    params.permit(:name, :description, :color)
  end
end