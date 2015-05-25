class GlobalSetting < ActiveRecord::Base
  enum datatype: [:string, :integer, :float, :boolean]

  validates_presence_of :key, :datatype
  validates :key, uniqueness: true

  def value
    send(datatype.to_sym)
  end

  def value=(value)
    self.datatype = datatype_from_object(value)
    send("#{datatype}=".to_sym, value)
    self.value
  end

  protected

  def datatype_from_object(object)
    GLOBAL_SETTING_DATATYPES[object.class.to_s] || 'string'
  end

  class << self
    def set(key, value)
      setting = find_or_create_by(key: key)
      setting.value = value
      setting.save!
      setting
    end
  end
end
