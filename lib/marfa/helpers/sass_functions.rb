# encoding: utf-8
require 'sass'
require 'sass/plugin'

# Sass module extension
module Sass::Script::Functions
  # SASS-method - device type
  def device
    Sass::Script::Value::String.new(Sass::Plugin.options[:custom][:device])
  end

  # SASS-method - section
  def section
    Sass::Script::Value::String.new(Sass::Plugin.options[:custom][:section])
  end

  # SASS-method - content path
  def content_path
    Sass::Script::Value::String.new(Sass::Plugin.options[:custom][:contentPath])
  end

  declare :get_device, []
  declare :section, []
  declare :content_path, []
end
