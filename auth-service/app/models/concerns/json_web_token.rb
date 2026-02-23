module JsonWebToken
  extend self

  SECRET_KEY = Rails.application.secret_key_base || 
               Rails.application.credentials.secret_key_base || 
               'fallback_secret_key_for_test'

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end