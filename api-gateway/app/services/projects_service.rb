class ProjectsService
  include HTTParty
  base_uri ENV.fetch('PROJECTS_SERVICE_URL', 'http://localhost:3002')
  
  def self.forward_request(method, path, user_id, params = {}, headers = {})
    # Ajouter le user_id dans les headers
    headers['X-User-Id'] = user_id.to_s
    headers['Content-Type'] = 'application/json'
    
    # Faire la requête au service Projects
    response = case method.to_sym
               when :get
                 get(path, headers: headers)
               when :post
                 post(path, body: params.to_json, headers: headers)
               when :put, :patch
                 put(path, body: params.to_json, headers: headers)
               when :delete
                 delete(path, headers: headers)
               end
    
    {
      status: response.code,
      body: response.parsed_response
    }
  rescue StandardError => e
    Rails.logger.error("Projects Service Error: #{e.message}")
    {
      status: 503,
      body: { error: 'Service unavailable' }
    }
  end
end