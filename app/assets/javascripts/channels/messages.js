App.messages = App.cable.subscriptions.create('ApplicationCable::FeatureFlagsChannel', {
  received: function(data) {
    $("#messages").removeClass('hidden');
    return $('#messages').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>";
  }
});
