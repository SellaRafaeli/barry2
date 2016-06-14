def get_ajax_results(q)
  users = $users.search_by(:name, q).map {|u| u.merge!({type: :user, value: u['name']+ ' (user)', data: user_link(u)})}
  items = $items.search_by(:title, q).map {|i| i.merge!({type: :item, value: i['title']+' (item)', data: item_link(i)})}
  results = users + items
end

def get_search_items(crit)
  data = {}
  data[:title] = like_regex(crit[:title]) if crit[:title].present?
  data[:desc]  = like_regex(crit[:desc])  if crit[:desc].present?
  data[:price] = {"$lt": crit[:price]} if crit[:price].present?
  [:category,:subcat,:type,:material].each { |field|
    data[field] = crit[field] if crit[field].present?
  }

  items = $items.get_many(data, limit: 20).sort_by{|i| i['price']}
end

get '/search_page' do  
  results = get_search_items(params)
  full_page_card(:"pages/search/search", layout: :layout, locals: {results: results})
end

get '/search_ajax' do 
  {suggestions: get_ajax_results(params[:query])}
end