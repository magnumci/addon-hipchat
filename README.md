# Hipchat Addon

Send [Magnum CI](http://magnum-ci.com) build notifications to a [Hipchat](http://hipchat.com) room

![Build Status](https://magnum-ci.com/status/eec71210ee9e5dac3ba8aa4a9205f66e.png)

## Usage

Example:

```ruby
require "magnum/addons/hipchat"

# Initialize addon
addon = Magnum::Addon::Hipchat.new(api_token: "token", room: "room")

# Send build payload
addon.run(build_payload)
```

## Configuration

Available options:

- `api_token` - Hipchat API v2 token (v1 is not supported)
- `room`      - Hipchat room ID

## Testing

Execute test suite:

```
bundle exec rake test
```

## License

The MIT License (MIT)

Copyright (c) 2013-2014 Magnum CI, <support@magnum-ci.com>
