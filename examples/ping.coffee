Campfire = require('../lib/campfire').Campfire

ROOM_ID = process.env.CAMPFIRE_ROOM_ID

campfire = new Campfire
  ssl: true
  token: process.env.CAMPFIRE_API_KEY
  account: process.env.CAMPFIRE_ACCOUNT

campfire.join ROOM_ID, (err, room) ->
  room.listen (message) ->
    if message.body is 'PING'
      console.log '=> PING received'
      room.speak 'PONG', (err, resp) ->
        console.log "<= PONG sent [#{resp.message.created_at}]"
