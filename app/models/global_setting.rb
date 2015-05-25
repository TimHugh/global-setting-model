class GlobalSetting < ActiveRecord::Base
  validates_presence_of :key, :datatype
  validates :key, uniqueness: true
end
