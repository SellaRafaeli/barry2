$payments = $mongo.collection('payments')

def create_payment(params)
  data = params.just(:user_id, :seller_id, :item_id, :price)
  $payments.add(data)
end

get '/payment_page' do  
  item    = $items.get(params[:item_id]) || halt_back('Bad item.')
  seller  = $users.get(item['user_id']) || halt_back('Bad seller.')
  payment = create_payment({item_id: item['_id'], seller_id: seller['_id'], user_id: cuid, price: item['price']})

  pp = payment_page = build_paypal_payment_page(payment, item)
  halt_back(pp[:err]) if pp[:err]     
  full_page_card :"pages/payments/transfer_to_paypal", layout: :layout, locals: {url: pp[:url]}
end

get '/paypal_cancel' do
  if item = $items.get(params[:item_id])
    redirect_with_msg item_link(item) 
  else
    halt_home('Aww, that\'s too bad.')
  end
end

get '/paypal_confirm' do
  payment     = $payments.get(params[:payment_id]) || halt_home('No such payment.')
  paypal_data = get_paypal_payment_details(payment['paypal_pay_key'])
  info        = {paypal_data: paypal_data, status: paypal_data[:status]}
  info[:paid] = true if paypal_data[:confirmed_paid]
  $payments.update_id(payment['_id'], info)

  create_purchase(payment['user_id'], payment['seller_id'], payment['item_id'], payment['price'])
  redirect '/my_purchases'
end
