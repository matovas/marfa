# Additional Numeric functionality
class Numeric
  # Convert numeric price to string price with preferred view
  # @example
  #   1042.42.to_price!
  # @return [String]
  def to_price!
    self.to_s.to_price!
  end

  # Check if digit is blank
  # 0.blank? => true
  # 1.blank? => false
  # @return [true, false]
  def blank?
    return true if zero?
    false
  end

  # Object isn't blank
  # @return [true, false]
  def present?
    !blank?
  end
end
