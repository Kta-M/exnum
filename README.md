# Exnum

[![Gem Version](https://badge.fury.io/rb/exnum.svg)](https://badge.fury.io/rb/exnum)
[![CircleCI](https://circleci.com/gh/Kta-M/exnum.svg?style=svg)](https://circleci.com/gh/Kta-M/exnum)
[![Maintainability](https://api.codeclimate.com/v1/badges/d8d694f943658d8a5506/maintainability)](https://codeclimate.com/github/Kta-M/exnum/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d8d694f943658d8a5506/test_coverage)](https://codeclimate.com/github/Kta-M/exnum/test_coverage)

Exnum is enum extention for Rails.
This gem extends enum about i18n, associated parameters, and array for select box.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exnum'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install exnum
```

## Usage

```ruby
class User < ActiveRecord::Base
  # the value of the key "val" defines enum values
  # and the others defines associated parameters
  exnum role: {
    guest:   {val: 10, label: :red,   selectable: true, },
    general: {val: 20, label: :green, selectable: true,  permission: false},
    admin:   {val: 30, label: :blue,  selectable: false, permission: true},
  }
end
```

### Assosiated parameter extention
```ruby
User.role_labels
# => {"guest" => :red, "general" => :green, "admin" => :blue}
User.role_labels{|p| p[:selectable]}
# => {"guest" => :red, "general" => :green}
User.role_permissions
# => {"guest" => nil, "general" => false, "admin" => true}
```

```ruby
user = User.new(role: :general)
user.role_label
# => :green
user.role_permission
# => false
```

### I18n extention

```yaml
ja:
  activerecord:
    enum:
      user:        # model name
        role:      # field name
          guest:   ゲスト
          general: 一般ユーザー
          admin:   管理者
```

```ruby
User.roles_i18n
# => {"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"}
User.roles_i18n{|p| p[:selectable]}
# => {"guest" => "ゲスト", "general" => "一般ユーザー"}
```

```ruby
user = User.new(role: :guest)
user.role_i18n
# => "ゲスト"
```

### Array for select box extention
```ruby
User.roles_for_select
# => [["ゲスト", "guest"], ["一般ユーザー", "general"], ["管理者", "admin"]]
User.roles_for_select{|p| p[:selectable]}
# => [["ゲスト", "guest"], ["一般ユーザー", "general"]]
```

You can use it like this:
```ruby
<%= f.select :role, User.roles_for_select %>
```

### enum
Of course, you can use methods provided by `enum`.
```ruby
class User < ActiveRecord::Base
  exnum role: [:guest, :general, :admin]
end
```
```ruby
class User < ActiveRecord::Base
  exnum role: {guest: 10, general: 20, admin: 30}
end
```
```ruby
class User < ActiveRecord::Base
  exnum role: {guest: 10, general: 20, admin: 30}, _prefix: true
end
```

## Contributing

1. Fork it!
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


