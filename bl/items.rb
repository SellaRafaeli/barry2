$items = $mongo.collection('items')

$items.ensure_index('title')
$items.ensure_index('user_id')

SETTABLE_ITEM_FIELDS = ['title','desc', 'category', 'subcat', 'types', 'divisions', 'materials', 'technologies', 'price', 'imgs', 'videos', 'zip_url']

ITEM_LIST_OF_LISTS = [
  {id: 'category',     items: ITEM_CATEGORIES, title: 'Category',},
  {id: 'subcat',       items: ITEM_SUBCATS, title: 'SubCategory'},
  {id: 'types',        items: ITEM_TYPES, title: 'Type'},
  {id: 'divisions',    items: ITEM_DIVISIONS, title: 'Division'},
  {id: 'materials',   items: ITEM_MATERIALS, title: 'Material'},
  {id: 'technologies', items: ITEM_TECHNOLOGIES, title: 'Technology'}
]

ITEM_APPROVED_STATUS, ITEM_PENDING_STATUS, ITEM_DELETED_STATUS = :approved, :pending, :deleted

# item statuses: pending, approved, deleted
def create_item(user_id, data) 
  data = data.just(SETTABLE_ITEM_FIELDS)
  data[:user_id] = user_id
  data[:title] ||= 'item'
  data[:price] ||= 5
  data[:price] = data[:price].to_i
  data[:slug]  = get_unique_slug($items,:slug,data[:title])

  data[:imgs]  = data[:imgs].to_a.map {|link| {link: link}}
  data[:videos]  = data[:videos].to_a.map {|link| {link: link}}
  data[:status]  = :pending
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
  data[:price]   = data[:price].to_i  
  data[:imgs]    = data[:imgs].to_a.map {|link| {link: link}}
  data[:imgs]    = data[:imgs] + (existing_imgs = Array(item['imgs']))

  data[:videos]    = data[:videos].to_a.map {|link| {link: link}}
  data[:videos]    = data[:videos] + (existing_videos = Array(item['videos']))

  $items.update_id(item['_id'],data)
  flash.msg = 'Updated item.'
  redirect back
end

get '/items/remove_img' do
  item = $items.get(user_id: cuid, _id: params[:item_id]) || halt_back('Nope, no such item.')  
  imgs = item['imgs'].to_a.reject {|i| i['link'] == params[:img_to_remove] }
  $items.update_id(item['_id'],{imgs: imgs})
  back_with_msg('Updated item.')
end

get '/cat/:cat' do
  cat = params[:cat]
  halt_back('No such category') unless ITEM_CATEGORIES.include? cat.to_sym

  full_page_card :"items/multi_items_page", locals: {cat: cat, title: cat}
end

get '/items/creation_page' do
  #redirect '/verify_email' unless user_verified_email(cu)
  full_page_card :"items/item_form", locals: {route: '/add_item', title: 'Add Item', creating_new_item: true}
end

# must be bottom
get '/items/:slug' do
  item = $items.get(slug: params[:slug])
  halt_back('No such item...') unless item
  full_page_card :"items/item_page", locals: {item: item}, layout: :layout
end
