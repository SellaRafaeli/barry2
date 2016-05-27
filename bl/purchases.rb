$purchases = $mongo.collection('purchases') #purchases are payments that were completed.

def create_purchase(user_id, seller_id, item_id)
  data = {user_id: user_id, seller_id: seller_id, item_id: item_id, price: price}
  $purchases.add(data)
end

get '/my_purchases' do 
  full_page_card :"pages/purchases/my_purchases"
end
