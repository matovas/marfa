# Regexp class extending
# Helpers from Rails
class Regexp
  def multiline?
    options & MULTILINE == MULTILINE
  end

  def match?(string, pos=0)
    !!match(string, pos)
  end unless //.respond_to?(:match?)
end