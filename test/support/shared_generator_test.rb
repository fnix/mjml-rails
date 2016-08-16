module SharedGeneratorTest
  extend ActiveSupport::Concern

  included do
    test "assert all views are properly created with given name" do
      run_generator %w(notifier foo bar baz)

      assert_file "app/views/notifier/foo.mjml"
      assert_file "app/views/notifier/bar.mjml"
      assert_file "app/views/notifier/baz.mjml"
    end
  end
end