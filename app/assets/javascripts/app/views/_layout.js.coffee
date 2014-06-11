class App.Views.Layout extends App.View

  # events:
  #   'click a.js-app-menu_item': 'processLinkClick'
  #
  # initialize: ->
  #   @historyApi = new App.Utils.HistoryApiSupport()
  #   @setInitialState()
  #   @setPoppedStateProcessing()

  setInitialState: ->
    activeMenuItemId = @$menu()
      .find('.is-active')
      .data('menu-item-id')

    @historyApi.replaceInitialState
      data: {'active_menu_item_id': activeMenuItemId}

  setPoppedStateProcessing: ->
    @historyApi.onPopState (e) =>
      activeMenuItemId = e.state['active_menu_item_id']
      $link = @$menu().find("[data-menu-item-id='#{activeMenuItemId}']")

      $.getJSON(location.href, 'full_page': true).done (json) =>
        @setLinkAsActive($link)
        @html(@$pageWrapper(), json.html)

        @utils.scrollTop()

  processLinkClick: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    return if $link.hasClass('is-active')

    activeMenuItemId = $link.data('menu-item-id')
    path = $link.attr('href')

    $.getJSON(path, 'full_page': true).done (json) =>
      @setLinkAsActive($link)
      @html(@$pageWrapper(), json.html)

      @utils.scrollTop()

      @historyApi.pushNewState
        path: path
        data: {'active_menu_item_id': activeMenuItemId}

  # private

  setLinkAsActive: ($link) ->
    $link
      .siblings()
        .removeClass('is-active')
        .end()
      .addClass('is-active')

  # getters

  $menu: ->
    @_$menu ?= @$('.js-app-menu')

  $pageWrapper: ->
    @_$pageWrapper ?= @$('.js-app-page_wrapper')
