# Array class extending
class Array
  # @return [true, false]
  alias blank? empty?

  # Object isn't blank
  # @return [true, false]
  def present?
    !blank?
  end
end