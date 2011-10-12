# S'mores

## DESCRIPTION

S'mores is a [Campfire](http://campfirenow.com) library written in CoffeeScript for Node.

## INSTALLATION

1. Clone the repository
2. Change into the directory
3. Install the dependencies with `npm install`

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

Coming soon...

### Room

Coming soon...

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
