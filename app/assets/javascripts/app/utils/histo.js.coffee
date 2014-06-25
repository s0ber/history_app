@Histo = class

  @addWidget: (options = {}) ->
    @_launcher().initialize() unless @_launcher().isInitialized()
    widget = new Histo.Widget(options)

    @widgets ?= {}
    @widgets[widget.id] = widget

  @saveInitialStateAsCurrent: ->
    @saveCurrentState(window.location.state || {})

  @saveCurrentState: (state) ->
    @_currentState = _.clone(state)


  @supplementState: (options) ->
    {id, widgetState} = options

    state = @_history().state || {}
    widgetState.state_id =
      if (curStateId = state[id]?.state_id)?
        curStateId
      else
        0

    state[id] = widgetState
    @_history().replaceState(state, null, location.href)
    @saveCurrentState(state)

  @pushNewState: (path, options) ->
    @_launcher().onBeforePushState()

  @onPopState: ->

  @_launcher: ->
    Histo.Launcher

  @_history: ->
    window.history

