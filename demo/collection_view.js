namespace('Demo');

Demo.CollectionView = Backbone.View.extend({
  render: function() {
    this.$el.html("Ready to search...");
    return this;
  },

  showResults: function(tasksJson){
    var _this = this;
    this.$el.empty();
    _.each(tasksJson, function(task) {
      _this.$el.append(task.member_name);
    });
  },

  searchCriteriaCleared: function(){
    this.$el.empty();
  },

  showNoResults: function(){
    this.$el.html("Sorry, but there are no more tasks");
  },

  showError: function(response, statusCode) {
    this.$el.html("There was an error: " + response.responseText + " " + statusCode);
  }
});
