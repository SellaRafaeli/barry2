def halt_bad_input(opts = {})
  halt(403, {msg: opts[:msg] || "Bad input."}) 
end

def halt_missing_param(field)
  halt(403, {msg: "Missing field: #{field}"}) 
end

def halt_item_exists(field, val = nil)
  halt(403, {msg: "Item exists with field: #{field} and val: #{val}"}) 
end

def halt_error(msg)
  halt(500, {msg: msg})
end

def require_fields(fields)
  Array(fields).each do |field| halt_missing_param(field) unless params[field].present? end 
end

def halt_home(msg = nil)
  msg ||= 'Please sign in first.'
  flash.msg='Sign in First' 
  redirect '/' 
end

def halt_back(msg = 'Sorry!')
  flash.msg = msg if msg
  redirect back
end

def require_sign_in(msg = nil)
  halt_home unless cu
end

def require_obj(obj)
  halt_home('No such item.') unless obj
end

get '/halts' do
  {msg: 'halt!'}
end