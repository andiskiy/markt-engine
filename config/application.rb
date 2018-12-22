require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module MarkEngine
  class Application < Rails::Application
    config.load_defaults 5.2
    I18n.available_locales = [:en, :ru]
    I18n.default_locale = :ru

  end
end
