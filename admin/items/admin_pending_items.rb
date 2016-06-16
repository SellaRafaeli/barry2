get '/admin/pending_items' do 
  to_page(:"admin/pages/pending_items")
end

get '/admin/approve_pending_item' do
  $items.update_id(params[:item_id], status: ITEM_APPROVED_STATUS)
  halt_back('Marked item as approved.')
end

get '/admin/delete_pending_item' do
  $items.update_id(params[:item_id], status: ITEM_DELETED_STATUS)
  halt_back('Marked item as deleted.')
end