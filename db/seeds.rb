users = [
{ email: 'alice@example.com', password: 'password', display_name: 'Alice' },
{ email: 'bob@example.com', password: 'password', display_name: 'Bob' },
{ email: 'carol@example.com', password: 'password', display_name: 'Carol' },
{ email: 'dave@example.com', password: 'password', display_name: 'Dave' },
{ email: 'erin@example.com', password: 'password', display_name: 'Erin' }
]
users.each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.password = attrs[:password]
    u.display_name = attrs[:display_name]
  end
end
