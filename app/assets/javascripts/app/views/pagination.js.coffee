class App.Views.Pagination extends App.View

  events:
    'click a.pagination-page': 'loadNewPage'

  initialize: ->
    @historyWidget = new App.Utils.HistoryWidget(id: 'search_pagination')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    path = location.href
    currentPageNumber = @getPageNumberFromPath(path)

    @historyWidget.replaceInitialState('page_number': currentPageNumber)

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state) =>
      $.getJSON(location.href).done (json) =>
        @utils.scrollTop()
        @html(@$el, json.html)

  loadNewPage: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    path = $link.attr('href')
    newPageNumber = @getPageNumberFromPath(path)

    $.getJSON(path).done (json) =>
      @utils.scrollTop()
      @historyWidget.pushNewState(path, 'page_number': newPageNumber)
      @html(@$el, json.html)

  unload: ->
    @historyWidget.removeState()

  # private

  getPageNumberFromPath: (path) ->
    if page = URI(path).search(true).page
      parseInt(page, 10)
    else
      1

