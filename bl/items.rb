$items = $mongo.collection('items')

SETTABLE_ITEM_FIELDS = ['title','desc']

post '/add_item' do
  data = params.just(SETTABLE_ITEM_FIELDS)
  data[:title]   ||= 'item'
  data[:user_id]   = cuid
  data[:slug]= get_unique_slug($items,:slug,data[:title])
  item = $items.add(data)
  redirect item_link(item)
end

get '/edit_item' do
  halt_home('Cannot do that.') unless (item = $items.get(params[:item_id])) && item['user_id'] == cuid
bp
  full_page_card :"items/edit_item_page", locals: {item: item}, layout: :layout
end

get '/items/:slug' do
  item = $items.get(slug: params[:slug])
  halt_home unless item
  full_page_card :"items/item_page", locals: {item: item}, layout: :layout
end