(function() {
  var Campfire, ROOM_ID, campfire;
  Campfire = require('../lib/campfire').Campfire;
  ROOM_ID = process.env.CAMPFIRE_ROOM_ID;
  campfire = new Campfire({
    ssl: true,
    token: process.env.CAMPFIRE_API_KEY,
    account: process.env.CAMPFIRE_ACCOUNT
  });
  campfire.join(ROOM_ID, function(err, room) {
    return room.listen(function(message) {
      if (message.body === 'PING') {
        console.log('=> PING received');
        return room.speak('PONG', function(err, resp) {
          return console.log("<= PONG sent [" + resp.message.created_at + "]");
        });
      }
    });
  });
}).call(this);
