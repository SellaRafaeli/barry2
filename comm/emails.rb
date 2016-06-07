#https://account.postmarkapp.com/servers/2032134/get_started

POSTMARK_CLIENT = Postmark::ApiClient.new(ENV['POSTMARK_TOKEN'])

def send_email(data)  
  data = data.just(:to, :subject, :html_body)
  data.merge!(from: 'sella@rafaeli.net', track_opens: true)
  POSTMARK_CLIENT.deliver(data)
end

get '/test_bg_email' do
  do_bg(:send_email, to: 'sella.rafaeli@gmail.com', subject: 'Hi', html_body: "<strong>Hello: #{Time.now}</strong>")
  {msg: "sending email..."}
end