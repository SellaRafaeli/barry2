$redis = ($prod ? Redis.new(url: ENV['REDIS_URL']) : Redis.new)

 

