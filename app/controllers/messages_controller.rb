class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation


  def index
    authorize_participation!(@conversation)
    limit = [ params[:limit].to_i.presence || 50, 200 ].min
    offset = params[:offset].to_i.presence || 0
    msgs = @conversation.messages.includes(:user).order(:created_at).limit(limit).offset(offset)
    render json: msgs.as_json(only: [ :id, :body, :created_at ], include: { user: { only: [ :id, :display_name ] } })
  end


  def create
    authorize_participation!(@conversation)
    msg = @conversation.messages.create!(user: current_user, body: params.require(:body))
    @conversation.touch # 最新メッセージで並び替えできるように
    render json: msg.as_json(only: [ :id, :body, :created_at ], include: { user: { only: [ :id, :display_name ] } }), status: :created
  end


  private
  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end


  def authorize_participation!(conv)
    unless [ conv.user1_id, conv.user2_id ].include?(current_user.id)
      head :forbidden
    end
  end
end
