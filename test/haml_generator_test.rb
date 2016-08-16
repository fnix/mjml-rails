require "test_helper"
require "generators/mjml/mailer/mailer_haml_generator"

class HamlGeneratorTest < Rails::Generators::TestCase
  tests Mjml::Generators::MailerHamlGenerator
  destination File.expand_path("../tmp", __FILE__)
  setup :prepare_destination

  include SharedGeneratorTest
end
