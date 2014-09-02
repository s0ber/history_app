class App.Views.Layout extends App.View

  events:
    'click a.js-app-menu_item': 'processLinkClick'

  initialize: ->
    @historyWidget = Histo.addWidget(id: 'menu_navigation')
    @setInitialState()
    @historyWidget.onPopState @processPoppedState.bind(@)

  setInitialState: ->
    activeMenuItemId = @$menu()
      .find('.is-active')
      .data('menu-item-id')

    @historyWidget.replaceInitialState('active_menu_item_id': activeMenuItemId)

  processPoppedState: (state, path, dfd) ->
    activeMenuItemId = state['active_menu_item_id']
    $link = @$menu().find("[data-menu-item-id='#{activeMenuItemId}']")

    dfd.fail =>
      @abortCurrentRequest()

    @createNewRequest(
      ijax.get(path).done (res) =>
        res
          .onLayoutReceive((html) =>
            @setLinkAsActive($link)
            @utils.scrollTop()
            @$pageWrapper().html(html)
          )
          .onResolve(=>
            @$pageWrapper().trigger('refresh')
            dfd.resolve()
          )
    )

  processLinkClick: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    return if $link.hasClass('is-active')

    activeMenuItemId = $link.data('menu-item-id')
    path = $link.attr('href')

    @createNewRequest(
      ijax.get(path).done (res) =>
        res
          .onLayoutReceive((html) =>
            @setLinkAsActive($link)
            @utils.scrollTop()
            @historyWidget.pushState(path, 'active_menu_item_id': activeMenuItemId)
            @$pageWrapper().html(html)
          )
          .onResolve(=>
            @$pageWrapper().trigger('refresh')
          )
    )

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
