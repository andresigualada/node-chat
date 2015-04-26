// Generated by CoffeeScript 1.9.2
(function() {
  $(function() {
    var $btn, $form, $input, $ul_clients, inputUserName, newChatter, removeChatter, renderMessage, sendMessage, server;
    $form = $('#form-new-message');
    $input = $("#input-new-message");
    $btn = $('#send-message');
    $ul_clients = $('#client-list>ul');
    inputUserName = function() {
      var username;
      return username = prompt('What\'s your name?');
    };
    newChatter = function(username) {
      var $li;
      $li = $("<li data-user='" + username + "'>" + username + "</li>");
      return $ul_clients.append($li);
    };
    removeChatter = function(username) {
      return $ul_clients.find("li[data-user='" + username + "']").remove();
    };
    sendMessage = function(e) {
      var message;
      e.preventDefault();
      message = $input.val();
      console.log(message);
      if (message !== '') {
        server.emit('message', message);
        return $input.val('');
      }
    };
    renderMessage = function(message) {
      var $li, $ul;
      $ul = $('#chat-window>ul');
      $li = $("<li>" + message + "</li>");
      return $ul.append($li);
    };
    server = io.connect('http://localhost:8080');
    server.on('connect', function(client) {
      return server.emit('join', inputUserName());
    });
    $form.on('submit', sendMessage);
    server.on('joined', function(username) {
      return newChatter(username);
    });
    server.on('message', function(message) {
      return renderMessage(message);
    });
    return server.on('remove chatter', function(username) {
      return removeChatter(username);
    });
  });

}).call(this);
