# Exnum

[![Gem Version](https://badge.fury.io/rb/exnum.svg)](https://badge.fury.io/rb/exnum)
[![Build Status](https://travis-ci.org/Kta-M/exnum.svg?branch=master)](https://travis-ci.org/Kta-M/exnum)
[![Code Climate](https://codeclimate.com/github/Kta-M/exnum/badges/gpa.svg)](https://codeclimate.com/github/Kta-M/exnum)
[![Test Coverage](https://codeclimate.com/github/Kta-M/exnum/badges/coverage.svg)](https://codeclimate.com/github/Kta-M/exnum/coverage)

Exnum is enum extention for Rails.
This gem extends enum about i18n and associated parameters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exnum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exnum

## Usage

ActiveRecord:
```
class User < ActiveRecord::Base
  # the value of the key "val" defines enum values
  # and the others defines associated parameters
  exnum role: {
    guest:   {val: 10, label: :red },
    general: {val: 20, label: :green, permission: false },
    admin:   {val: 30, label: :blue,  permission: true},
  }
end

```

I18n:
```
ja:
  activerecord:
    enum:
      user:        # model name
        role:      # field name
          guest:   ゲスト
          general: 一般ユーザー
          admin:   管理者

```

Then you can use i18n extention
```
User.roles_i18n
# => {"guest" => "ゲスト", "general" => "一般ユーザー", "admin" => "管理者"}

user = User.new(role: :guest)
user.role_i18n
# => "ゲスト"
```

and assosiated parameter extention.
```
User.role_labels
# => {"guest" => :red, "general" => :green, "admin" => :blue}
User.role_permissions
# => {"guest" => nil, "general" => false, "admin" => true}

user = User.new(role: :general)
user.role_label
# => :green
user.role_permission
# => false
```

And of cause, you can use methods provided by `enum`.

`exnum` can also use as well as `enum`.
Then you can use extention only about i18n.
```
class User < ActiveRecord::Base
  exnum role: [:guest, :general, :admin]
end
```
```
class User < ActiveRecord::Base
  exnum role: {guest: 10, general: 20, admin: 30}
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

