get '/about' do 
  full_page_card(:"other/about")
end 

# demonstrative purposes
get '/card' do
  full_page_card(:"other/about")
end

get '/page' do
  to_page(:"other/about")
end

get '/faq' do
  full_page_card(:"pages/static/faq")
end