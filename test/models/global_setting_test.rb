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

  def test_set_new_string
    setting = GlobalSetting.set('email', 'tim@example.com')
    assert_equal 'tim@example.com',
                 setting.string
  end

  def test_set_new_integer
    setting = GlobalSetting.set('number', 42)
    assert_equal 42,
                 setting.integer
  end

  def test_set_new_float
    setting = GlobalSetting.set('other-number', 3.14)
    assert_equal 3.14,
                 setting.float
  end

  def test_new_boolean
    setting = GlobalSetting.set('a-boolean-flag', true)
    assert_equal true,
                 setting.boolean
  end
end
