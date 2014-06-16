class App.Views.SearchForm extends App.View

  events:
    'click .js-search_form-radio': 'changeActiveRadio'

  initialize: ->
    @model = {}

    @setInitialValue()
    @initHistoryApi()

  setInitialValue: ->
    @setValue @fieldValue()

  changeActiveRadio: (e) ->
    $radio = $(e.currentTarget)
    return if $radio.hasClass 'is-active'
    value = $radio.data 'value'

    @setValue value

    path = @getQueryPath()
    $.getJSON(path).done (json) =>
      @historyWidget.pushNewState(path, 'query_model': Object.clone(@model))
      @html(@$listWrapper(), json.html)

  setActiveRadio: ->
    @$radios().removeClass('is-active')
    @$radios()
      .filter("[data-value=#{@value()}]")
      .addClass('is-active')

  # accessors

  setValue: (value) ->
    @model[@fieldName()] = value
    @setActiveRadio()

  value: ->
    @model[@fieldName()]

  # getters

  $radios: ->
    @_$radios ?= @$('.js-search_form-radio')

  $listWrapper: ->
    $('[data-view="pagination"]')

  fieldName: ->
    @_fieldName ?= @$el.data('field-name')

  fieldValue: ->
    @$el.data('value')

  getQueryString: ->
    $.param(@model)

  getQueryPath: ->
    "#{location.pathname}?#{@getQueryString()}"

  # history API processing

  initHistoryApi: ->
    @historyWidget = new App.Utils.HistoryWidget(id: 'search_form')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    @historyWidget.replaceInitialState 'query_model': Object.clone(@model)

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state) =>
      model = state['query_model']
      newValue = model[@fieldName()]
      @setValue newValue

      path = @getQueryPath()

      # if 'modifier' widgets states were added, we should add those modifiers to request path
      # path = HistoryApi.filterPoppedPath(location.href)
      if page = URI(location.href).search(true).page
        path += "&page=#{page}"

      if itemId = URI(location.href).search(true)['item_id']
        path += "&item_id=#{itemId}"

      $.getJSON(path).done (json) =>
        @html(@$listWrapper(), json.html)
