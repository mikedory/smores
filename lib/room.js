(function() {
  var Message, Room;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Message = require('./message').Message;
  Room = (function() {
    function Room(campfire, data) {
      this.campfire = campfire;
      this.id = data.id;
      this.name = data.name;
      this.topic = data.topic;
      this.locked = data.locked;
      this.created_at = new Date(data.created_at);
      this.updated_at = new Date(data.updated_at);
      this.membership_limit = data.membership_limit;
      this.path = "/room/" + this.id;
      this.connection = null;
    }
    Room.prototype.join = function(callback) {
      return this.post('/join', '', callback);
    };
    Room.prototype.leave = function(callback) {
      if (this.connection) {
        this.connection.destroy();
      }
      return this.post('/leave', '', callback);
    };
    Room.prototype.listen = function(callback) {
      var campfire, options, request;
      if (!(callback instanceof Function)) {
        throw new Error('A callback must be provided for listening');
      }
      campfire = this.campfire;
      options = {
        host: 'streaming.campfirenow.com',
        port: campfire.port,
        method: 'GET',
        path: "" + this.path + "/live.json",
        headers: {
          'Host': 'streaming.campfirenow.com',
          'Authorization': campfire.authorization
        }
      };
      request = campfire.http.request(options, __bind(function(response) {
        this.connection = response.connection;
        response.setEncoding('utf8');
        return response.on('data', function(data) {
          var chunk, _i, _len, _ref;
          _ref = data.split("\r");
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            chunk = _ref[_i];
            try {
              data = JSON.parse(chunk.trim());
              if (typeof callback === "function") {
                callback(new Message(campfire, data));
              }
            } catch (e) {
              return;
            }
          }
        });
      }, this));
      return request.end();
    };
    Room.prototype.lock = function(callback) {
      return this.post('/lock', '', callback);
    };
    Room.prototype.message = function(text, type, callback) {
      return this.post('/speak', {
        message: {
          body: text,
          type: type
        }
      }, callback);
    };
    Room.prototype.paste = function(text, callback) {
      return this.message(text, 'PasteMessage', callback);
    };
    Room.prototype.messages = function(callback) {
      return this.get('/recent', __bind(function(error, response) {
        var message, messages;
        if (response) {
          messages = (function() {
            var _i, _len, _ref, _results;
            _ref = response.messages;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              message = _ref[_i];
              _results.push(new Message(this.campfire, message));
            }
            return _results;
          }).call(this);
        }
        return typeof callback === "function" ? callback(error, messages) : void 0;
      }, this));
    };
    Room.prototype.show = function(callback) {
      return this.post('', '', callback);
    };
    Room.prototype.sound = function(text, callback) {
      return this.message(text, 'SoundMessage', callback);
    };
    Room.prototype.speak = function(text, callback) {
      return this.message(text, 'TextMessage', callback);
    };
    Room.prototype.transcript = function(date, callback) {
      var path;
      path = '/transcript';
      callback = callback || date;
      if (date instanceof Date) {
        path += "/" + (date.getFullYear()) + "/" + (date.getMonth()) + "/" + (date.getDate());
      }
      return this.get(path, __bind(function(error, response) {
        var message, messages;
        if (response) {
          messages = (function() {
            var _i, _len, _ref, _results;
            _ref = response.message;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              message = _ref[_i];
              _results.push(new Message(this.campfire, message));
            }
            return _results;
          }).call(this);
        }
        return typeof callback === "function" ? callback(error, messages) : void 0;
      }, this));
    };
    Room.prototype.tweet = function(url, callback) {
      return this.message(url, 'TweetMessage', callback);
    };
    Room.prototype.unlock = function(callback) {
      return this.post('/unlock', '', callback);
    };
    Room.prototype.uploads = function(callback) {
      return this.get('/uploads', function(error, response) {
        var uploads;
        if (response) {
          uploads = response.uploads;
        }
        return typeof callback === "function" ? callback(error, uploads) : void 0;
      });
    };
    Room.prototype.get = function(path, callback) {
      return this.campfire.get(this.path + path, callback);
    };
    Room.prototype.post = function(path, body, callback) {
      return this.campfire.post(this.path + path, body, callback);
    };
    return Room;
  })();
  exports.Room = Room;
}).call(this);
