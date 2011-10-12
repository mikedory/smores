# S'mores

## DESCRIPTION

S'mores is a [Campfire](http://campfirenow.com) library written in CoffeeScript for Node.

## INSTALLATION

### For Your Project

* Install the library in your project directory with `npm install sooty`

### For Development

1. Clone the repository
2. Change into the directory
3. Install dependencies with `npm install`

## USAGE

The simplest example of using Smores as a bot that listens for the text `PING`.

```coffeescript
Campfire = require('smores').Campfire

campfire = new Campfire ssl: true, token: 'api_token', account: 'subdomain'

campfire.join 12345, (error, room) ->
  room.listen (message) ->
    if message.body is 'PING'
      console.log 'PING received, sending PONG'
      room.speak 'PONG', (error, response) ->
        console.log 'PONG sent'
```

### Campfire

The API for the `Campfire` class is explained below with examples of using each
function.

Unless otherwise stated the callback functions will have any errors as the
first parameter and the response of the request as the second parameter which
is specific to the function.

#### Constructor

The constructor of the `Campfire` class configures properties for connecting to
the Campfire API.

Example:

```coffeescript
options = token: "your.api.token", account: "your.accout.subdomain", ssl: true
campfire = new Campfire options
```

#### Join

The `join` function will join a room with the specified room ID.

Example:

```coffeescript
campfire.join 12345, (error, room) ->
  if error or not room
    console.log error or 'Could not join room 12345'
  else
    console.log room
```

#### Me

The `me` function will get a JSON representation of the currently authenticated
user.

Example:

```coffeescript
campfire.me (error, me) ->
  if error or not me
    console.log error or 'Could not get current user information'
  else
    console.log me
```

#### Presence

The `presence` function will get an array of `Room` instances for every room
that the currently authenticated user is in.

Example:

```coffeescript
campfire.presence (error, rooms) ->
  if error or not rooms
    console.log error or 'Could not get the presence for the current user'
  else
    console.log room for room in rooms
```

#### Rooms

The `rooms` function will get an array of `Room` instances for every room
that the currently authenticated user is able to join.

Example:

```coffeescript
campfire.rooms (error, rooms) ->
  if error or not rooms
    console.log error or 'Could not get the rooms the current user can join'
  else
    console.log room for room in rooms
```

#### Room

The `room` function will get a `Room` instance for the room with the specified
room ID.

Example:

```coffeescript
campfire.room 12345, (error, room) ->
  if error or not room
    console.log error or 'Could not get room info for 12345'
  else
    console.log room
```

#### Search

The `search` function will get an array of `Message` instances which contain
the specified search term.

Example:

```coffeescript
campfire.search 'pickles', (error, messages) ->
  if error or not messages
    console.log error or 'Could not find search results for pickles'
  else
    console.log message for message in messages
```

#### User

The `user` function will get a JSON representation of a user with the specified
ID.

Example:

```coffeescript
campfire.user 12345, (error, user) ->
  if error or not user
    console.log error or 'Could not find user info for 12345'
  else
    console.log user
```

### Message

The API for the `Message` class is explained below with examples of using each
function.

Unless otherwise stated the callback functions will have any errors as the
first parameter and the response of the request as the second parameter which
is specific to the function.

#### Constructor

The constructor of the `Message` class configures properties for the message
data that this instance represents.

The constructor is only called internally, and not by a user.

#### Properties

* `id` - the ID of the message
* `body` - the body text of the message
* `type` - the type of the message
* `room_id` - the ID of the room that message came from
* `user_id` - the ID of the user that sent the message
* `created_at` - the date/time the message was sent

#### Star

The `star` function stars the message for the authenticated user.

Example:

```coffeescript
message.star (error, response) ->
  if error or not response
    console.log error or 'Could not star the message'
  else
    console.log response
```

#### Unstar

The `unstar` function unstars the message for the authenticated user.

Example:

```coffeescript
message.unstar (error, response) ->
  if error or not response
    console.log error or 'Could not unstar the message'
  else
    console.log response
```

### Room

The API for the `Room` class is explained below with examples of using each
function.

Unless otherwise stated the callback functions will have any errors as the
first parameter and the response of the request as the second parameter which
is specific to the function.

#### Constructor

The constructor of the `Room` class configures properties for the room data
hat this instance represents.

The constructor is only called internally, and not by a user.

#### Properties

