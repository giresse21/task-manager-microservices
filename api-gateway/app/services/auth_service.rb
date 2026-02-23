class AuthService
  include HTTParty
  base_uri ENV.fetch('AUTH_SERVICE_URL', 'http://localhost:3001')
  
  # Vérifier un token (utilisé en interne par le Gateway)
  def self.verify_token(token)
    response = post('/verify', 
      headers: { 'Authorization' => "Bearer #{token}" }
    )
    
    if response.success? && response.parsed_response['valid']
      response.parsed_response['user']
    else
      nil
    end
  rescue StandardError => e
    Rails.logger.error("Auth Service Error: #{e.message}")
    nil
  end
  
  # Forward une requête (signup, login)
  def self.forward_request(method, path, params = {})
    response = case method.to_sym
               when :post
                 post(path, body: params.to_json, headers: { 'Content-Type' => 'application/json' })
               when :get
                 get(path)
               end
    
    {
      status: response.code,
      body: response.parsed_response
    }
  rescue StandardError => e
    Rails.logger.error("Auth Service Error: #{e.message}")
    {
      status: 503,
      body: { error: 'Auth service unavailable' }
    }
  end
  
  # Forward avec token (pour /verify)
  def self.forward_request_with_token(method, path, token, params = {})
    headers = { 'Content-Type' => 'application/json' }
    headers['Authorization'] = "Bearer #{token}" if token
    
    response = case method.to_sym
               when :post
                 post(path, body: params.to_json, headers: headers)
               when :get
                 get(path, headers: headers)
               end
    
    {
      status: response.code,
      body: response.parsed_response
    }
  rescue StandardError => e
    Rails.logger.error("Auth Service Error: #{e.message}")
    {
      status: 503,
      body: { error: 'Auth service unavailable' }
    }
  end
end