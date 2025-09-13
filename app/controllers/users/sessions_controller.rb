class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    Rails.logger.info "[SessionsController] Login request params: #{params.inspect}"
    user = User.find_by!(email: params[:user][:email])
    Rails.logger.info "[SessionsController] user info: #{user.display_name}"
    super
  rescue => e
    Rails.logger.error "[SessionsController] Login exception: #{e.class} - #{e.message}"
    raise
  end

  private
  def respond_with(resource, _opts = {})
    token = request.env["warden-jwt_auth.token"]
    if resource.persisted?
      Rails.logger.info "[SessionsController] Login success: user_id=#{resource.id}, email=#{resource.email}"
      render json: { user: resource.slice(:id, :email, :display_name), token: token }, status: :ok
    else
      Rails.logger.warn "[SessionsController] Login failed: user not persisted"
      render json: { error: "Login failed" }, status: :unauthorized
    end
  end


  def respond_to_on_destroy
    Rails.logger.info "[SessionsController] Logout"
    head :no_content
  end
end
