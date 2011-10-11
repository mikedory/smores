# Public: Represents a message from a Campfire room.
class Message
  # Public: Sets properties based on the specified data.
  #
  # @campfire - An instance of the Campfire class.
  # data      - An Object of message data.
  #           id         - An Integer of the message ID.
  #           body       - A String of the message body.
  #           type       - A String of the message type.
  #           room_id    - An Integer of the room ID.
  #           user_id    - An Integer of the user ID.
  #           created_at - A String of the created at date.
  #
  # Returns nothing.
  constructor: (@campfire, data) ->
    @id         = data.id
    @body       = data.body
    @type       = data.type
    @room_id    = data.room_id
    @user_id    = data.user_id
    @created_at = new Date data.created_at
    @path       = "/messages/#{@id}"

  # Public: Star the message.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  star: (callback) ->
    @post '/star', null, callback

  # Public: Unstar the message.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  unstar: (callback) ->
    @delete '/star', callback

  # A wrapper around the Campfire delete function.
  #
  # path     - A String of the path to be concatenated to the internal path.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  delete: (path, callback) ->
    @campfire.delete @path + path, callback

  # A wrapper around the Campfire post function.
  #
  # path     - A String of the path to be concatenated to the internal path.
  # body     - An Object or String of the request body
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  post: (path, body, callback) ->
    @campfire.post @path + path, body, callback

exports.Message = Message
