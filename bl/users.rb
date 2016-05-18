$users = $mongo.collection('users')

SETTABLE_USER_FIELDS = ['email','name','username']

def create_user(data)
  login = to_username(data[:email].split("@")[0])
  data[:username] = get_unique_slug($users,'username',login)
  $users.add(data)
end

get '/u/:username' do
  user = $users.get(username: params[:username])
  full_page_card :"users/user_page", locals: {user: user}
end

get '/me' do
  redirect '/' unless cu
  full_page_card(:"users/me")
end

post '/update_me' do
  user_fields = params.just(SETTABLE_USER_FIELDS)
  user_fields['username'] = to_username(user_fields['username'])

  halt_back('Sorry, that username is taken.') if (existing_user = $users.get(username: user_fields['username'])) && existing_user!=cu

  $users.update_id(cuid,user_fields)
  flash.msg = 'Updated.'
  redirect back
end