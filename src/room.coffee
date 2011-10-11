Message = require('./message').Message

# Public: Represents a Campfire room.
class Room
  # Public: Sets properties based on the specified data.
  #
  # @campfire - An instance of the Campfire class.
  # data      - An Object of room data.
  #           id               - An Integer of the room ID.
  #           name             - A String of the room name.
  #           topic            - A String of the room topic.
  #           locked           - A String of the locked status.
  #           created_at       - A String of the date/time the room was
  #                              created.
  #           updated_at       - A String of the date/time the room was
  #                              updated.
  #           membership_limit - An Integer of the maximum number of users in
  #                              the room.
  #
  # Returns nothing.
  constructor: (@campfire, data) ->
    @id               = data.id
    @name             = data.name
    @topic            = data.topic
    @locked           = data.locked
    @created_at       = new Date data.created_at
    @updated_at       = new Date data.updated_at
    @membership_limit = data.membership_limit
    @path             = "/room/#{@id}"
    @connection       = null

  # Public: Join the room. The response JSON is passed to the callback
  #         function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  join: (callback) ->
    @post '/join', '', callback

  # Public: Leave the room. The response JSON is passed to the callback
  #         function. Destorys the streaming HTTP request if the connection
  #         exists.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  leave: (callback) ->
    @connection.destroy() if @connection
    @post '/leave', '', callback

  # Public: Listen to the HTTP streaming API and call the callback function
  #         when a message is received.
  #
  # callback - A Function accepting a message instance.
  #
  # Returns nothing.
  listen: (callback) ->
   throw new Error 'A callback must be provided for listening' unless typeof callback is 'function'

   campfire = @campfire
   options =
     host: 'streaming.campfirenow.com'
     port: campfire.port
     method: 'GET'
     path: "#{@path}/live.json"
     headers:
       'Host': 'streaming.campfirenow.com'
       'Authorization': campfire.authorization

    request = campfire.http.request options, (response) =>
      @connection = response.connection
      response.setEncoding 'utf8'
      response.on 'data', (data) ->
        for chunk in data.split("\r")
          try
            data = JSON.parse chunk.trim()
            callback? new Message campfire, data
          catch e
            return

    request.end()

  # Public: Lock the room. The response JSON is passed to the callback.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  lock: (callback) ->
    @post '/lock', '', callback

  # Public: Send a message of the specified type. The response JSON is passed
  #         to the callback function.
  #
  # text     - A String of the message body.
  # type     - A String of the message type.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  message: (text, type, callback) ->
    @post '/speak', { message: { body: text, type: type } }, callback

  # Public: Send a paste message. The response JSON is passed to the callback
  #         function.
  #
  # text     - A String of the paste message body.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  paste: (text, callback) ->
    @message text, 'PasteMessage', callback

  # Public: Get an array of recent messages. The array of messages is passed to
  #         the callback function.
  #
  # callback - A Function accepting an error message and array of messages.
  #
  # Returns nothing.
  messages: (callback) ->
    @get '/recent', (error, response) =>
      messages = (new Message @campfire, message for message in response.messages) if response
      callback? error, messages

  # Public: Get the existing room and all users currently inside it. The
  #         response JSON is passed to the callback function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  show: (callback) ->
    @post '', '', callback

  # Public: Send a sound message. The response JSON is passed to the callback
  #         function.
  #
  # text     - A String of the sound item to play.
  # callback - A Function accepting an error message and array of messages.
  #
  # Returns nothing.
  sound: (text, callback) ->
    @message text, 'SoundMessage', callback

  # Public: Send a text message. The response JSON is passed to the callback
  #         function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  speak: (text, callback) ->
    @message text, 'TextMessage', callback

  # Public: Get an array of transcripts for an optional date. The array of
  #         messages is passed to the callback function.
  #
  # date     - An optional Date of the day to get the transcript for.
  # callback - A Function accepting an error message and array of messages.
  # 
  # Returns nothing.
  transcript: (date, callback) ->
    path = '/transcript'
    callback = callback or date
    path += "/#{date.getFullYear()}/#{date.getMonth()}/#{date.getDate()}" if date instanceof Date
    @get path, (error,response) =>
      messages = (new Message @campfire, message for message in response.message) if response
      callback? error, messages

  # Public: Send a tweet message. The response JSON is passed to the callback
  #         function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  tweet: (url, callback) ->
    @message url, 'TweetMessage', callback

  # Public: Unlock the room. The response JSON is passed to the callback
  #         function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  unlock: (callback) ->
    @post '/unlock', '', callback

  # Public: Get a JSON object of uploads. The response JSON will be passed to
  #         the callback function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  uploads: (callback) ->
    @get '/uploads', (error, response) ->
      uploads = response.uploads if response
      callback? error, uploads

  # A wrapper around the Campfire get function.
  #
  # path     - A String of the path to be concatenated to the internal path.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  get: (path, callback) ->
    @campfire.get @path + path, callback

  # A wrapper around the Campfire post function.
  #
  # path     - A String of the path to be concatenated to the internal path.
  # body     - An Object or String of the request body
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  post: (path, body, callback) ->
    @campfire.post @path + path, body, callback

exports.Room = Room
