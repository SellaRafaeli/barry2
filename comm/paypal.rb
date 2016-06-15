# chained payments: https://developer.paypal.com/docs/classic/adaptive-payments/ht_ap-basicChainedPayment-curl-etc/
# pay with sella-buyer@gmail.com, password 1-8

PAYPAL_USERNAME=ENV['PAYPAL_USERNAME']
PAYPAL_PASSWORD=ENV['PAYPAL_PASSWORD']
PAYPAL_SIGNATURE=ENV['PAYPAL_SIGNATURE']
PAYPAL_APP_ID='APP-80W284485P519543T' #sandbox, paypal's own

PayPal::SDK.configure(
    :mode      => "sandbox",  # Set "live" for production
    :app_id    => "APP-80W284485P519543T",
    :username  => PAYPAL_USERNAME,
    :password  => PAYPAL_PASSWORD,
    :signature => PAYPAL_SIGNATURE)

def paypal_api
  PayPal::SDK::AdaptivePayments.new
end

def build_paypal_payment_page(payment, item)
  #return {err: 'some paypal payment page error'}
  return_url = $root_url+'/paypal_confirm?payment_id='+payment['_id']
  cancel_url = item_link(item)
  amount     = item['price'].to_f

  @pay = paypal_api.build_pay({ # Build request object
    :actionType => "PAY", 
    :currencyCode => "USD",
    :feesPayer => "EACHRECEIVER",
    #:ipnNotificationUrl => "http://localhost:3000/samples/adaptive_payments/ipn_notify",
    :receiverList => { :receiver => [
      {:amount => amount, :email => "sella-admin2@gmail.com"}
  #      {:amount => amount, :email => "sella-admin2@gmail.com", primary: true }, #'primary' when chaining
  #     {:amount => 4.8, :email => "sella-seller@gmail.com" }
    ]},
    :returnUrl => return_url, 
    :cancelUrl => cancel_url})
  
  @pp_response = paypal_api.pay(@pay) # Make API call & response
  
  # Access response
  if @pp_response.success? && @pp_response.payment_exec_status != "ERROR"
    puts ("paykey: "+@pp_response.payKey.to_s).red
    paypal_pay_key = @pp_response.payKey
    $payments.update_id(payment['_id'], {paypal_pay_key: paypal_pay_key})
    {success: true, url: paypal_api.payment_url(@pp_response), payKey: paypal_pay_key} 
  else
    {err: @pp_response.error[0].message}
  end
end

def get_paypal_payment_details(pay_key)  
  details = paypal_api.payment_details({payKey: pay_key}).to_hash.hwia #({payKey: "AP-0NG01449KF8163342"})
  details[:confirmed_paid] = details['status'].to_s.in?(['COMPLETED', 'PROCESSED'])
  details
end

get '/comm_paypal' do
  {refresh: true}
end

