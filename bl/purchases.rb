$purchases = $mongo.collection('purchases') #purchases are payments that were completed.

def create_purchase(payment_data)
  data = payment_data.just('user_id', 'seller_id', 'item_id', 'price', 'item_title')
  data[:payment_id] = payment_data['_id']
  $purchases.add(data)
end

get '/my_purchases' do 
  full_page_card :"pages/purchases/my_purchases"
end
