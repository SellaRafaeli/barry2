ONE_HOUR_IN_SECONDS = 3600
ONE_WEEK_IN_SECONDS = ONE_HOUR_IN_SECONDS * 24 * 7

$redis = ($prod ? Redis.new(url: ENV['REDIS_URL']) : Redis.new)

 

