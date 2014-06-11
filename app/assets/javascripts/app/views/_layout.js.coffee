class App.Views.Layout extends App.View

  events:
    'click a.js-app-menu_item': 'processLinkClick'

  initialize: ->
    @historyWidget = new App.Utils.HistoryWidget(id: 'menu_navigation')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    activeMenuItemId = @$menu()
      .find('.is-active')
      .data('menu-item-id')

    @historyWidget.replaceInitialState('active_menu_item_id': activeMenuItemId)

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state) =>
      activeMenuItemId = state['active_menu_item_id']
      $link = @$menu().find("[data-menu-item-id='#{activeMenuItemId}']")

      $.getJSON(location.href, 'full_page': true).done (json) =>
        @setLinkAsActive($link)
        @utils.scrollTop()
        @html(@$pageWrapper(), json.html)

  processLinkClick: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    return if $link.hasClass('is-active')

    activeMenuItemId = $link.data('menu-item-id')
    path = $link.attr('href')

    $.getJSON(path, 'full_page': true).done (json) =>
      @setLinkAsActive($link)
      @utils.scrollTop()

      @historyWidget.pushNewState(path, 'active_menu_item_id': activeMenuItemId)
      @html(@$pageWrapper(), json.html)

  unload: ->
    @historyWidget.removeState()

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
