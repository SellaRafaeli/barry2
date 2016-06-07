BG_TASKS_QUEUE = :bg_tasks_queue
$do_async = true

def do_direct(payload)
  method_name = payload.delete('method_name')
  send(method_name, payload.hwia)
end

def do_bg(method, data)
  payload = data.merge(method_name: method)
  $do_async ? send_bg_event(payload) : do_direct(payload)
end

def rabbit_channel
  @channel ||= Bunny.new(ENV['CLOUDAMQP_URL']).start.create_channel
end

def send_bg_event(payload) 
  @default_exchange ||= rabbit_channel.default_exchange
  @default_exchange.publish(payload.to_json, :routing_key => BG_TASKS_QUEUE)
end

def bg_subscribe(queue_name, &block) 
  q = rabbit_channel.queue(queue_name)
  q.subscribe(block: true) do |dlvry_info, mdata, payload| 
    yield (JSON.parse(payload)) 
  end
end 

def do_bg_test(data)
  puts "do bg - "
  puts data[:foo] 
end

get '/test_bg' do
  do_bg(:do_bg_test, {foo: 'bar123'})
end