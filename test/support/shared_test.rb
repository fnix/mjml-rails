class Notifier < ActionMailer::Base
  layout false

  def contact(recipient, format_type)
    @recipient = recipient
    mail(:to => @recipient, :from => "john.doe@example.com") do |format|
      format.send(format_type)
    end
  end

  def link(format_type)
    mail(:to => 'foo@bar.com', :from => "john.doe@example.com") do |format|
      format.send(format_type)
    end
  end

  def user(format_type)
    mail(:to => 'foo@bar.com', :from => "john.doe@example.com") do |format|
      format.send(format_type)
    end
  end

  def no_partial(format_type)
    mail(:to => 'foo@bar.com', :from => "john.doe@example.com") do |format|
      format.send(format_type)
    end
  end

  def multiple_format_contact(recipient)
    @recipient = recipient
    mail(:to => @recipient, :from => "john.doe@example.com", :template => "contact") do |format|
      format.text  { render 'contact' }
      format.html  { render 'contact' }
    end
  end
end

module SharedTest
  extend ActiveSupport::Concern
  
  included do |base|
    setup do
      if base::TEMPLATE_ENGINE == :haml
        Notifier.view_paths = File.expand_path("../../views/haml", __FILE__)
      else
        Notifier.view_paths = File.expand_path("../../views", __FILE__)
      end
      @original_renderer = Mjml.renderer
      @original_processing_options = Mjml.processing_options
    end

    teardown do
      Mjml.renderer = @original_renderer
      Mjml.processing_options = @original_processing_options
    end

    test "html should be sent as html" do
      Mjml.stub :rails_template_engine, base::TEMPLATE_ENGINE do
        email = Notifier.contact("you@example.com", :mjml)
        assert_equal "text/html", email.mime_type
        assert_no_match(/<mj-body>/, email.body.encoded.strip)
        assert_match(/<body/, email.body.encoded.strip)
        assert_match(/Hello from.*<a href=.http:\/\/www.sighmon.com.>sighmon.com<\/a>.*<\/p>/m, email.body.encoded.strip)
      end
    end

    test 'with partial' do
      Mjml.stub :rails_template_engine, base::TEMPLATE_ENGINE do
        email = Notifier.user(:mjml)
        assert_equal "text/html", email.mime_type
        assert_match(/Hello Partial/, email.body.encoded.strip)
        assert_no_match(/mj-text/, email.body.encoded.strip)
      end
    end

    test 'without a partial' do
      Mjml.stub :rails_template_engine, base::TEMPLATE_ENGINE do
        email = Notifier.no_partial(:mjml)
        assert_equal "text/html", email.mime_type
        assert_match(/Hello World/, email.body.encoded.strip)
        assert_no_match(/mj-text/, email.body.encoded.strip)
      end
    end
  end
end