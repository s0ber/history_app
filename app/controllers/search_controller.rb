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

    render_page
  end

private

  def statuses
    [:none, :active, :deleted]
  end

  def selected_status
    params[:status] || 'none'
  end

  def selected_item_id
    params[:item_id]
  end

  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  helper_method :statuses, :selected_status, :current_page, :selected_item_id
end
