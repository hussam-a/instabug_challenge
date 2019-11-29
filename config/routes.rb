Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/applications/create', to: 'apps#get_token'
  get '/applications/:app_token/chats/count', to: 'apps#get_chats_count'
  delete '/applications/:app_token/delete', to: 'apps#delete_app'
  
  post '/applications/:app_token/chats/create', to: 'chats#post_chat'
  get '/applications/:app_token/chats/get', to: 'chats#get_chats'
  get '/applications/:app_token/chats/:chat_number/messages/count', to: 'chats#get_messages_count'
  delete '/applications/:app_token/chats/:chat_number/delete', to: 'chats#delete_chat'

  post '/applications/:app_token/chats/:chat_number/messages/create', to: 'messages#post_message'
  get '/applications/:app_token/chats/:chat_number/messages/get', to: 'messages#get_messages'
  get '/applications/:app_token/chats/:chat_number/messages/:message_number/get', to: 'messages#get_message'
  put '/applications/:app_token/chats/:chat_number/messages/:message_number/update', to: 'messages#update_message'
  delete '/applications/:app_token/chats/:chat_number/messages/:message_number/delete', to: 'messages#delete_message'

  get '/applications/:app_token/chats/:chat_number/search', to: 'message_search#search'

  get '*path' => redirect('/')

end
