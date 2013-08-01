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

    primary.item :nav_home, 'Accueil', root_path, :icon => 'icon-home'
    
    primary.item :divider_1, nil, nil, :class => 'divider-vertical'

    primary.item :nav_registrations, 'Inscriptions', new_registration_path, :icon => 'icon-edit', :highlights_on => /^\/registrations/ do |sub_nav|
      sub_nav.item :nav_registrations_view, 'Voir ses inscriptions', registrations_path
      sub_nav.item :nav_registrations_new,  'S\'inscrire au concours', new_registration_path
    end
    
    primary.item :divider_2, nil, nil, :class => 'divider-vertical'

    primary.item :nav_schedule, 'Horaire', '#', :icon => 'icon-calendar', :class => 'menu-disabled', :onclick => 'return false;' do |sub_nav|
      # sub_nav.item :key_3_1, 'Élément de menu 1', '#'
    end

    primary.item :divider_3, nil, nil, :class => 'divider-vertical'

    primary.item :nav_results, 'Résultats', '#', :icon => 'icon-bar-chart', :class => 'menu-disabled', :onclick => 'return false;' do |sub_nav|
      # sub_nav.item :key_4_1, 'Élément de menu 1', '#'
    end

    primary.item :divider_4, nil, nil, :class => 'divider-vertical', :if => Proc.new { current_user.is_admin? }

    primary.item :nav_admin, 'Administration' , '/admin', :icon => 'icon-cog', :highlights_on => /^\/admin/, :if => Proc.new { current_user.is_admin? } do |sub_nav|
      sub_nav.item :nav_admin_dashboard, 'Vue d\'ensemble', '/admin', :icon => 'iconic-chart'
      sub_nav.item :nav_admin_newspage,  'Page de nouvelles', '/admin/home'
      sub_nav.item :nav_admin_divider_1, '', nil, :class=> 'divider'
      sub_nav.item :nav_admin_edition,   'Choix de l\'édition', new_admin_edition_path
      sub_nav.item :nav_admin_category,  'Classes d\'inscription', new_admin_category_path
      sub_nav.item :nav_admin_data,      'Données d\'inscription', '#', :class => 'dropdown-submenu' do |sub_sub_nav|
        sub_sub_nav.dom_class = 'dropdown-menu'
        sub_sub_nav.item :nav_admin_data_instruments,  'Gérer les instruments', new_admin_instrument_path
        sub_sub_nav.item :nav_admin_data_composers,    'Gérer les compositeurs', new_admin_composer_path
        sub_sub_nav.item :nav_admin_data_pieces,       'Gérer les oeuvres', new_admin_piece_path
        sub_sub_nav.item :nav_admin_data_cities,       'Gérer les villes', new_admin_city_path
        sub_sub_nav.item :nav_admin_data_schoolboards, 'Gérer les commissions scolaires', new_admin_schoolboard_path
        sub_sub_nav.item :nav_admin_data_schooltypes,  'Gérer les types d\'écoles', new_admin_schooltype_path
        sub_sub_nav.item :nav_admin_data_schools,      'Gérer les institutions scolaires', new_admin_school_path
        # sub_nav.item :nav_admin_data_rooms,          'Gérer les locaux', new_admin_room_path
      end
      sub_nav.item :nav_admin_divider_2,     '', nil, :class=> 'divider'
      sub_nav.item :nav_admin_registrations, 'Voir les inscriptions', new_admin_registration_path
      sub_nav.item :nav_admin_planification, 'Planifier le concours', '/admin/planification'
      sub_nav.item :nav_admin_divider_3,     '', nil, :class=> 'divider'
      sub_nav.item :nav_admin_users,         'Gérer les utilisateurs', new_admin_user_path
      sub_nav.item :nav_admin_types,         'Types d\'utilisateurs', '#', :class => 'dropdown-submenu' do |sub_sub_nav|
        sub_sub_nav.dom_class = 'dropdown-menu'
        sub_sub_nav.item :nav_admin_types_participants, 'Participants', new_admin_participant_path
        sub_sub_nav.item :nav_admin_types_accompanists, 'Accompagnateurs', new_admin_accompanist_path
        sub_sub_nav.item :nav_admin_types_teachers,     'Professeurs', new_admin_teacher_path
        sub_sub_nav.item :nav_admin_types_judges,       'Juges', new_admin_juge_path
      end
      sub_nav.item :nav_admin_divider_4, '', nil, :class=> 'divider'
      sub_nav.item :nav_admin_invite,    'Inviter un utilisateur', '/users/invitation/new'
      sub_nav.item :nav_admin_message,   'Envoyer un message', new_admin_custom_mail_path

    end

    primary.item :divider_5, nil, nil, :class => 'divider-vertical'

    primary.item :nav_user, current_user.name, nil, :icon => 'icon-user', :highlights_on => /^\/users/ do |sub_nav|
      sub_nav.item :nav_user_edit,       'Profil', edit_user_path(current_user)
      sub_nav.item :nav_user_profile,    'Courriel et mot de passe', edit_user_registration_path
      sub_nav.item :nav_user_divider_1,  '', nil, :class=> 'divider'
      sub_nav.item :nav_user_disconnect, 'Déconnexion', destroy_user_session_path, :method => :delete
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
