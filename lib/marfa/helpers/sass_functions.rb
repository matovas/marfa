# encoding: utf-8

require 'sass'
require 'sass/plugin'

# Модуль SASS-методов
module Sass::Script::Functions
  # SASS-метод - получение типа устройства
  def device
    Sass::Script::Value::String.new(Sass::Plugin.options[:custom][:device])
  end

  # SASS-метод - получение типа секции?
  def section
    Sass::Script::Value::String.new(Sass::Plugin.options[:custom][:section])
  end

  # SASS-метод - получение пути для контента
  def content_path
    Sass::Script::Value::String.new(Sass::Plugin.options[:custom][:contentPath])
  end

  declare :get_device, []
  declare :section, []
  declare :content_path, []
end
