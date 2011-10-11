Room    = require('./room').Room
Message = require('./message').Message

# Public: Handles the connection to the Campfire API.
class Campfire
  # Public: Configures the connection to the Campfire API.
  #
  # options - Hash of options.
  #           token   - A String of your Campfire API token.
  #           account - A String of your Campfire account.
  #           ssl     - A Boolean of whether to use SSL or not.
  #
  # Returns nothing.
  # Raises Error if no token is supplied.
  # Raises Error if no account is supplied.
  constructor: (options) ->
    options = options or {}
    ssl = !!options.ssl

    throw new Error 'Please provide an API token' unless options.token
    throw new Error 'Please provide an account name' unless options.account

    @http = (if ssl then require 'https' else require 'http')
    @port = (if ssl then 443 else 80)

    @domain = "#{options.account}.campfirenow.com"
    @authorization = 'Basic ' + new Buffer(options.token + ':x').toString('base64')

  # Public: Join a Campfire room by ID. The room instance is passed to the
  #         callback function.
  #
  # id       - An Integer room ID for the Campfire room.
  # callback - An optional Function accepting an error message and room
  #            instance.
  #
  # Returns nothing.
  join: (id, callback) ->
    @room id, (error, room) ->
      return callback? error if error
      room.join (error) ->
        callback? error, room

  # Public: Get a JSON representation of the authenticated user making the
  #         request. The JSON is passed to the callback function.
  #
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  me: (callback) ->
    @get '/users/me', callback

  # Public: Get the rooms the authenticated user is in. The array of rooms is
  #         passed to the callback function.
  #
  # callback - A Function accepting an error message and array of room
  #            instances.
  #
  # Returns nothing.
  presence: (callback) ->
    @get '/presence', (error, response) =>
      rooms = (new Room @, room for room in response.rooms) if response
      callback? error, rooms

  # Public: Get the rooms the authenticated user is able to join. The array of
  #         rooms is passed to the callback function.
  #
  # callback - A Function accepting an error message and array of room
  #            instances.
  #
  # Returns nothing.
  rooms: (callback) ->
    @get '/rooms', (error, response) =>
      rooms = (new Room @, room for room in response.rooms) if response
      callback? error, rooms

  # Public: Get a room instance for the specified room ID. The room instance
  #         is passed to the callback function.
  #
  # id       - An Integer room ID for the Campfire room.
  # callback - A Function accepting an error message and room instance.
  #
  # Returns nothing.
  room: (id, callback) ->
    @get "/room/#{id}", (error, response) =>
      room = new Room @, response.room if response
      callback? error, room

  # Public: Get all messages which contain the specified search term. The array
  #         of rooms is passed to the callback function.
  #
  # term     - A String of the search term.
  # callback - A Function accepting an error message and array of message
  #            instances.
  #
  # Returns nothing.
  search: (term, callback) ->
    @get "/search/#{term}", (error, response) =>
      messages = (new Message @, message for message in response.messages) if response
      callback? error, messages

  # Public: Get a user instance for the specified user ID. The user instance
  #         is passed to the callback function.
  #
  # id       - An Integer of the user ID.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  user: (id, callback) ->
    @get "/users/#{id}", callback

  # Public: Performs a HTTP DELETE request. The response JSON is passed to the
  #         callback function.
  #
  # path     - A String of the path to request.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  delete: (path, callback) ->
    @request 'DELETE', path, '', callback

  # Public: Performs a HTTP GET request. The response JSON is passed to the
  #         callback function.
  #
  # path     - A String of the path to request.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  get: (path, callback) ->
    @request 'GET', path, null, callback

  # Public: Performs a HTTP POST request. The response JSON is passed to the
  #         callback function.
  #
  # path     - A String of the path to request.
  # body     - An Object or String for the request body.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  post: (path, body, callback) ->
    @request 'POST', path, body, callback

  # Performs an HTTP or HTTPS request. The response JSON is passed to the
  #   callback function.
  #
  # method   - A String of the HTTP method.
  # path     - A String of the path to request.
  # body     - An Object or String for the request body.
  # callback - A Function accepting an error message and JSON result.
  #
  # Returns nothing.
  request: (method, path, body, callback) ->
    headers = 'authorization': @authorization, 'host': @domain, 'content-type': 'application/json'

    if method is 'POST' or method is 'DELETE'
      body = JSON.stringify body unless typeof body is 'string'
      headers['Content-Length'] = body.length

    opts =
      host: @domain
      port: @port
      method: method
      path: path
      headers: headers

    request = @http.request opts, (response) ->
      data = ''

      response.on 'data', (chunk) ->
        data += chunk

      response.on 'end', ->
        try
          data = JSON.parse data
          callback? null, data
        catch e
          callback? new Error 'Invalid JSON response'
 
    request.write body if method is 'POST'
    request.end()

exports.Campfire = Campfire
