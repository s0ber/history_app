class App.Utils.HistoryWidget

  constructor: (options = {}) ->
    return unless options.id
    @id = options.id
    @popedStateCallbacks = []

    HistoryApi.initialize()
    HistoryApi.addWidget(@)

  replaceInitialState: (widgetState) ->
    HistoryApi.supplementState(id: @id, widgetState: widgetState)

  removeState: ->
    HistoryApi.substractState(@id)

  onPopState: (callback) ->
    @popedStateCallbacks.push(callback)

  pushNewState: (path, widgetState) ->
    HistoryApi.pushNewState(path, id: @id, widgetState: widgetState)

  callCallbacks: (widgetState) ->
    callback(widgetState) for callback in @popedStateCallbacks

HistoryApi = class

  @initialize: ->
    return if @isInitialized()
    @fakeStatePopped = false
    @initialUrl = location.href
    @historyWidgets = {}

    window.onpopstate = @popState.bind(@)

    @setCurrentState(window.history.state || {})
    @setAsInitialized()

  @addWidget: (historyWidget) ->
    # remove link to widget if it was added before
    @historyWidgets[historyWidget.id] = historyWidget

  @supplementState: (options) ->
    {id, widgetState} = options
    widgetState.state_id = 0

    state = window.history.state || {}
    widgetState.state_id =
      if (curStateId = state[id]?.state_id)?
        curStateId
      else
        0

    state[id] = widgetState
    history.replaceState(state, null, location.href)

    @setCurrentState(state)

  @pushNewState: (path, options) ->
    @fakeStatePopped = true
    {id, widgetState} = options

    widgetState.state_id =
      if (curStateId = @currentState()[id]?.state_id)?
        curStateId + 1
      else
        0

    state = Object.clone(@currentState())
    state[id] = widgetState

    # remove jquery's resetting cache query string attribute
    path = URI(path).removeSearch('_')
    history.pushState(state, null, path)

    @setCurrentState(state)

  @popState: (e) ->
    if location.href is @initialUrl and not @fakeStatePopped
      @fakeStatePopped = true
      return

    @fakeStatePopped = true

    state = e.state
    id = @_getChangedWidgetId(state)
    widget = @historyWidgets[id]
    widgetState = @_getWidgetState(id, state)

    @setCurrentState(state)
    widget.callCallbacks(widgetState)

  @_getChangedWidgetId: (newState) ->
    changedId = null

    for own id, widgetState of newState
      for own curId, curWidgetState of @currentState()
        if id is curId and widgetState.state_id isnt curWidgetState.state_id and Math.abs(widgetState.state_id - curWidgetState.state_id) is 1
          changedId = id
          break

    changedId

  @_getWidgetState: (id, state) ->
    state[id]

  # accessors

  @isInitialized: ->
    @_isInitialized

  @setAsInitialized: ->
    @_isInitialized = true

  @currentState: ->
    @_currentState

  @setCurrentState: (state) ->
    @_currentState = Object.clone(state)
