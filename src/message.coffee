class Message
  constructor: (@campfire, data) ->
    @id         = data.id
    @body       = data.body
    @type       = data.type
    @room_id    = data.room_id
    @user_id    = data.user_id
    @created_at = new Date data.created_at
    @path       = "/messages/#{@id}"

  star: (callback) ->
    @post '/star', null, callback

  unstar: (callback) ->
    @delete '/star', callback

  delete: (path, callback) ->
    @campfire.delete @path + path, callback

  post: (path, body, callback) ->
    @campfire.post @path + path, body, callback

exports.Message = Message
