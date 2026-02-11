module NavigationHelper
  # Returns the active navigation class
  def active_nav_class(nav_item)
    current_controller = controller_name
    
    nav_mapping = {
      'dashboard' => 'dashboard',
      'notifications' => 'notifications',
      'tasks' => 'tasks',
      'calendars' => 'calendars',
      'analytics' => 'analytics',
      'contacts' => 'contacts',
      'companies' => 'companies',
      'integrations' => 'integrations',
      'settings' => 'settings'
    }
    
    nav_mapping[nav_item] == current_controller ? 'bg-[#f2f2f2]' : ''
  end
  
  # Returns icon class for SVG currentColor
  def nav_icon_class(nav_item)
    current_controller = controller_name
    
    nav_mapping = {
      'dashboard' => 'dashboard',
      'notifications' => 'notifications',
      'tasks' => 'tasks',
      'calendars' => 'calendars',
      'analytics' => 'analytics',
      'contacts' => 'contacts',
      'companies' => 'companies',
      'integrations' => 'integrations',
      'settings' => 'settings'
    }
    
    nav_mapping[nav_item] == current_controller ? 'text-black' : 'text-[#727272]'
  end
  
  # Returns text color class
  def nav_text_color(nav_item)
    nav_icon_class(nav_item) # Same logic
  end
end