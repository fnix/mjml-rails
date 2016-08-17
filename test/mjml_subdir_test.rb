require "test_helper"

# class TestRenderer < ActionView::PartialRenderer
#   attr_accessor :show_text
#   def initialize(render_options = {})
#     @show_text = render_options.delete(:show_text)
#     super(render_options)
#   end

#   def normal_text(text)
#     show_text ? "TEST #{text}" : "TEST"
#   end
# end

class MjmlSubdirTest < ActiveSupport::TestCase
  TEMPLATE_ENGINE = :erb
  include SharedSubdirTest
end
