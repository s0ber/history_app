class App.Views.Pagination extends App.View

  events:
    'click a.pagination-page': 'loadNewPage'

  initialize: ->
    @historyApi = new App.Utils.HistoryApiSupport()
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    path = location.href
    currentPageNumber = @getPageNumberFromPath(path)

    @historyApi.replaceInitialState
      data: {'page_number': currentPageNumber}

  setPoppedStateProcessing: ->
    @historyApi.onPopState (e) =>
      $.getJSON(location.href).done (json) =>
        @html(@$el, json.html)
        @utils.scrollTop()

  loadNewPage: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    path = $link.attr('href')
    newPageNumber = @getPageNumberFromPath(path)

    $.getJSON(path).done (json) =>
      @html(@$el, json.html)
      @utils.scrollTop()

      @historyApi.pushNewState
        path: path
        data: {'page_number': newPageNumber}

  # private

  getPageNumberFromPath: (path) ->
    URI(path).search(true).page || 1

