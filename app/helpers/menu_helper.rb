module MenuHelper
  def menu_items
    [
      ['— Dashboard', dashboard_path, menu_item_id: 'dashboard'],
      ['— Search', search_path, menu_item_id: 'search'],
      ['— Heavy Search', heavy_search_path, menu_item_id: 'heavy_search'],
      ['— About', about_path, menu_item_id: 'about']
    ]
  end
end
