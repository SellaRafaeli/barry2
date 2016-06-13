# Not Used!

# def get_google_bucket
#   puts 'getting google bucket...'
#   Faraday.default_adapter = :httpclient

#   # Only add the following statement if using Faraday >= 0.9.2
#   # Override gzip middleware with no-op for httpclient
#   Faraday::Response.register_middleware :gzip => Faraday::Response::Middleware
#   @gcloud  ||= Gcloud.new.storage
#   @bucket  ||= @gcloud.bucket 'barry2'
# end

# def upload_to_gcloud_storage(local_path, remote_path = nil)
#   @bucket     ||= get_google_bucket  
#   remote_path ||= local_path
#   @bucket.create_file local_path, remote_path
# end

# def upload_zip_to_gcloud(local_path)
#   upload_to_gcloud_storage(local_path,'zips/'+nice_id)
# end

# def get_signed_url_for_new_file
#   @bucket ||= get_google_bucket
#   file = upload_to_gcloud_storage('./gcloud_placeholder.txt', 'zips/'+nice_id)
#   shared_url = file.signed_url method: "POST", expires: 600 # 10 minutes from now
# end