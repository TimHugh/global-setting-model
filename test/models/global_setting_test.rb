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

  def test_change_datatype
    setting = GlobalSetting.set('a-type-changing-value', true)
    assert_kind_of TrueClass, setting.value
    setting = GlobalSetting.set('a-type-changing-value', "now I'm a string!")
    assert_kind_of String, setting.value
  end

  def test_get_existing_setting
    setting = global_settings(:string)
    assert_equal setting.value,
                 GlobalSetting.get(setting.key)
  end

  def test_get_non_existing_setting
    assert_nil GlobalSetting.get('missing-string')
  end

  def test_unset_existing_setting
    GlobalSetting.unset('example-string')
    assert_nil GlobalSetting.find_by(key: 'example-string')
  end

  def test_unset_non_existing_setting
    assert_equal false,
                 GlobalSetting.unset('missing-string')
  end
end
