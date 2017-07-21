# Object class extending
class Object
  # Copied from rails
  # An object is present if it's not blank.
  #
  # @return [true, false]
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end