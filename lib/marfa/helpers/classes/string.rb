# Дополнение класса String
class String
  # Заменяет все символы в строке '/' на '_'
  # @example
  #   "some/path".to_underscore
  # @return [String] измененная строка
  def to_underscore
    downcase.gsub(%r{/}, '_')
  end

  # Преобразует строку вида 'category/list' к CamelCase-строке - имени класса
  # @example
  #   "some/path".to_class_name
  # @return [String] измененная строка
  def to_class_name
    parts = downcase.split('/')
    parts.each(&:capitalize!)
    parts.join('')
  end
end
