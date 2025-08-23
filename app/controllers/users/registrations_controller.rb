class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json


  private
  def respond_with(resource, _opts = {})
    token = request.env["warden-jwt_auth.token"]
    render json: { user: resource.slice(:id, :email, :display_name), token: token }, status: :ok
  end


  def respond_to_on_destroy
    head :no_content
  end
end
