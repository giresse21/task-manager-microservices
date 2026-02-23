class AuthController < ApplicationController
  
  # POST /signup
  def signup
    user = User.new(user_params)
    
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { 
        token: token, 
        user: user.as_json(except: [:password_digest]) 
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /login
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { 
        token: token, 
        user: user.as_json(except: [:password_digest]) 
      }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  # POST /verify
  def verify
    token = request.headers['Authorization']&.split(' ')&.last
    
    if token.blank?
      return render json: { error: 'Token missing' }, status: :unauthorized
    end
    
    decoded = JsonWebToken.decode(token)
    
    if decoded
      user = User.find_by(id: decoded[:user_id])
      
      if user
        render json: { 
          valid: true, 
          user: user.as_json(except: [:password_digest]) 
        }
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  rescue ActionController::ParameterMissing
    params.permit(:name, :email, :password, :password_confirmation)
  end
  
end