# Custom SimpleNavigation renderer for Bootstrap
#  ** Based on simple-navigation-bootstrap by Peter Fern
#  ** https://rubygems.org/gems/simple-navigation-bootstrap
#  ** https://github.com/pdf/simple-navigation-bootstrap

module SimpleNavigation
  module Renderer
    class Bootstrap < SimpleNavigation::Renderer::Base
      def render(item_container)
        config_selected_class = SimpleNavigation.config.selected_class
        SimpleNavigation.config.selected_class = 'active'
        list_content = item_container.items.inject([]) do |list, item|
          li_options = item.html_options.reject {|k, v| k == :link}
          li_content = tag_for(item, li_options.delete(:icon), li_options.delete(:dropdown))
          if include_sub_navigation?(item) && item.url.nil?
            item.sub_navigation.dom_class = [item.sub_navigation.dom_class, 'dropdown-menu'].flatten.compact.join(' ')
            li_content << render_sub_navigation_for(item)
            li_options[:class] = [li_options[:class], 'dropdown'].flatten.compact.join(' ')
          end
          list << content_tag(:li, li_content, li_options)
        end.join
        SimpleNavigation.config.selected_class = config_selected_class
        if skip_if_empty? && item_container.empty?
          ''
        else
          content_tag(:ul, list_content, {:id => item_container.dom_id, :class => item_container.dom_class})
        end
      end

      protected

      def tag_for(item, icon = nil, dropdown = false)
        unless item.url or include_sub_navigation?(item)
          return item.name
        end
        url = item.url
        link = Array.new
        link << content_tag(:i, '', :class => [icon].flatten.compact.join(' ')) unless icon.nil?
        link << item.name
        if include_sub_navigation?(item)
          item_options = item.html_options
          item_options[:link] = Hash.new if item_options[:link].nil?
          item_options[:link][:class] = Array.new if item_options[:link][:class].nil?
          item_options[:link][:class] << 'dropdown-toggle'
          item_options[:link][:'data-toggle'] = 'dropdown' if dropdown
          item.html_options = item_options
          link << content_tag(:b, '', :class => 'caret') if dropdown
        end
        #content_tag(:a, link.join(' '), options_for(item).merge(:href => url))
        link_to(link.join(" "), url, options_for(item))
      end
    end
  end
end