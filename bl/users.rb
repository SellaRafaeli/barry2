$users = $mongo.collection('users')

SETTABLE_USER_FIELDS = ['email','name']

get '/u/:username' do
  u = params[:username]
  user = $users.get(u) || $users.get(email: u)
end

get '/me' do
  redirect '/' unless cu
  full_page_card(:"users/me")
end

post '/update_me' do
  user_fields = params.just(SETTABLE_USER_FIELDS)
  $users.update_id(cuid,user_fields)
  flash.message = 'Updated.'
  redirect back
end