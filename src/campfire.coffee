Room    = require("./campfire/room").Room
Message = require("./campfire/message").Message

class Campfire
  constructor: (options) ->
    options = options or {}
    ssl     = !!options.ssl

    throw new Error "Please provide an API token" unless options.token
    throw new Error "Please provide an account name" unless options.account

    @http          = (if ssl then require "https" else require "http")
    @port          = (if ssl then 443 else 80)
    @domain        = "#{options.account}.campfirenow.com"
    @authorization = "Basic " + new Buffer(options.token + ":x").toString("base64")

  join: (id, callback) ->
    @room id, (error, room) ->
      return callback error if error
      room.join (error) ->
        callback error, room

  me: (callback) ->
    @get "/users/me", callback

  presence: (callback) ->
    @get "/presence", (error, response) =>
      rooms = (new Room @, room for room in response.rooms) if response
      callback error, rooms

  rooms: (callback) ->
    @get "/rooms", (error, response) =>
      rooms = (new Room @, room for room in response.rooms) if response
      callback error, rooms

  room: (id, callback) ->
    @get "/room/#{id}", (error, response) =>
      room = new Room @, response.room if response
      callback error, room

  search: (term, callback) ->
    @get "/search/#{term}", (error, response) =>
      messages = (new Message @, message for message in response.messages) if response
      callback error, messages

  user: (id, callback) ->
    @get "/users/#{id}", callback

  delete: (path, callback) ->
    @request "DELETE", path, "", callback

  get: (path, callback) ->
    @request "GET", path, null, callback

  post: (path, body, callback) ->
    @request "POST", path, body, callback

  request: (method, path, body, callback) ->
    headers =
      "Authorization": @authorization
      "Host": @domain
      "Content-Type": "application/json"

    if method is "POST" or method is "DELETE"
      body = JSON.stringify body unless typeof body is "string"
      headers["Content-Length"] = body.length

    opts =
      host: @domain
      port: @port
      method: method
      path: path
      headers: headers

    request = @http.request opts, (response) ->
      data = ""

      response.on "data", (chunk) ->
        data += chunk

      response.on "end", ->
        try
          data = JSON.parse data
          callback null, data 
        catch e
          callback new Error "Invalid JSON response"
 
    request.write body if method is "POST"
    request.end()

exports.Campfire = Campfire
