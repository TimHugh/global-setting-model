# A model for storing key-value pairs, intended for global server configuration
# settings, with the ability to gracefully handle multiple data types.
class GlobalSetting < ActiveRecord::Base
  enum datatype: [:string, :integer, :float, :boolean]

  validates_presence_of :key, :datatype
  validates :key, uniqueness: true

  after_commit :invalidate_cache

  # Accessor for the setting's stored data. Uses #datatype to determine the
  # correct model attribute.
  def value
    send(datatype.to_sym)
  end

  # Stores a value in the appropriate model attribute based on the class of the
  # value object (and updates the datatype), but does not commit the change to
  # the database.
  # Returns the value as it will be committed--i.e. stringified, intified, etc.
  # * +value+ - The value to be stored.
  def value=(value)
    self.datatype = datatype_from_object(value)
    send("#{datatype}=".to_sym, value)
    self.value
  end

  protected

  # Returns the attribute name that is most appropriate for a given object.
  # Returns "string" for objects without a clearly associated type.
  # * +object+ - The object to determine a datatype from
  def datatype_from_object(object)
    GLOBAL_SETTING_DATATYPES[object.class.to_s] || 'string'
  end

  # Invalidates any cached data for the current key, so the next query will get
  # current data.
  def invalidate_cache
    Rails.cache.delete "globalsetting/#{key}"
  end

  class << self
    # Updates or creates a new record for the given key, with the given value.
    # The datatype will be determined automatically.
    # Returns the GlobalSetting object that was created.
    # Raises ActiveRecord::RecordInvalid if key is invalid
    # * +key+ - A string containing the name associated with the setting.
    # * +value+ - The value to be stored.
    def set(key, value)
      setting = find_or_create_by(key: key)
      setting.value = value
      setting.save!
      setting
    end

    # Returns the stored value in the record associated with the key. Will
    # attempt to access cache before the database to minimize database load.
    # * +key+ - A string containing the name associated with the setting.
    def get(key)
      Rails.cache.fetch "globalsetting/#{key}" do
        setting = find_by(key: key)
        setting.nil? ? nil : setting.value
      end
    end

    # Deletes a setting from the database, or returns false if the setting
    # doesn't exist.
    # * +key+ - A string containing the name associated with the setting.
    def unset(key)
      setting = find_by(key: key)
      setting.nil? ? false : setting.destroy
    end
  end
end
