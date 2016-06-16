def create_seed_users
  puts 'creating users'
  $users.delete_many
  create_user({name: 'Sella Rafaeli', email: 'sella.rafaeli@gmail.com', hashed_pass: BCrypt::Password.create('foo')})

  (0..100).to_a.each { create_user({name: Faker::Name.name, email: Faker::Internet.email}) }
end

def seed_imgs
  ['http://i.imgur.com/yrRGVNG.jpg', 'http://i.imgur.com/bmkzLEL.png', 'http://i.imgur.com/pyFdhW3.jpg']
end

def seed_videos
  ['http://cdn.filestackcontent.com/jK8LoU1T1C5N5TPmjwbQ']
end

def seed_zip_url
  'https://cdn.filestackcontent.com/9ItCl9j8QLeHQh2ySdF7'
end

def create_user_item(user) 
  user_id = user['_id']
  title = [Faker::Commerce.product_name, "#{Faker::Hacker.adjective.capitalize} #{Faker::Hacker.noun.capitalize}"].sample
  desc = [Faker::Company.catch_phrase.titleize, Faker::Company.bs.titleize].sample
  price = rand(10)*rand(30)
  create_item(user['_id'], {title: title, desc: desc, category: ITEM_CATEGORIES.sample, subcat: ITEM_SUBCATS.sample, type: ITEM_TYPES.sample, material: ITEM_MATERIALS.sample, technology: ITEM_TECHNOLOGIES.sample, price: price, imgs: seed_imgs, videos: seed_videos, status: [ITEM_APPROVED_STATUS,ITEM_DELETED_STATUS,ITEM_PENDING_STATUS].sample, zip_url: seed_zip_url})
end

def create_seed_items
  puts 'creating items'
  $items.delete_many
  $users.all.to_a.each {|user| rand(10).times { create_user_item(user) } }
end

def create_seed_data
  create_seed_users
  create_seed_items
end