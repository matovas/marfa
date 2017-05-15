# Additional Numeric functionality
class Numeric
  # Convert numeric price to string price with preferred view
  # @example
  #   1042.42.to_price!
  # @return [String]
  def to_price!
    self.to_s.to_price!
  end
end
