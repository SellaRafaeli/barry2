require './app'

puts "Loading bg worker...".green

bg_subscribe(BG_TASKS_QUEUE) { |payload| do_direct(payload) }

