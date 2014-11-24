require 'sinatra'
require 'json'
require './save'

#create new user
#params - username
post '/api/user/new' do
  return_message ={}
  if params[:username] != '' &&
    if User.first(:name => params[:username])
      return_message[:status] = 'User already exist'
    else
      User.create(:name => params[:username])
      return_message[:status] = 'Success, user created'
    end
  else
    return_message[:status] = 'Failed to create user'
  end
  return_message.to_json
end

#add a new message to the conversation
#params - conversationID, messageText, username
post '/api/conversation/:id/messages/new' do
  return_message = {}
  if params[:message] != '' && params[:username] != ''
    if Conversation.get(params[:id])
      if User.all(:name => params[:username]).map(&:name).length > 0
        conversation = Conversation.get(params[:id])
        user = User.first(:name => params[:username])
        message = Message.create(:text => params[:message], :createdAt => Time.now)
        message.user = user
        message.save
        conversation.messages << message
        conversation.save
        conversation.messages.save
        return_message[:status] = 'Message sent'
      else
        return_message[:status] = 'User does not exist'
      end
    else
      return_message[:status] = 'Conversation does not exist'
    end
  else
    return_message[:status] = 'Failed to send message'
  end
  return_message.to_json
end

#create a conversation
#params - conversationName, username
post '/api/conversation/new' do
  return_message = {}
  if params[:conversationName] != '' && params[:username] != ''
    if User.all(:name => params[:username]).map(&:name).length > 0
      conversation = Conversation.create(:name => params[:conversationName])
      user = User.first(:name => params[:username])
      conversation.users << user
      conversation.save
      conversation.users.save
      return_message[:status] = 'Success, conversation created'
    else
      return_message[:status] = 'Failed to create conversation, no user found'
    end
  else
    return_message[:status] = 'Failed to create conversation, missing parameters'
  end
  return_message.to_json
end

#subscribe user to a conversation
#params - conversationID, username
post '/api/conversation/:id/subscribe' do
  return_message = {}
  if params[:id] != '' && params[:username] && Conversation.get(params[:id])
    if User.all(:name => params[:username]).map(&:name).length > 0
      conversation = Conversation.get(params[:id])
      user = User.first(:name => params[:username])
      conversation.users << user
      conversation.save
      conversation.users.save
      return_message[:status] = 'Success, user subscribed to conversation'
    else
      return_message[:status] = 'Failed, user does not exist'
    end
  else
    return_message[:status] = 'Failed, user could not subscribe to channel'
  end
  return_message.to_json
end

#get messages from conversation
#params - conversationID
get '/api/conversation/:id/messages' do
  return_message = {}
  if params[:id] != '' && Conversation.get(params[:id])
    conversation = Conversation.get(params[:id])
    return_message[:status] = 'Success'
    return_message[:messages] = conversation.messages
  else
    return_message[:status] = 'Failed'
  end
  return_message.to_json
end

#get the users from the conversations
#params - conversationID
get '/api/conversation/:id/users' do
  return_message = {}
  if params[:id] != '' && Conversation.get(params[:id])
    conversation = Conversation.get(params[:id])
    return_message[:status] = 'Success'
    return_message[:users] = conversation.users
  else
    return_message[:status] = 'Failed'
  end
  return_message.to_json
end

#get all the conversations
get '/api/conversations' do
  return_message = {}
  if Conversation.all.map(&:name).length > 0
    return_message[:status] = 'Success'
    return_message[:conversations] = Conversation.all
  else
    return_message[:status] = 'Failed'
  end
  return_message.to_json
end
