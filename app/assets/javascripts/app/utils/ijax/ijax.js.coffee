class Ijax

  constructor: ->
    @requests = {}

  get: (path) ->
    @abortCurrentRequest()

    @curRequest = request = new IjaxRequest(path)
    @requests[request.id] = request
    request

  abortCurrentRequest: ->
    hasUnresolvedRequest = @curRequest? and not @curRequest.isResolved
    hasUnresolvedResponse = @curRequest? and not @curRequest.response?.isResolved

    @curRequest.reject() if hasUnresolvedRequest or hasUnresolvedResponse

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

window.ijax = new Ijax()
