ONE_HOUR_IN_SECONDS = 3600

$redis = ($prod ? Redis.new(url: ENV['REDIS_URL']) : Redis.new)

 

