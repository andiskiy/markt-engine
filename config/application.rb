require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module MarktEngine
  class Application < Rails::Application
    config.load_defaults 5.2
    I18n.available_locales = %i[en ru]
    I18n.default_locale = ENV['LOCALE']
    config.time_zone = 'Europe/Moscow'

  end

  # constants
  DATE_FORMAT = '%m/%d/%Y'.freeze
  TIME_FORMAT = '%l:%M %P'.freeze
  DATETIME_FORMAT = "#{DATE_FORMAT} #{TIME_FORMAT}".freeze
  DATETIME_FORMAT_WITH_ZONE = "#{DATETIME_FORMAT} %Z".freeze
end
