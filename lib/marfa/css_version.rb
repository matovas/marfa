# CSS version
module Marfa
  # return css version
  def self.css_version
    @css_version ||= Time.now.to_i.freeze
  end
end