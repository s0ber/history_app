module MenuHelper
  def menu_items
    [
      ['— Dashboard', dashboard_path],
      ['— Search', search_path],
      ['— About', about_path]
    ]
  end
end
