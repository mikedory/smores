(function() {
  var Message;
  Message = (function() {
    function Message(campfire, data) {
      this.campfire = campfire;
      this.id = data.id;
      this.body = data.body;
      this.type = data.type;
      this.room_id = data.room_id;
      this.user_id = data.user_id;
      this.created_at = new Date(data.created_at);
      this.path = "/messages/" + this.id;
    }
    Message.prototype.star = function(callback) {
      return this.post('/star', null, callback);
    };
    Message.prototype.unstar = function(callback) {
      return this["delete"]('/star', callback);
    };
    Message.prototype["delete"] = function(path, callback) {
      return this.campfire["delete"](this.path + path, callback);
    };
    Message.prototype.post = function(path, body, callback) {
      return this.campfire.post(this.path + path, body, callback);
    };
    return Message;
  })();
  exports.Message = Message;
}).call(this);
