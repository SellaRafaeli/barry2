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

get '/token_entry' do
  if (email = $redis.get(params[:token])) && (user = $users.get(email: email))
    flash.msg = "Welcome back, #{user['name']}!"
    session[:user_id] = user['_id']
    redirect '/'
  else 
    flash.msg = 'Could not log you in, sorry!'
    redirect '/forgot_password'
  end
end

def send_forgot_password_email(user)
  token      = user['email'] + "-" + guid
  user_email = user['email']
  $redis.setex(token, ONE_HOUR_IN_SECONDS, user_email)
  link = "#{$root_url}/token_entry?token=#{token}"
  body = "Hey, here is your link to log back into #{$app_name}. Click here to log in: <a href='#{link}'>#{link}</a>"
  bp
  send_bg_email(to: user['email'], subject: "Login Link to #{$app_name}", html_body: body)
end

post '/forgot_password' do
  user_exists = params[:email] && $users.get(email: params[:email])
bp
  if user_exists
    msg = 'Check your email for a sign-in link.'
    send_forgot_password_email(user_exists)
  else 
    msg = 'No such user exists.'
  end

  flash.msg = msg  
  redirect back
end

get '/logout' do
  log_event('logged out')
  session.clear
  redirect '/'
end