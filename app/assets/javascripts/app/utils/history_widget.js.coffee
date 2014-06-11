App.Utils.HistoryWidget = class

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
    @historyWidgets = []

    $(window).bind('popstate', @popState.bind(@))

    @setCurrentState(window.history.state || {})
    @setAsInitialized()

  @addWidget: (historyWidget) ->
    # remove link to widget if it was added before
    @historyWidgets.remove (widget) -> widget.id is historyWidget.id
    @historyWidgets.push(historyWidget)

  @supplementState: (options) ->
    {id, widgetState} = options

    state = window.history.state || {}
    state[id] = widgetState
    history.replaceState(state, null, location.href)

    @setCurrentState(state)

  @substractState: (id) ->
    state = window.history.state || {}
    delete state[id]
    history.replaceState(state, null, location.href)
    @setCurrentState(state)

  @pushNewState: (path, options) ->
    @fakeStatePopped = true
    {id, widgetState} = options

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

    state = e.originalEvent.state
    id = @_getChangedWidgetId(state)
    widget = @_getWidgetById(id)
    widgetState = @_getWidgetState(id, state)

    @setCurrentState(state)
    widget.callCallbacks(widgetState)

  @_getChangedWidgetId: (newState) ->
    changedId = null

    for own id, widgetState of newState
      for own curId, curWidgetState of @currentState()
        if id is curId and not _.isEqual(widgetState, curWidgetState)
          changedId = id
          break

    unless changedId
      for own curId, curWidgetState of @currentState()
        changedId = curId
        break

    changedId

  @_getWidgetById: (id) ->
    @historyWidgets.find (widget) -> widget.id is id

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
