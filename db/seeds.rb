users = [
  { email: 'alice@example.com', password: 'password', display_name: 'Alice' },
  { email: 'bob@example.com', password: 'password', display_name: 'Bob' },
  { email: 'carol@example.com', password: 'password', display_name: 'Carol' },
  { email: 'dave@example.com', password: 'password', display_name: 'Dave' },
  { email: 'erin@example.com', password: 'password', display_name: 'Erin' },
  { email: 'shono131103@gmail.com', password: 'shonoshono', display_name: 'shono' }
]
users.each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.password = attrs[:password]
    u.display_name = attrs[:display_name]
    u.save!
  end
end

# Conversationのシード
alice = User.find_by(email: 'alice@example.com')
bob   = User.find_by(email: 'bob@example.com')
shono = User.find_by(email: 'shono131103@gmail.com')

convs = [
  { user1_id: alice.id, user2_id: bob.id },
  { user1_id: alice.id, user2_id: shono.id },
  { user1_id: bob.id,   user2_id: shono.id }
]

convs.each do |attrs|
  Conversation.find_or_create_by!(user1_id: [ attrs[:user1_id], attrs[:user2_id] ].min, user2_id: [ attrs[:user1_id], attrs[:user2_id] ].max)
end

# Messageのシード
conv1 = Conversation.find_by(user1_id: [ alice.id, bob.id ].min, user2_id: [ alice.id, bob.id ].max)
conv2 = Conversation.find_by(user1_id: [ alice.id, shono.id ].min, user2_id: [ alice.id, shono.id ].max)
conv3 = Conversation.find_by(user1_id: [ bob.id, shono.id ].min, user2_id: [ bob.id, shono.id ].max)

Message.find_or_create_by!(conversation: conv1, user: alice, body: "Hi Bob!")
Message.find_or_create_by!(conversation: conv1, user: bob,   body: "Hello Alice!")
Message.find_or_create_by!(conversation: conv2, user: alice, body: "Hi shono!")
Message.find_or_create_by!(conversation: conv2, user: shono, body: "Hey Alice!")
Message.find_or_create_by!(conversation: conv3, user: bob,   body: "Hi shono, it's Bob.")
Message.find_or_create_by!(conversation: conv3, user: shono, body: "Hi Bob!")
