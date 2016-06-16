$requests = $mongo.collection('requests') #track http requests

$requests.ensure_index('created_at', expire_after: ONE_HOUR_IN_SECONDS)

def log_request(data)
  data = data.just(:time_took)
  data = data.merge({username: cusername, user_id: cuid, path: request_path, params: _params})
  $requests.add(data)
end

