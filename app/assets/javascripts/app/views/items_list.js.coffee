class App.Views.ItemsList extends App.View

  events:
    'click .list-item': 'selectItem'

  initialize: ->
    @historyWidget = Histo.addWidget(id: 'items_list')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    $selectedItem = @$('.list-item.is-active')
    @historyWidget.replaceInitialState('selected_item_id': $selectedItem.data('item-id'))

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state) =>
      itemId = state['selected_item_id']

      if itemId
        $item = @$itemById(itemId)
        path = $item.data('item-url')
      else
        path = @$el.data('no-item-url')

      $.getJSON(path).done (json) =>
        if itemId
          @setItemAsSelected($item)
        else
          @$('.list-item').removeClass('is-active')

        @html(@$selectedItemWrapper(), json.html)

  selectItem: (e) ->
    $item = $(e.currentTarget)
    path = new URI(location.href)
    path.setSearch('item_id': $item.data('item-id'))

    $.getJSON($item.data('item-url')).done (json) =>
      @historyWidget.pushState(path.toString(), 'selected_item_id': $item.data('item-id'))
      @setItemAsSelected($item)
      @html(@$selectedItemWrapper(), json.html)

  setItemAsSelected: ($item) ->
    $item
      .siblings()
        .removeClass('is-active')
        .end()
      .addClass('is-active')

  # accessors

  $selectedItemWrapper: ->
    @_$selectedItemWrapper ?= @$('.js-items_list-item_wrapper')

  $itemById: (id) ->
    @$('.list-item').filter("[data-item-id=#{id}]")

