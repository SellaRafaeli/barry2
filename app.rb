puts "starting app..."

require 'bundler'

require 'active_support'
require 'active_support/core_ext'

require 'sinatra/reloader' #dev-only
require 'sinatra/activerecord'

puts "requiring gems..."

Bundler.require

Dotenv.load

require './setup'
require './my_lib'

require_all './db'
require_all './bl'
require_all './admin'
require_all './comm'
require_all './logging'
require_all './mw'

include Helpers

$app_name   = 'barry2'

get '/ping' do
  {msg: "pong from #{$app_name}", val: 123}
end

get '/' do
  #to_card(:"pages/homepage", layout: :layout)
  full_page_card(:"pages/homepage", layout: :layout)
  #to_page(:"pages/homepage", layout: :layout)
end