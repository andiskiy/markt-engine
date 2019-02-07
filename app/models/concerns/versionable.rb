module Versionable
  extend ActiveSupport::Concern

  private

  def can_be_extracted?(version, date, key)
    version.created_at > date && version.object_changes[key]
  end

  module ClassMethods
    def versionable(*columns)
      columns.map(&:to_s).each do |field|
        define_method "old_#{field}" do |date|
          versions.each do |version|
            return version.object_changes[field][0] if can_be_extracted?(version, date, field)
          end
          send(field)
        end
      end
    end
  end
end