* `id` - the ID of the room
* `name` - the name of the room
* `topic` - the topic of the room
* `locked` - the locked status of the room, `true` or `false`
* `created_at` - the date/time the room was created
* `updated_at` - the date/time the room was updated
* `membership_limit` - the maximum number of users allowed in the room

#### Join

The `join` function will join the room that this instance represents.

Example:

```coffeescript
room.join (error, response) ->
  if error or not response
    console.log error or 'Could not join room'
  else
    console.log response
```

#### Leave

The `leave` function will leave the room that this instance represents. If this
instance is also connected to the streaming API by the `listen` method it will
also destroy the connection to that.

Example:

```coffeescript
room.leave (error, response) ->
  if error or not response
    console.log error or 'Could not leave room'
  else
    console.log response
```

#### Listen

The `listen` function will connect to the streaming API and stream incoming
messages to the callback function. The callback function for `listen` will
only require a single parameter which is the message received.

Example:

```coffeescript
room.listen (message) ->
  console.log message
```

#### Lock

The `lock` function will lock the room that this instance represents.

Example:

```coffeescript
room.lock (error, response) ->
  if error or not response
    console.log error or 'Could not lock room'
  else
    console.log response
```

#### Message

The `message` function sends a message of the specified type. It is usually
best to use one of the following abstracted functions.

* `paste`
* `sound`
* `speak`
* `tweet`

Example:

```coffeescript
room.message 'Hello world!', 'TextMessage', (error, response) ->
  if error or not response
    console.log error or 'Could not send message'
  else
    console.log response
```

#### Paste

The `paste` function sends paste message.

Example:

```coffeescript
room.paste 'Some funky paste formatted message', (error, response) ->
  if error or not response
    console.log error or 'Could not send paste message'
  else
    console.log response
```

#### Messages

The `messages` function will get an array of `Messages` for the latest messages
to the room.

Example:

```coffeescript
room.messages (error, messages) ->
  if error or not messages
    console.log error or 'Could not get recent messages'
  else
    console.log message for message in messages
```

#### Show

The `show` function will get a JSON representation of the room and the users
currently in it.

Example:

```coffeescript
room.show (error, response) ->
  if error or not response
    console.log error or 'Could not get info for room'
  else
    console.log response
```

#### Sound

The `sound` function will send a sound message.

Example:

```coffeescript
room.sound 'drama', (error, response) ->
  if error or not response
    console.log error or 'Could not send sound message'
  else
    console.log response
```

#### Speak

The `speak` function will send a text message.

Example:

```coffeescript
room.speak 'Hello!', (error, response) ->
  if error or not response
    console.log error or 'Could not send message'
  else
    console.log response
```

#### Transcript

The `transcript` function will get an array of messages for today or the
specified date.

Example:

```coffeescript
# get messages from today
room.transcript (error, messages) ->
  if error or not messages
    console.log error or 'Could not get messages for today'
  else
    console.log message for message in messages

# get messages for 25/12/2010
room.transcript new Date('25/12/2010'), (error, response) ->
  if error or not response
    console.log error or 'Could not get messages for 25/12/2010'
  else
    console.log message for message in messages
```

#### Tweet

The `tweet` function will send a message of a formatted Twitter status for the
specified tweet status URL.

Example:

```coffeescript
room.tweet 'http://twitter.com/#!/37signals/status/123814446958264321', (error, response) ->
  if erorr or not response
    console.log error or 'Could not send tweet message'
  else
    console.log response
```

#### Unlock

The `unlock` function will unlock the room that this instance represents.

Example:

```coffeescript
room.unlock (error, response) ->
  if error or not response
    console.log error or 'Could not unlock the room'
  else
    console.log response
```

#### Uploads

The `uploads` function will get a JSON representation of the uploads uploaded
to the room.

Example:

```coffeescript
room.uploads (error, response) ->
  if error or not response
    console.log error or 'Could not find uploads for the room'
  else
    console.log response
```

## CONTRIBUTE

Here's the most direct way to get your work merged into the project:

1. Fork the project
2. Clone down your fork
3. Create a feature branch
4. Hack away and add tests. Not necessarily in that order
5. Make sure everything still passes by running tests
6. If necessary, rebase your commits into logical chunks, without errors
7. Push the branch up
8. Send a pull request for your branch

## LICENSE

The MIT License

Copyright (c) 2011 Tom Bell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
