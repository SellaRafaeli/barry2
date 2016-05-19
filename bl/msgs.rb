$msgs = $mongo.collection('msgs')

def add_msg(receiver_id, text)
  $msgs.add({sender_id: cuid, receiver_id: receiver_id, text: text.to_s})
end

get '/inbox' do
  require_user
  
  full_page_card :"pages/convos/convos", layout: :layout
end

get '/inbox/:username' do
  require_user

  halt_back('No such user') unless user = $users.get(username: params[:username])
  full_page_card :"pages/convos/single_convo", layout: :layout, locals: {user: user}
end

post '/send_msg' do
  require_user

  user_id, text    = params[:user_id], params[:text]
  halt_back('Missing input.') unless text && (user = $users.get(user_id))
  
  add_msg(user_id, text)
  redirect "/inbox/#{user['username']}"
end