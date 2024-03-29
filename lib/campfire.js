(function() {
  var Campfire, Message, Room;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Room = require('./room').Room;
  Message = require('./message').Message;
  Campfire = (function() {
    function Campfire(options) {
      var ssl;
      options = options || {};
      ssl = !!options.ssl;
      if (!options.token) {
        throw new Error('Please provide an API token');
      }
      if (!options.account) {
        throw new Error('Please provide an account name');
      }
      this.http = (ssl ? require('https') : require('http'));
      this.port = (ssl ? 443 : 80);
      this.domain = "" + options.account + ".campfirenow.com";
      this.authorization = 'Basic ' + new Buffer(options.token + ':x').toString('base64');
    }
    Campfire.prototype.join = function(id, callback) {
      return this.room(id, function(error, room) {
        if (error) {
          return typeof callback === "function" ? callback(error) : void 0;
        }
        return room.join(function(error) {
          return typeof callback === "function" ? callback(error, room) : void 0;
        });
      });
    };
    Campfire.prototype.me = function(callback) {
      return this.get('/users/me', callback);
    };
    Campfire.prototype.presence = function(callback) {
      return this.get('/presence', __bind(function(error, response) {
        var room, rooms;
        if (response) {
          rooms = (function() {
            var _i, _len, _ref, _results;
            _ref = response.rooms;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              room = _ref[_i];
              _results.push(new Room(this, room));
            }
            return _results;
          }).call(this);
        }
        return typeof callback === "function" ? callback(error, rooms) : void 0;
      }, this));
    };
    Campfire.prototype.rooms = function(callback) {
      return this.get('/rooms', __bind(function(error, response) {
        var room, rooms;
        if (response) {
          rooms = (function() {
            var _i, _len, _ref, _results;
            _ref = response.rooms;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              room = _ref[_i];
              _results.push(new Room(this, room));
            }
            return _results;
          }).call(this);
        }
        return typeof callback === "function" ? callback(error, rooms) : void 0;
      }, this));
    };
    Campfire.prototype.room = function(id, callback) {
      return this.get("/room/" + id, __bind(function(error, response) {
        var room;
        if (response) {
          room = new Room(this, response.room);
        }
        return typeof callback === "function" ? callback(error, room) : void 0;
      }, this));
    };
    Campfire.prototype.search = function(term, callback) {
      return this.get("/search/" + term, __bind(function(error, response) {
        var message, messages;
        if (response) {
          messages = (function() {
            var _i, _len, _ref, _results;
            _ref = response.messages;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              message = _ref[_i];
              _results.push(new Message(this, message));
            }
            return _results;
          }).call(this);
        }
        return typeof callback === "function" ? callback(error, messages) : void 0;
      }, this));
    };
    Campfire.prototype.user = function(id, callback) {
      return this.get("/users/" + id, callback);
    };
    Campfire.prototype["delete"] = function(path, callback) {
      return this.request('DELETE', path, '', callback);
    };
    Campfire.prototype.get = function(path, callback) {
      return this.request('GET', path, null, callback);
    };
    Campfire.prototype.post = function(path, body, callback) {
      return this.request('POST', path, body, callback);
    };
    Campfire.prototype.request = function(method, path, body, callback) {
      var headers, opts, request;
      headers = {
        'authorization': this.authorization,
        'host': this.domain,
        'content-type': 'application/json'
      };
      if (method === 'POST' || method === 'DELETE') {
        if (typeof body !== 'string') {
          body = JSON.stringify(body);
        }
        headers['Content-Length'] = body.length;
      }
      opts = {
        host: this.domain,
        port: this.port,
        method: method,
        path: path,
        headers: headers
      };
      request = this.http.request(opts, function(response) {
        var data;
        data = '';
        response.on('data', function(chunk) {
          return data += chunk;
        });
        return response.on('end', function() {
          try {
            data = JSON.parse(data);
            return typeof callback === "function" ? callback(null, data) : void 0;
          } catch (e) {
            return typeof callback === "function" ? callback(new Error('Invalid JSON response')) : void 0;
          }
        });
      });
      if (method === 'POST') {
        request.write(body);
      }
      return request.end();
    };
    return Campfire;
  })();
  exports.Campfire = Campfire;
}).call(this);
