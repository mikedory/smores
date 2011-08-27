Message = require("./message").Message

class Room
  constructor: (@campfire, data) ->
    @id              = data.id
    @name            = data.name
    @topic           = data.topic
    @locked          = data.locked
    @createdAt       = new Date data.created_at
    @updatedAt       = new Date data.updated_at
    @membershipLimit = data.membership_limit

    @path            = "/room/#{@id}"

  join: (callback) ->
    @post "/join", "", callback

  leave: (callback) ->
    @post "/leave", "", callback

  listen: (callback) ->
   throw new Error "A callback must be provided for listening" unless callback instanceof Function

   campfire = @campfire
   options =
     host: "streaming.campfirenow.com"
     port: campfire.port
     method: "GET"
     path: "#{@path}/live.json"
     headers:
       Host: "streaming.campfirenow.com"
       Authorization: campfire.authorization

    request = campfire.http.request options, (response) ->
      response.setEncoding 'utf8'

      response.on "data", (data) ->
        data.split("\r").forEach (chunk) ->
          try
            data = JSON.parse chunk.trim()
          catch err
            return

          callback new Message campfire, data

    request.end()

  lock: (callback) ->
    @post "/lock", "", callback

  message: (text, type, callback) ->
    @post "/speak", message:
      body: text
      type: type
    , callback

  paste: (text, callback) ->
    @message text, "PasteMessage", callback

  messages: (callback) ->
    @get "/recent", (error, response) =>
      messages = new Message @campfire, message for message in response.messages if response
      callback error, messages

  show: (callback) ->
    @post "", "", callback

  sound: (text, callback) ->
    @message text, "SoundMessage", callback

  speak: (text, callback) ->
    @message text, "TextMessage", callback

  transcript: (date, callback) ->
    path = "/transcript"
    callback = callback or date
    path += "/#{date.getFullYear()}/#{date.getMonth()}/#{date.getDate()}" if date instanceof Date
    @get path, (error,response) =>
      messages = new Message @campfire, message for message in response.messages if response
      callback error, messages

  tweet: (url, callback) ->
    @message url, "TweetMessage", callback

  unlock: (callback) ->
    @post "/unlock", "", callback

  uploads: (callback) ->
    @get "/uploads", (error, response) ->
      uploads = response.uploads if response
      callback error, uploads

  get: (path, callback) ->
    @campfire.get @path + path, callback

  post: (path, body, callback) ->
    @campfire.post @path + path, body, callback

exports.Room = Room