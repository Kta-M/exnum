require 'spec_helper'

#------------------------------------------------------------------------------
# test model definition
class User < ActiveRecord::Base
end

#------------------------------------------------------------------------------
# test code
describe Exnum do
  it 'has a version number' do
    expect(Exnum::VERSION).not_to be nil
  end

  context "model setup exnum with array" do
    class User1 < User
      exnum role: [:guest, :general, :admin]
    end

    it "should use as well as enum" do
      expect(User1.roles).to eq({"guest" => 0, "general" => 1, "admin" => 2})
    end
    it "should provide i18n hash" do
      expect(User1.roles_i18n).to eq({"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"})
    end
    it "should provide i18n string by its instance" do
      user = User1.new(role: :guest)
      expect(user.role_i18n).to eq("ゲスト")
    end
  end

  context "model setup exnum with hash" do
    class User2 < User
      exnum role: {guest: 10, general: 20, admin: 30}
    end

    it "should use as well as enum" do
      expect(User2.roles).to eq({"guest" => 10, "general" => 20, "admin" => 30})
    end
    it "should provide i18n hash" do
      expect(User2.roles_i18n).to eq({"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"})
    end
    it "should provide i18n string by its instance" do
      user = User2.new(role: :guest)
      expect(user.role_i18n).to eq("ゲスト")
    end
  end

  context "model setup exnum with hash including parameters" do
    class User3 < User
      exnum role: {
        guest:   {val: 10, label: :red },
        general: {val: 20, label: :green, permission: false},
        admin:   {val: 30, label: :blue,  permission: true},
      }
    end

    it "should use as well as enum" do
      expect(User3.roles).to eq({"guest" => 10, "general" => 20, "admin" => 30})
    end
    it "should provide i18n hash" do
      expect(User3.roles_i18n).to eq({"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"})
    end
    it "should provide i18n string by its instance" do
      user = User3.new
      expect(user.role_i18n).to eq(nil)
      user = User3.new(role: :guest)
      expect(user.role_i18n).to eq("ゲスト")
    end
    it "should provide parameter hash" do
      expect(User3.role_labels).to eq({"guest" => :red, "general" => :green, "admin" => :blue})
      expect(User3.role_permissions).to eq({"guest" => nil, "general" => false, "admin" => true})
    end
    it "should provide parameter by its instance" do
      user = User3.new
      expect(user.role_label).to eq(nil)
      expect(user.role_permission).to eq(nil)
      user = User3.new(role: :guest)
      expect(user.role_label).to eq(:red)
      expect(user.role_permission).to eq(nil)
      user = User3.new(role: :general)
      expect(user.role_label).to eq(:green)
      expect(user.role_permission).to eq(false)
    end
  end

  context "model inherit a model using exnum" do
    class User4 < User
      exnum role: {
        guest:   {val: 10, label: :red },
        general: {val: 20, label: :green, permission: false},
        admin:   {val: 30, label: :blue,  permission: true},
      }
    end

    it "should use as well as enum" do
      expect(User4.roles).to eq({"guest" => 10, "general" => 20, "admin" => 30})
    end
    it "should provide i18n hash" do
      expect(User4.roles_i18n).to eq({"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"})
    end
    it "should provide i18n string by its instance" do
      user = User4.new
      expect(user.role_i18n).to eq(nil)
      user = User4.new(role: :guest)
      expect(user.role_i18n).to eq("ゲスト")
    end
    it "should provide parameter hash" do
      expect(User4.role_labels).to eq({"guest" => :red, "general" => :green, "admin" => :blue})
      expect(User4.role_permissions).to eq({"guest" => nil, "general" => false, "admin" => true})
    end
    it "should provide parameter by its instance" do
      user = User4.new
      expect(user.role_label).to eq(nil)
      expect(user.role_permission).to eq(nil)
      user = User4.new(role: :guest)
      expect(user.role_label).to eq(:red)
      expect(user.role_permission).to eq(nil)
      user = User4.new(role: :general)
      expect(user.role_label).to eq(:green)
      expect(user.role_permission).to eq(false)
    end
  end

end
