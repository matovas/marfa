# Nil class extending
class NilClass
  # @return [true]
  def blank?
    true
  end

  # Object isn't blank
  # @return [false]
  def present?
    false
  end
end