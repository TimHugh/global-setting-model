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
    {
      'String'      => 'string',
      'Fixnum'      => 'integer',
      'Float'       => 'float',
      'TrueClass'   => 'boolean',
      'FalseClass'  => 'boolean'
    }[object.class.to_s] || 'string'
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
