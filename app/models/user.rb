class User < ApplicationRecord
include Devise::JWT::RevocationStrategies::JTIMatcher


devise :database_authenticatable, :registerable,
:recoverable, :rememberable, :validatable,
:jwt_authenticatable, jwt_revocation_strategy: self


before_create :ensure_display_name


private
def ensure_display_name
self.display_name ||= email.split("@").first
end
end
