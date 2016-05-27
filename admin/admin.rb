MANAGEABLE_COLLECTIONS = [:users,:items,:payments,:errors,:site_log,:requests].map {|n| $mongo.collection(n) } * 2

get '/admin' do
  to_page(:"admin/dashboard")
end

get "/admin/manage/:coll" do 
  erb :"admin/items", default_layout
end 

$sella = $users.get(email: 'sella.rafaeli@gmail.com')
$sella_id = $sella['_id']
def is_admin(user = cu)
  user == $sella rescue false
end

before '/admin*' do
  halt(404) unless is_admin
end

def verify_admin_val(coll, field, val)
  if coll == 'posts'
    if field == 'photos'
      halt_bad_input(msg: 'Bad photos')
    end
  end
  val
end

get '/admin/login_as' do  
  user = $users.get(params[:user_id])
  flash.msg = 'Logged in as '+user['email']
  session[:user_id] = params[:user_id]
  redirect back
end

post '/admin/create_item' do
  require_fields(['coll'])
  coll = $mongo.collection(params[:coll])
  fields = mongo_coll_keys(coll)
  data   = params.just(fields)
  coll.add(data)
  redirect back
end

post '/admin/update_item' do
  require_fields(['id','field','coll'])
  coll, field, val = params[:coll], params[:field], params[:val]
  verified_val = verify_admin_val(coll, field, val)
  res = $mongo.collection(params[:coll]).update_id(params[:id],{field => verified_val})
  {msg: "ok", new_item: res}
end

post '/admin/delete_item' do
  require_fields(['id','coll'])
  $mongo.collection(params[:coll]).delete_one({_id: params[:id]})
  {msg: "ok"}
end