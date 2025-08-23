class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :body, presence: true, length: { minimum: 1 }
end
