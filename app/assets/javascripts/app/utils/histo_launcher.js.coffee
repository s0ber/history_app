@Histo.Launcher = class

  @initialize: ->
    @_isInitialized = true

    @_fakeStatePopped = false
    @_initialUrl = location.href
    window.onpopstate = @_popState.bind(@)
    Histo.saveInitialStateAsCurrent()

  @unload: ->
    @_isInitialized = false

    @_fakeStatePopped = false
    window.onpopstate = null

  @isInitialized: ->
    @_isInitialized

  @onBeforePushState: ->
    @_fakeStatePopped = true

  @_popState: (e) ->
    if location.href is @_initialUrl and not @_fakeStatePopped
      @_fakeStatePopped = true
      return

    @_fakeStatePopped = true

    Histo.onPopState(e?.state)

