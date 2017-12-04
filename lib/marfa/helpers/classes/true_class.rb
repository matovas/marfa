# TrueClass extending
class TrueClass
  # @return [false]
  def blank?
    false
  end

  # Object isn't blank
  # @return [true]
  def present?
    true
  end
end