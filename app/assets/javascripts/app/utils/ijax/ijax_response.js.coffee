class @IjaxResponse

  FRAMES_BATCH_COUNT = 3

  constructor: ->
    @isResolved = false
    @frames = []

  addLayout: (layoutHtml) ->
    @onLayoutReceiveCallback?(layoutHtml)

  addFrame: (appendNodeId, frameHtml) ->
    @frames.push
      appendNodeId: appendNodeId
      html: frameHtml

    if @frames.length is FRAMES_BATCH_COUNT
      @renderFrames()

  renderFrames: ->
    for frame in @frames
      $appendNode = $("#append_#{frame.appendNodeId}")
      Vtree.DOM.after($appendNode, frame.html)
      $appendNode.remove()

    @frames.length = 0

  resolve: ->
    @renderFrames()
    @isResolved = true
    @onResolveCallback?()

  onLayoutReceive: (fn) ->
    @onLayoutReceiveCallback = fn
    @

  onResolve: (fn) ->
    @onResolveCallback = fn
    @

