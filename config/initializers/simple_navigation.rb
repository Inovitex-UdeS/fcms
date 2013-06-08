require 'simple-navigation'
require 'simple_navigation/rendering/helpers'
require 'simple_navigation/rendering/renderer/bootstrap'
SimpleNavigation.register_renderer :bootstrap => SimpleNavigation::Renderer::Bootstrap

include ActionView::Helpers::TextHelper

module SimpleNavigation
  module Helpers
    def active_navigation_item_name(options={})
      active_navigation_item(options,'') {
          |item|
        icon = item.html_options[:icon]
        name = Array.new
        name << content_tag(:i, '', :class => [icon].flatten.compact.join(' ')) unless icon.nil?
        name << item.name(:apply_generator => false)
        simple_format name.join(' ')
      }
    end
  end
end