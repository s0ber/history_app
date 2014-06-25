@Histo = class

  @addWidget: (options = {}) ->
    @_launcher().initialize() unless @_launcher().isInitialized()
    widget = new App.Utils.HistoryWidget(options)

  @widgets: ->
    @_widgets ?= []

  @supplementState: (options) ->

  @pushNewState: (path, options) ->
    @_launcher().onBeforePushState()

  @onPopState: ->

  @_launcher: ->
    Histo.Launcher

