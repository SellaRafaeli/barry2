$items = $mongo.collection('items')

SETTABLE_ITEM_FIELDS = ['name','desc']

post '/add_item' do
  data = params.just(SETTABLE_ITEM_FIELDS)
  bp
  data[:user_id] = cuid
  item = $items.add(data)
  redirect '/items/'+item['_id'].to_s
end

get '/items/:id' do
  item = $items.get(params[:id])
  halt_home unless item
  full_page_card :"items/item", locals: {item: item}, layout: :layout
end