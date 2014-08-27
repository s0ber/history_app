class Ijax

  constructor: ->
    @requests = {}

  get: (path) ->
    request = new IjaxRequest(path)
    @requests[request.id] = request
    request.promise()

  removeRequest: (requestId) ->
    delete @requests[requestId]

  pushHtml: (requestId, html) ->
    request = @requests[requestId]
    request.resolveWithHtml(html)

class IjaxRequest

  constructor: (path) ->
    @dfd = new $.Deferred()
    @id = @getGuid()
    @path = URI(path).addQuery(format: 'al', i_req_id: @id, full_page: true).toString()
    @isResolved = false

    @iframe = @createIframeRequest()
    @iframe.onload = @updateIframeStatus.bind(@)

    @dfd.fail @removeIframe.bind(@)

  promise: ->
    @dfd

  resolveWithHtml: (html) ->
    @isResolved = true
    @dfd.resolve(html)

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

window.ijax = new Ijax()
