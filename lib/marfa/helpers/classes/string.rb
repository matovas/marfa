# Additional String functionality
class String
  # Replaces all '/' to '_'
  # @example
  #   "some/path".to_underscore
  # @return [String] changed string
  def to_underscore
    downcase.gsub(%r{/}, '_')
  end

  # Convert string like 'category/list' to CamelCase
  # @example
  #   "some/path".to_class_name
  # @return [String] changed string
  def to_class_name
    parts = downcase.split('/')
    parts.each(&:capitalize!)
    parts.join('')
  end
end
