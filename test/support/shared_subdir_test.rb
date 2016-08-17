class SubdirNotifier < ActionMailer::Base
  layout false

  def simple_block(format_type)
    mail(:to => 'foo@bar.com', :from => "john.doe@example.com") do |format|
      format.send(format_type)
    end
  end

  def simple_block_and_path(format_type)
    mail(:template_path => 'template_subdir',:to => 'foo@bar.com', :from => "john.doe@example.com") do |format|
      format.send(format_type)
    end
  end

  def simple_with_path(format_type)
    mail(:template_path => 'template_subdir',:to => 'foo@bar.com', :from => "john.doe@example.com")
  end
end

module SharedSubdirTest
  extend ActiveSupport::Concern

  included do |base|
    setup do
      if base::TEMPLATE_ENGINE == :haml
        SubdirNotifier.view_paths = File.expand_path("../../views/haml", __FILE__)
      else
        SubdirNotifier.view_paths = File.expand_path("../../views", __FILE__)
      end
      @original_renderer = Mjml.renderer
      @original_processing_options = Mjml.processing_options
    end

    teardown do
      Mjml.renderer = @original_renderer
      Mjml.processing_options = @original_processing_options
    end

    test 'in a subdir with a block fails' do
      assert_raises(ActionView::MissingTemplate) do
        Mjml.stub :rails_template_engine, base::TEMPLATE_ENGINE do
          email = SubdirNotifier.simple_block(:mjml)
          assert_equal "text/html", email.mime_type
          assert_match(/alternate sub-directory/, email.body.encoded.strip)
          assert_no_match(/mj-text/, email.body.encoded.strip)
        end
      end
    end

    test 'in a subdir with a block and template_path option fails' do
      assert_raises(ActionView::MissingTemplate) do
        Mjml.stub :rails_template_engine, base::TEMPLATE_ENGINE do
          email = SubdirNotifier.simple_block_and_path(:mjml)
          assert_equal "text/html", email.mime_type
          assert_match(/alternate sub-directory/, email.body.encoded.strip)
          assert_no_match(/mj-text/, email.body.encoded.strip)
        end
      end
    end

    test 'in a subdir with path' do
      Mjml.stub :rails_template_engine, base::TEMPLATE_ENGINE do
        email = SubdirNotifier.simple_with_path(:mjml)
        assert_equal "text/html", email.mime_type
        assert_match(/alternate sub-directory/, email.body.encoded.strip)
        assert_no_match(/mj-text/, email.body.encoded.strip)
      end
    end
  end
end