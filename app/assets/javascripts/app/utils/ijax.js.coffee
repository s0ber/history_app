class Ijax

  constructor: ->
    @requests = {}

  get: (path) ->
    request = new IjaxRequest(path)
    @requests[request.id] = request
    request.promise()

  removeRequest: (requestId) ->
    delete @requests[requestId]

  registerResponse: (requestId) ->
    @curRequest = @requests[requestId]

    @curRequest.registerResponse()
    @curRequest.resolve()

  pushLayout: (html) ->
    @curRequest.response.addLayout(html)

  pushFrame: (appendNodeId, frameHtml) ->
    @curRequest.response.addFrame(appendNodeId, frameHtml)

  resolveResponse: ->
    @curRequest.response.resolve()


class IjaxRequest

  constructor: (path) ->
    @dfd = new $.Deferred()

    @id = @getGuid()
    @path = URI(path).addQuery(format: 'al', i_req_id: @id, full_page: true).toString()
    @isResolved = false

    @iframe = @createIframeRequest()

    @dfd.fail =>
      @removeIframe()

    @iframe.onload = @updateIframeStatus.bind(@)

  promise: ->
    @dfd

  registerResponse: ->
    @response = new IjaxResponse()

  resolve: ->
    @isResolved = true
    @dfd.resolve(@response)

  updateIframeStatus: ->
    @removeIframe()
    @showError() unless @isResolved

  showError: ->
    console.log 'PIZDEC'

  createIframeRequest: (debug = false) ->
    src = @path or 'javascript:false'

    tmpElem = document.createElement('div')
    tmpElem.innerHTML = "<iframe name=\"#{@id}\" id=\"#{@id}\" src=\"#{src}\">"

    iframe = tmpElem.firstChild

    unless debug
      iframe.style.display = 'none'

    document.body.appendChild(iframe)
    iframe

  removeIframe: ->
    @iframe.parentNode.removeChild(@iframe)
    ijax.removeRequest(@id)

  getGuid: ->
    @_s4() + @_s4() + '-' + @_s4() + '-' + @_s4() + '-' + @_s4() + '-' + @_s4() + @_s4() + @_s4()

  _s4: ->
    Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1)

class IjaxResponse

  FRAMES_BATCH_COUNT = 5

  constructor: ->
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
    @onResolveCallback?()

  onLayoutReceive: (fn) ->
    @onLayoutReceiveCallback = fn
    @

  onResolve: (fn) ->
    @onResolveCallback = fn
    @

window.ijax = new Ijax()
