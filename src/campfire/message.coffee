class Message
  constructor: (@campfire, data) ->
    @id        = data.id
    @body      = data.body
    @type      = data.type
    @roomId    = data.room_id
    @userId    = data.user_id
    @createdAt = new Date data.created_at
    @path      = "/messages/#{@id}"

  star: (callback) ->
    @post '/star', null, callback

  unstar: (callback) ->
    @delete '/star', callback

  delete: (path, callback) ->
    @campfire.delete @path + path, callback

  post: (path, body, callback) ->
    @campfire.post @path + path, body, callback

exports.Message = Message
