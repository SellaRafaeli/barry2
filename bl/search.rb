def get_search_results(q)
  users = $users.search_by(:name, q).map {|u| u.merge!({type: :user, value: u['name']+ ' (user)', data: user_link(u)})}
  items = $items.search_by(:title, q).map {|i| i.merge!({type: :item, value: i['title']+' (item)', data: item_link(i)})}
  results = users + items
end

get '/search_page' do
  full_page_card(:"pages/search/search", layout: :layout)
end

get '/search_ajax' do 
  {suggestions: get_search_results(params[:query])}
end