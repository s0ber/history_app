App.Utils.HistoryApiSupport = class

  constructor: ->
    @fakeStatePopped = false
    @initialUrl = location.href
    @popedStateCallbacks = []

    $(window).bind('popstate', @_popState.bind(@))

  replaceInitialState: (state) ->
    history.replaceState(state.data, null, state.path || @initialUrl)

  pushNewState: (state) ->
    @fakeStatePopped = true
    history.pushState(state.data, null, state.path)

  onPopState: (callback) ->
    @popedStateCallbacks.push(callback)

  _popState: (e) ->
    if location.href is @initialUrl and not @fakeStatePopped
      @fakeStatePopped = true
      return

    @fakeStatePopped = true
    callback(e.originalEvent) for callback in @popedStateCallbacks
