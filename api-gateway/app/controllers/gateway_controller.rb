class GatewayController < ApplicationController
  before_action :authenticate_request, except: [:signup, :login]
  
  # ============================================
  # PROJECTS ROUTES
  # ============================================
  
# ============================================
  # AUTH ROUTES (SANS AUTHENTIFICATION)
  # ============================================
  
  def signup
    # Pas besoin de token pour signup
    # Passer directement à Auth Service
    forward_to_auth_without_auth(:post, '/signup', request.request_parameters)
  end
  
  def login
    # Pas besoin de token pour login
    # Passer directement à Auth Service
    forward_to_auth_without_auth(:post, '/login', request.request_parameters)
  end
  
  def verify
    # Endpoint pour vérifier un token (utilisé en interne)
    forward_to_auth_with_auth(:post, '/verify')
  end

  def projects_index
    forward_to_projects(:get, '/projects')
  end
  
  def projects_show
    forward_to_projects(:get, "/projects/#{params[:id]}")
  end
  
  def projects_create
    forward_to_projects(:post, '/projects', request.request_parameters)
  end
  
  def projects_update
    forward_to_projects(:put, "/projects/#{params[:id]}", request.request_parameters)
  end
  
  def projects_destroy
    forward_to_projects(:delete, "/projects/#{params[:id]}")
  end
  
  # ============================================
  # TASKS ROUTES
  # ============================================
  
  def tasks_index
    # 1. Vérifier que le projet existe et appartient au user
    project_result = verify_project_ownership(params[:project_id])
    return unless project_result
    
    # 2. Si OK, récupérer les tâches
    forward_to_tasks(:get, "/projects/#{params[:project_id]}/tasks")
  end
  
  def tasks_create
    # 1. Vérifier que le projet existe et appartient au user
    project_result = verify_project_ownership(params[:project_id])
    return unless project_result
    
    # 2. Si OK, créer la tâche
    forward_to_tasks(:post, "/projects/#{params[:project_id]}/tasks", request.request_parameters)
  end
  
  def tasks_show
    forward_to_tasks(:get, "/tasks/#{params[:id]}")
  end
  
  def tasks_update
    forward_to_tasks(:put, "/tasks/#{params[:id]}", request.request_parameters)
  end
  
  def tasks_destroy
    forward_to_tasks(:delete, "/tasks/#{params[:id]}")
  end
  
  def tasks_toggle
    forward_to_tasks(:patch, "/tasks/#{params[:id]}/toggle")
  end
  


  private

  # ============================================
  # AUTH FORWARDING (sans authentification)
  # ============================================
  
  def forward_to_auth_without_auth(method, path, params = {})
    result = AuthService.forward_request(method, path, params)
    render json: result[:body], status: result[:status]
  end
  
  def forward_to_auth_with_auth(method, path, params = {})
    # Passer le header Authorization
    token = request.headers['Authorization']&.split(' ')&.last
    result = AuthService.forward_request_with_token(method, path, token, params)
    render json: result[:body], status: result[:status]
  end
  
  # ============================================
  # AUTHENTICATION
  # ============================================
  
  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    
    if token.blank?
      return render json: { error: 'Token missing' }, status: :unauthorized
    end
    
    @current_user = AuthService.verify_token(token)
    
    unless @current_user
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end
  
  # ============================================
  # PROJECT VERIFICATION
  # ============================================
  
  def verify_project_ownership(project_id)
    # Appeler Projects Service pour vérifier que :
    # 1. Le projet existe
    # 2. Le projet appartient au current_user
    
    result = ProjectsService.forward_request(
      :get, 
      "/projects/#{project_id}", 
      @current_user['id']
    )
    
    if result[:status] == 404
      render json: { error: 'Project not found' }, status: :not_found
      return nil
    elsif result[:status] != 200
      render json: { error: 'Error verifying project' }, status: :bad_gateway
      return nil
    end
    
    # Retourner le projet si OK
    result[:body]
  end
  
  # ============================================
  # FORWARDING METHODS
  # ============================================
  
  def forward_to_projects(method, path, params = {})
    result = ProjectsService.forward_request(
      method, 
      path, 
      @current_user['id'], 
      params
    )
    
    render json: result[:body], status: result[:status]
  end
  
  def forward_to_tasks(method, path, params = {})
    result = TasksService.forward_request(
      method, 
      path, 
      @current_user['id'], 
      params
    )
    
    render json: result[:body], status: result[:status]
  end
end