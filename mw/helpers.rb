module Helpers
  #call erb from places that don't have access to Sinatra's top level. 
  def zerb(*args, &block)
    # we need a Sinatra Application instance in order to call 'erb' from within Modules.
    # see 
    @rendering_app ||= Sinatra::Application.new.instance_variable_get :@instance
    @rendering_app.erb(*args, &block)
  end
end

## user helpers
def user_link(u)
  $root_url+'/u/'+u['username'].to_s 
rescue => e 
  '/oops'
end

def user_img_tag(u, opts = {})
  url = u['imgs'] && u['imgs'][0] 
  height = opts[:height] || 100
  %Q{<img src=#{url} height=#{height}>} if url
rescue ''
end

def udn(u) #user display name
  u['name'] || u['username'] || 'Somebody'
end

def to_username(s)
  s.to_s.gsub('.','-').gsub(' ','-').gsub(/[^a-zA-Z0-9-_]/, '')
end

## items
def item_link(i)
  $root_url+'/items/'+i['slug'].to_s 
end

def item_cat_link(i)
  $root_url+'/cat/'+i['category'].to_s 
end

def cat_link(cat)
  $root_url+'/cat/'+cat.to_s 
end

def to_slug(s)
  s.to_s.to_slug.normalize.to_s.slice(0,200)
end

## imgs
def random_img_url(w = 100,h = 100)
  "https://source.unsplash.com/random/100x100"
end



get '/mw/helpers' do
  {foo: true}
end