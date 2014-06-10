#= require_self
#= require_tree ./utils
#= require_tree ./views

@App = {}
App.Views = {}
App.Utils = {}

class App.View extends Backbone.View
  utils: App.Utils
