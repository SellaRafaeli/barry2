$user_settings = $mongo.collection('user_settings')

$user_settings.ensure_index('user_id')

post '/update_my_settings' do
  data = params.just(USFN)
  data[:user_id] = cuid
  $user_settings.update_one({user_id: cuid},data,{upsert: true})
  back_with_msg('Updated Settings.')
end

USF = USER_SETTINGS_FIELDS = [
  {name: 'setting3', type: :bool},
  {name: 'setting5', type: :text},
  {name: 'setting6', type: :multi, opts: ['Foo', 'Bar', 'Baz']}
]

USFN = USER_SETTINGS_FIELDS_NAMES = USER_SETTINGS_FIELDS.mapo(:name)



