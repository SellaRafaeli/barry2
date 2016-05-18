$items = $mongo.collection('items')

SETTABLE_ITEM_FIELDS = ['title','desc']

post '/add_item' do
  data = params.just(SETTABLE_ITEM_FIELDS)
  bp
  data[:title]   ||= 'item'
  data[:user_id]   = cuid
  data[:slug]= get_unique_slug($items,:slug,data[:title])
  item = $items.add(data)
  redirect item_link(item)
end

get '/items/:slug' do
  item = $items.get(slug: params[:slug])
  halt_home unless item
  full_page_card :"items/item", locals: {item: item}, layout: :layout
end