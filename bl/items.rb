$items = $mongo.collection('items')

SETTABLE_ITEM_FIELDS = ['title','desc', 'category']
ITEM_CATEGORIES = [:food, :entertainment, :business, :health, :sports, :other]

def create_item(user_id, data) 
  data = data.just(SETTABLE_ITEM_FIELDS)
  data[:user_id] = user_id
  data[:title] ||= 'item'
  data[:slug]  = get_unique_slug($items,:slug,data[:title])
  item = $items.add(data)
end

post '/add_item' do
  data = params.just(SETTABLE_ITEM_FIELDS)
  item = create_item(cuid, data)
  redirect item_link(item)
end

get '/edit_item' do
  item = $items.get(params[:item_id])
  halt_back('Cannot do that.') unless item && item['user_id'] == cuid

  full_page_card :"items/edit_item_page", locals: {item: item}, layout: :layout
end

post '/edit_item' do 
  item = $items.get(params[:item_id])
  halt_back('Cannot do that.') unless item && item['user_id'] == cuid

  data = params.just(SETTABLE_ITEM_FIELDS)
  data[:title]   ||= 'item'
  
  $items.update_id(item['_id'],data)
  flash.msg = 'Updated item.'
  redirect back
end

get '/cat/:cat' do
  cat = params[:cat]
  halt_back('No such category') unless ITEM_CATEGORIES.include? cat.to_sym

  full_page_card :"items/multi_items_page", locals: {cat: cat, title: cat}
end

get '/items/:slug' do
  item = $items.get(slug: params[:slug])
  halt_home unless item
  full_page_card :"items/item_page", locals: {item: item}, layout: :layout
end