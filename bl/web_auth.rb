def send_entry_link_email(user, subj = nil)
  token      = user['email'] + "--" + guid
  user_email = user['email']
  $redis.setex(token, ONE_HOUR_IN_SECONDS, user_email)
  
  subj ||= "Login Link to #{$app_name}"
  link = "#{$root_url}/token_entry?token=#{token}"  
  body = "Hey, here is your link to log into #{$app_name}.<br/><br/>Click here to verify your email and log in:<br/><a href='#{link}'>#{link}</a>"
  send_bg_email(to: user['email'], subject: subj, html_body: body)
end

def send_forgot_password_email(user)
  send_entry_link_email(user, "#{$app_name} - Sign-In link")
end

def send_verify_email_email(user)
  send_entry_link_email(user, "#{$app_name} - Verify Your Email")
end

def send_welcome_email(user)
  subj = "Welcome to #{$app_name}!"
  body = "Welcome to #{$app_name}. We're glad to have you with us! For any question, please contact contact@app_name.com."
  send_bg_email(to: user['email'], subject: subj, html_body: body)
end

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
      redirect '/me' 
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
  redirect '/me' if cu
  full_page_card :"web_auth/register", layout: :layout
end

post '/register' do
  name, email, password = params[:name], params[:email], params[:password]
  if $users.exists?(email: email)
    flash.msg = 'Email already taken.'
    redirect 'back'
  else 
    user = create_user(name: name, email: email, hashed_pass: BCrypt::Password.create(password))
    session[:user_id] = user[:_id]     
    send_welcome_email(user)
    send_verify_email_email(user)
    log_event('registered')    
    redirect '/me'
  end
end

get '/forgot_password' do
  full_page_card :"web_auth/forgot_password", layout: :layout
end

get '/token_entry' do
  if (email = $redis.get(params[:token])) && (user = $users.get(email: email))
    flash.msg = "Welcome, #{user['name']}!"
    update_cu({verified_email: true})
    session[:user_id] = user['_id']
    redirect '/'
  else 
    flash.msg = 'Could not log you in, sorry!'
    redirect '/forgot_password'
  end
end

get '/verify_email' do
  if (email = $redis.get(params[:token])) && (user = $users.get(email: email))
    flash.msg = "Welcome back, #{user['name']}!"
    session[:user_id] = user['_id']
    redirect '/'
  else 
    flash.msg = 'Could not log you in, sorry!'
    redirect '/'
  end
end

post '/forgot_password' do
  user_exists = params[:email] && $users.get(email: params[:email])
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