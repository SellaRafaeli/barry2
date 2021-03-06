class Mongo::Collection
  # read
  def get(params = {}) #get('id123') || get(email: 'bob@gmail.com')
    params = {_id: params} if !params.is_a? Hash
    get_many(params).last
  end

  def get_many(params = {}, opts = {})
    self.find(params, opts).to_a
  end

  def all(params = {}, opts = {sort: [{created_at: -1}]})
    get_many(params, opts)
  end

  def first
    get_many.first
  end

  def last 
    get_many({}, sort: [{created_at: -1}]).first
  end

  def exists?(fields)
    get_many(fields, {projection: {_id:1}, limit: 1}).count > 0
  end

  def random(amount = 1, crit = {}) #random items
    arr = []
    amount.times { arr << find(crit).limit(1).skip(rand(find(crit).count)).first }
    amount == 1 ? arr[0] : arr
  end

  def num(crit = {}, opts = {})
    get_many(crit, opts).count
  end

  def search_anywhere(val, opts = {})
    crit = crit_any_field(self,val)
    get_many(crit)
  end

  def search_by(field, val)
    crit = {field => {"$regex" => Regexp.new(val, Regexp::IGNORECASE) } } 
    get_many(crit)
  end

  def get_with(crit_or_id, other_coll, opts = {})
    join_mongo_colls(self, crit_or_id, other_coll, {})
  end

  #create
  def add(doc)    
    # => simple_add(doc)
    smart_add(doc)
  end

  def simple_add(doc)
    doc[:_id]        = nice_id
    doc[:created_at] = Time.now
    self.insert_one(doc)
    doc.hwia
  end

  def smart_add(doc)
    doc[:_id] = ((self.count + 1)).to_s#.base62_encode 
    simple_add(doc)
  rescue Mongo::Error::OperationFailure => e
    puts "oops on #{doc[:_id]}".red
    bp
    return simple_add(doc) if e.to_s.include?('duplicate key error')
    raise e
  end

  def get_or_add(fields)
    get(fields) || add(fields)
  end

  #update
  def update_id(_id, fields = {}, opts = {}) #opts can be e.g. { :upsert => true }    
    fields[:updated_at] = Time.now
    opts[:return_document] = :after
    
    res = self.find_one_and_update({_id: _id}, {'$set' => fields}, opts)    
    return nil unless res
    {_id: _id}.merge(res).hwia
  end

  def set(crit, fields = {}, opts = {}) #opts['upsert'] == true to upsert     
    update(crit, {'$set' => fields.merge(updated_at: Time.now)}, opts)
  end
  
  def paginated_do(crit, opts = {}) #&block   
    find(crit).batch_size(1000).each {|item| yield(item)}
  end

  def fields
    mongo_coll_keys(self)
  end  

  #https://docs.mongodb.com/ecosystem/tutorial/ruby-driver-tutorial/#indexing
  def ensure_index(field, opts = {}) 
    indexes.create_one({field => 1}, opts)
  end

end #end Mongo Collection class 


get '/db/mongo_extension' do
  {refresh: true}
end