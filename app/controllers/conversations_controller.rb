class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [ :show ]


  def index
    convs = Conversation.for_user(current_user.id).includes(:user1, :user2).order(updated_at: :desc)
    render json: convs.map { |c| serialize_conversation(c) }
  end


  def create
    recipient = User.find(params.require(:recipient_id))
    u1, u2 = [ current_user.id, recipient.id ].minmax
    conv = Conversation.find_or_create_by!(user1_id: u1, user2_id: u2)
    render json: serialize_conversation(conv), status: :created
  end


  def show
    authorize_participation!(@conversation)
    render json: serialize_conversation(@conversation)
  end


  private
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end


  def authorize_participation!(conv)
    unless [ conv.user1_id, conv.user2_id ].include?(current_user.id)
      head :forbidden
    end
  end


  def serialize_conversation(c)
  {
    id: c.id,
    user1: c.user1.slice(:id, :display_name, :email),
    user2: c.user2.slice(:id, :display_name, :email),
    updated_at: c.updated_at
  }
  end
end
