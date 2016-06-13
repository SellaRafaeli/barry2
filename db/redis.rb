$redis = ($prod ? Redis.new(ENV['REDIS_URL']) : Redis.new)

 

