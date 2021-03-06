$payments = $mongo.collection('payments')

$payments.ensure_index('user_id')
$payments.ensure_index('seller_id')
$payments.ensure_index('item_id')

def create_payment(params)
  data = params.just(:user_id, :seller_id, :item_id, :price, :item_title)
  $payments.add(data)
end

get '/payment_page' do  
  require_user
  item    = $items.get(params[:item_id]) || halt_back('Bad item.')
  seller  = $users.get(item['user_id']) || halt_back('Bad seller.')
  payment = create_payment({item_id: item['_id'], seller_id: seller['_id'], user_id: cuid, price: item['price'], item_title: item['title']})

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

  create_purchase(payment)
  redirect '/my_purchases'
end
