get '/login' do
  full_page_card :"web_auth/login", layout: :layout
end

post '/login' do
  email, password = params[:email], params[:password]
  if $users.exists?(email: email)
    user = $users.get(email: email)
    if BCrypt::Password.new(user['hashed_pass']) == password      
      session[:user_id] = user[:_id]     
      log_event('logged in')
      redirect '/' 
    else
      flash.msg = 'Wrong password.'
      redirect back
    end
  else
     flash.msg = 'No such email.' 
     redirect back
  end  
end

get '/register' do
  full_page_card :"web_auth/register", layout: :layout
end

post '/register' do
  name, email, password = params[:name], params[:email], params[:password]
  if $users.exists?(email: email)
    flash.msg = 'Email already taken.'
    redirect back
  else 
    user = create_user(name: name, email: email, hashed_pass: BCrypt::Password.create(password))
    session[:user_id] = user[:_id]     
    log_event('registered')    
    redirect '/me'
  end
end

get '/forgot_password' do
  full_page_card :"web_auth/forgot_password", layout: :layout
end

post '/forgot_password' do
  user_exists = params[:email] && $users.exists?(email: params[:email])
  msg = user_exists ? 'Check your email for a sign-in link. (Not yet implemented).' : 'No such user exists.'
  flash.msg = msg  
  redirect back
end

get '/logout' do
  log_event('logged out')
  session.clear
  redirect '/'
end