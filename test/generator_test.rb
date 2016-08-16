require "test_helper"
require "generators/mjml/mailer/mailer_generator"

class GeneratorTest < Rails::Generators::TestCase
  tests Mjml::Generators::MailerGenerator
  destination File.expand_path("../tmp", __FILE__)
  setup :prepare_destination

  include SharedGeneratorTest
end
