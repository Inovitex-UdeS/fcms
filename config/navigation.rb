# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple_navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>. 
    #
    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.

    # Custom config options for bootstrap renderer:
    # url - If set to 'nil', the dropdown will show up on hover, with all submenu options.
    #       Otherwise, the dropdown won't show up, and the item will work as a link.
    #       Ideally, every primary item link would also be a sub_nav item link, so when
    #       the user clicks on an item, it actually opens a sub_nav link.
    # icon - Adds a bootstrap icon with the specified class before the title

    primary.item :key_1, 'Accueil', root_path, :icon => 'icon-home'
    
    primary.item :divider_1, nil, nil, :class => 'divider-vertical'

    primary.item :key_2, 'Inscriptions' , new_registration_path, :icon => 'icon-edit' do |sub_nav|
      sub_nav.item :key_2_1, 'Voir ses inscriptions', registrations_path
      sub_nav.item :key_2_2, 'S\'inscrire au concours', new_registration_path
      sub_nav.item :key_2_4, '', nil, :class=> 'divider'
      sub_nav.item :key_2_5, 'Payer son inscription', '#'
    end
    
    primary.item :divider_2, nil, nil, :class => 'divider-vertical'

    primary.item :key_3, 'Horaire', '#', :icon => 'icon-calendar' do |sub_nav|
      sub_nav.item :key_3_1, 'Élément de menu 1', '#'
    end

    primary.item :divider_3, nil, nil, :class => 'divider-vertical'

    primary.item :key_4, 'Résultats', '#', :icon => 'icon-bar-chart' do |sub_nav|
      sub_nav.item :key_4_1, 'Élément de menu 1', '#'
    end

    primary.item :divider_4, nil, nil, :class => 'divider-vertical'

    # TODO: Replace 'user_signed_in?' with actual admin permissions lookup   --> Genre  current_user.has_role?(:administrateur)
    primary.item :key_5, 'Administration' , '/admin', :icon => 'icon-cog' do |sub_nav|
      sub_nav.item :key_5_1, 'Vue d\'ensemble', '/admin', :icon => 'iconic-chart'
      sub_nav.item :key_5_2, 'Gérer les inscriptions', '#{/registrations}'
      sub_nav.item :key_5_3, '', nil, :class=> 'divider'
      sub_nav.item :key_5_4, 'Gérer les commissions scolaires',new_admin_schoolboard_path
      sub_nav.item :key_5_5, 'Gérer les compositeurs', new_admin_composer_path
      sub_nav.item :key_5_6, 'Gérer les éditions', new_admin_edition_path
      sub_nav.item :key_5_7, 'Gérer les instruments', new_admin_instrument_path
      sub_nav.item :key_5_8, 'Gérer les locaux', new_admin_room_path
      sub_nav.item :key_5_9, 'Gérer les types d\'écoles', new_admin_schooltype_path
      sub_nav.item :key_5_10, 'Gérer les villes', new_admin_city_path
      sub_nav.item :key_5_11,'', nil, :class=> 'divider'
      sub_nav.item :key_5_12, 'Gérer les accompagnateurs', new_admin_accompanyist_path
      sub_nav.item :key_5_13, 'Gérer les juges', new_admin_juge_path
      sub_nav.item :key_5_14, 'Gérer les professeurs', new_admin_teacher_path
      sub_nav.item :key_5_15,'', nil, :class=> 'divider'
      sub_nav.item :key_5_16,'Inviter un utilisateur', '/users/invitation/new'
      sub_nav.item :key_5_17,'Gérer les utilisateurs', '/users'
      sub_nav.item :key_5_18, '', nil, :class=> 'divider'
      sub_nav.item :key_5_19, 'Classes d\'inscritpion', new_admin_category_path
    end

    primary.item :divider_6, nil, nil, :class => 'divider-vertical'

    primary.item :key_7, 'Compte', nil, :icon => 'icon-user' do |sub_nav|
      sub_nav.item :key_7_1, 'Profil', edit_user_path(current_user)
      sub_nav.item :key_7_2, 'Courriel et mot de passe', edit_user_registration_path
      sub_nav.item :key_7_3, '', nil, :class=> 'divider'
      sub_nav.item :key_7_4, 'Déconnexion', destroy_user_session_path, :method => :delete
    end

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    primary.dom_class = 'nav'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

  navigation.selected_class = 'active'

end
