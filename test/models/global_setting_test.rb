require 'test_helper'

class GlobalSettingTest < ActiveSupport::TestCase
  def setting
    @setting ||= GlobalSetting.new(key: 'new-string', datatype: 'string')
  end

  def test_valid
    assert setting.valid?
  end

  def test_key_required
    setting.key = nil
    refute setting.valid?
  end

  def test_datatype_required
    setting.datatype = nil
    refute setting.valid?
  end
end
