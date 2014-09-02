class SearchController < ApplicationController

   # super-puper search engine
  def index
    if params[:status] == 'active'
      if current_page == 1
        @items = [
          {title: 'Item 1', id: 1},
          {title: 'Item 2', id: 2},
          {title: 'Item 3', id: 3},
          {title: 'Item 4', id: 4},
          {title: 'Item 5', id: 5}
        ]
      else
        @items = [
          {title: 'Item 6', id: 6},
          {title: 'Item 7', id: 7},
          {title: 'Item 8', id: 8},
          {title: 'Item 9', id: 9}
        ]
      end
    else
      @items = []
    end

    if show_full_page?
      respond_with(nil)
    else
      render_partial 'search_results'
    end
  end

  def heavy
    @items = [
      {title: 'Item 1', id: 1},
      {title: 'Item 2', id: 2},
      {title: 'Item 3', id: 3},
      {title: 'Item 4', id: 4},
      {title: 'Item 5', id: 5},
      {title: 'Item 6', id: 6},
      {title: 'Item 7', id: 7},
      {title: 'Item 8', id: 8},
      {title: 'Item 10', id: 10}#,
      # {title: 'Item 11', id: 11},
      # {title: 'Item 12', id: 12},
      # {title: 'Item 13', id: 13},
      # {title: 'Item 14', id: 14},
      # {title: 'Item 15', id: 15},
      # {title: 'Item 16', id: 16},
      # {title: 'Item 17', id: 17},
      # {title: 'Item 18', id: 18},
      # {title: 'Item 19', id: 19},
      # {title: 'Item 20', id: 20}
    ]

    if show_full_page?
      respond_with(nil)
    else
      render_partial 'search_results'
    end
  end


private

  def statuses
    [:none, :active, :deleted]
  end

  def selected_status
    params[:status] || 'none'
  end

  def selected_item_id
    params[:item_id] ? params[:item_id].to_i : nil
  end

  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  def show_full_page?
    request.format == 'json' && params[:full_page] == 'true'
  end

  helper_method :statuses, :selected_status, :current_page, :selected_item_id
end
