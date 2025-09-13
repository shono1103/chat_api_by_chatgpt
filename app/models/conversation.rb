class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, dependent: :destroy


  before_validation :normalize_pair


  validates :user1_id, presence: true
  validates :user2_id, presence: true
  validate :distinct_users
  validates :user1_id, uniqueness: { scope: :user2_id }


  scope :for_user, ->(uid) { where("user1_id = :id OR user2_id = :id", id: uid) }


  def other_user_for(user)
    user.id == user1_id ? user2 : user1
  end


  private
  def normalize_pair
    return if user1_id.blank? || user2_id.blank?
    a, b = [ user1_id, user2_id ].minmax
    self.user1_id = a
    self.user2_id = b
  end


  def distinct_users
    errors.add(:base, "cannot chat with yourself") if user1_id == user2_id
  end
end
