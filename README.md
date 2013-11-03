# magnum-addon-hipchat

[Hipchat](http://hipchat.com) notifier addon for Magnum CI

## Usage

Load:

```ruby
require "magnum/addon/hipchat"
```

Send notification:

```ruby
addon = Magnum::Addon::Hipchat.new(api_token: "token", room: "room")
addon.run(build_payload)
```

## Configuration

Available options:

- `api_token` - Hipchat API v2 token (v1 is not supported)
- `room` - Hipchat room ID