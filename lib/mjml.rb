require "action_view"
require "action_view/template"
require "haml"
require "haml/template/plugin"
require "mjml/mjmltemplate"
require "mjml/railtie"
require "rubygems"

module Mjml

  def self.check_version(bin)
    begin
      Gem::Dependency.new('','~> 2.0').match?('',`#{bin} --version`)
    rescue
      false
    end
  end

  def self.discover_mjml_bin
    # Check for a global install of MJML binary
    mjml_bin = 'mjml'
    return mjml_bin if check_version(mjml_bin)
    
    # Check for a local install of MJML binary
    mjml_bin = File.join(`npm bin`.chomp, 'mjml')
    return mjml_bin if check_version(mjml_bin)
    
    raise RuntimeError, "Couldn't find the MJML binary.. have you run $ npm install mjml?"
  end

  def self.rails_template_engine
    @template_engine ||= if Rails.respond_to?(:application)
      Rails.application.config.generators.options[:rails][:template_engine]
    else
      :erb
    end
  end

  BIN = discover_mjml_bin

  class Handler
    def template_handler
      if Mjml.rails_template_engine == :haml
        ActionView::Template.registered_template_handler(:haml)
      else
        ActionView::Template.registered_template_handler(:erb)
      end
    end

    def call(template)
      compiled_source = template_handler.call(template)
      if template.formats.include?(:mjml)
        "Mjml::Mjmltemplate.to_html(begin;#{compiled_source};end).html_safe"
      else
        compiled_source
      end
    end
  end
end
