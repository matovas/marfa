# Hash class extending
class Hash
  alias blank? empty?

  # Object isn't blank
  # @return [true, false]
  def present?
    !blank?
  end
end