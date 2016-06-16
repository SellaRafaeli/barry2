$purchases = $mongo.collection('purchases') #purchases are payments that were completed.

$payments.ensure_indexes('user_id')
$payments.ensure_indexes('seller_id')
$payments.ensure_indexes('item_id')

def create_purchase(payment_data)
  data = payment_data.just('user_id', 'seller_id', 'item_id', 'price', 'item_title')
  data[:payment_id] = payment_data['_id']
  $purchases.add(data)
end

get '/my_purchases' do 
  full_page_card :"pages/purchases/my_purchases"
end

get '/my_sales' do
  full_page_card :"pages/purchases/my_sales"
end