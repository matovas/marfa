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
    parts.join('').gsub(%r{-}, '')
  end

  # Convert string to url part
  # @example
  #   "some/path".to_url
  # @return [String] changed string
  def to_url
    val = self.strip_tags!
    val = val.gsub(':', '')
    val = val.gsub(' ', '-')
    val = val.gsub('/', '-')
    val.downcase
  end

  # Remove tags
  # @example
  #   "<a>some/path</a>".strip_tags!
  # @return [String] changed string
  def strip_tags!
    self.gsub(/<\/?[^>]*>/, '') # unless self.nil?
  end

  # Convert string price to preferred view
  # @example
  #   "1042.42".to_price!
  # @return [String]
  def to_price!
    # self.split('.') divides string into substring with '.' delimiter and returning array of this substrings
    # .first returns the first element of the array
    # .reverse returns a new string with the characters from str in reverse order
    # .gsub(pattern, replacement) returns a copy of str with the all occurrences of pattern substituted for the second argument
    self.split('.').first.reverse.gsub(/...(?=.)/, '\&;psniht&').reverse
  end
end
