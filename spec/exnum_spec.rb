require 'spec_helper'

#------------------------------------------------------------------------------
# test model definition
class User < ActiveRecord::Base
end

#------------------------------------------------------------------------------
# test code

def test_enum(klass)
  it "should use as well as enum" do
    expect(klass.roles).to eq({"guest" => 0, "general" => 1, "admin" => 2})
  end
end

def test_i18n(klass)
  it "should provide i18n hash" do
    expect(klass.roles_i18n).to eq({"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"})
  end
  it "should provide nil as i18n when its attribute is nil" do
    user = klass.new
    expect(user.role_i18n).to eq(nil)
  end
  it "should provide i18n string by its instance" do
    user = klass.new(role: :guest)
    expect(user.role_i18n).to eq("ゲスト")
  end
end

def test_i18n_with_condition(klass)
  it "should provide i18n hash with condition block" do
    expect(klass.roles_i18n{|p| p[:selectable]}).to eq({"guest" => "ゲスト", "general" => "一般ユーザー"})
  end
end

def test_prefix(klass)
  it "should be able to use enum methods with prefix" do
    user = klass.new(role: :guest)
    expect(user.role_guest?).to be(true)
    expect(user.role_admin?).to be(false)
  end
end

def test_params(klass)
  it "should provide parameter hash" do
    expect(klass.role_labels).to eq({"guest" => :red, "general" => :green, "admin" => :blue})
    expect(klass.role_permissions).to eq({"guest" => nil, "general" => false, "admin" => true})
  end
  it "should provide nil as parameter when its attribute is nil" do
    user = klass.new
    expect(user.role_label).to eq(nil)
    expect(user.role_permission).to eq(nil)
  end
  it "should provide parameter by its instance" do
    user = klass.new(role: :guest)
    expect(user.role_val).to eq(0)
    expect(user.role_label).to eq(:red)
    expect(user.role_permission).to eq(nil)
    user = klass.new(role: :general)
    expect(user.role_val).to eq(1)
    expect(user.role_label).to eq(:green)
    expect(user.role_permission).to eq(false)
  end
end

def test_params_with_condition(klass)
  it "should provide parameter hash with condition block" do
    expect(klass.role_labels{|p| p[:selectable]}).to eq({"guest" => :red, "general" => :green})
  end
end

#------------------------------------------------------------------------------

describe Exnum do
  it 'has a version number' do
    expect(Exnum::VERSION).not_to be nil
  end

  context "model setup exnum with array" do
    class User11 < User
      exnum role: [:guest, :general, :admin]
    end

    test_enum(User11)
    test_i18n(User11)
  end

  context "model setup exnum with array and prefix" do
    class User12 < User
      exnum role: [:guest, :general, :admin], _prefix: true
    end

    test_enum(User12)
    test_i18n(User12)
    test_prefix(User12)
  end

  context "model inherit a model using exnum with array" do
    class User13 < User11
    end

    test_enum(User13)
    test_i18n(User13)
  end

  context "model setup exnum with hash" do
    class User21 < User
      exnum role: {guest: 0, general: 1, admin: 2}
    end

    test_enum(User21)
    test_i18n(User21)
  end

  context "model setup exnum with hash and prefix" do
    class User22 < User
      exnum role: {guest: 0, general: 1, admin: 2}, _prefix: true
    end

    test_enum(User22)
    test_i18n(User22)
    test_prefix(User22)
  end


  context "model inherit a model using exnum with hash" do
    class User23 < User21
    end

    test_enum(User23)
    test_i18n(User23)
  end

  context "model setup exnum with hash including parameters" do
    class User31 < User
      exnum role: {
        guest:   {val: 0, label: :red,   selectable: true, },
        general: {val: 1, label: :green, selectable: true,  permission: false},
        admin:   {val: 2, label: :blue,  selectable: false, permission: true},
      }
    end

    test_enum(User31)
    test_i18n(User31)
    test_i18n_with_condition(User31)
    test_params(User31)
    test_params_with_condition(User31)
  end

  context "model setup exnum with hash including parameters and prefix" do
    class User32 < User
      exnum role: {
        guest:   {val: 0, label: :red,   selectable: true, },
        general: {val: 1, label: :green, selectable: true,  permission: false},
        admin:   {val: 2, label: :blue,  selectable: false, permission: true},
      }, _prefix: true
    end

    test_enum(User32)
    test_i18n(User32)
    test_i18n_with_condition(User32)
    test_params(User32)
    test_params_with_condition(User32)
    test_prefix(User32)
  end

  context "model inherit a model using exnum" do
    class User33 < User31
    end

    test_enum(User33)
    test_i18n(User33)
    test_i18n_with_condition(User33)
    test_params(User33)
    test_params_with_condition(User33)
  end
end
