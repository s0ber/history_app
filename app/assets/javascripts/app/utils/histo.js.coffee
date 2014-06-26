@Histo = class

  @addWidget: (options = {}) ->
    @_launcher().initialize() unless @_launcher().isInitialized()
    widget = new Histo.Widget(options)

    @widgets ?= {}
    @widgets[widget.id] = widget

  @saveInitialStateAsCurrent: ->
    @saveCurrentState(window.location.state || {})

  @currentState: ->
    @_currentState

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

    {id, widgetState} = options
    widgetState.state_id = @currentState()[id].state_id + 1

    state = @currentState()
    state[id] = widgetState

    # remove jquery's resetting cache query string attribute
    path = Histo.Utils.removeURIParameter(path, '_')

    @_history().pushState(state, null, path)
    @saveCurrentState(state)

  @onPopState: (state) ->
    id = @_getChangedWidgetId(state)
    return unless id?

    widget = @widgets[id]
    widgetState = state[id]

    @saveCurrentState(state)
    widget.callCallbacks(widgetState)

# private

  @_getChangedWidgetId: (newState) ->
    changedId = null

    for own id, widgetState of newState
      for own curId, curWidgetState of @currentState()
        if id is curId and widgetState.state_id isnt curWidgetState.state_id and Math.abs(widgetState.state_id - curWidgetState.state_id) is 1
          changedId = id
          break
          break

    changedId

  @_launcher: ->
    Histo.Launcher

  @_history: ->
    window.history

