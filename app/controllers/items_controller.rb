class ItemsController < ApplicationController
  def show
    render_partial 'search/selected_item', item_id: params[:id]
  end
end
