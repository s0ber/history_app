class @IjaxRequest

  constructor: (path) ->
    @id = @getGuid()
    @path = URI(path).addQuery(format: 'al', i_req_id: @id, full_page: true).toString()
    @isResolved = false
    @isRejected = false

    @iframe = @createIframeRequest()
    @iframe.onload = @updateIframeStatus.bind(@)

  done: (@onDoneCallback) ->
    @

  fail: (@onFailCallback) ->
    @

  onAbort: (@onAbortCallback) ->
    @

  onCancel: (@onCancelCallback) ->
    @

  resolve: ->
    @isResolved = true
    @onDoneCallback(@response)

  reject: ->
    return if @isRejected
    @isRejected = true
    @onFailCallback?(args...)
    @removeIframe()

  registerResponse: ->
    @response = new IjaxResponse()

  updateIframeStatus: ->
    @removeIframe()
    @showError() unless @isResolved

  showError: ->
    console.log 'PIZDEC'

  createIframeRequest: ->
    src = @path or 'javascript:false'

    tmpElem = document.createElement('div')
    tmpElem.innerHTML = "<iframe name=\"#{@id}\" id=\"#{@id}\" src=\"#{src}\">"

    iframe = tmpElem.firstChild
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

