module Countryable
  extend ActiveSupport::Concern

  def full_address
    full_address_exists? ? [address, city, country, zip_code].join(', ') : I18n.t('admin.user.messages.no_address')
  end

  def country
    return unless country_code

    country_name = ISO3166::Country[country_code]
    country_name.translations[I18n.locale.to_s] || country_name.name
  end

  private

  def full_address_exists?
    address.present? && city.present? && country_code.present? && zip_code.present?
  end
end
