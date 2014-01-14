# Hipchat Addon

Send [Magnum CI](http://magnum-ci.com) build notifications to a [Hipchat](http://hipchat.com) room

![Build Status](https://magnum-ci.com/status/eec71210ee9e5dac3ba8aa4a9205f66e.png) 
[![Code Climate](https://codeclimate.com/github/magnumci/addon-hipchat.png)](https://codeclimate.com/github/magnumci/addon-hipchat)

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

NOTE: This addon only supports Hipchat API v2 token

Available options:

- `api_token` - API token
- `room`      - Room ID

## Features

- Colored messages
- Team notification
- Build and commit links

## Testing

Execute test suite:

```
bundle exec rake test
```

## License

The MIT License (MIT)

Copyright (c) 2013-2014 Dan Sosedoff, <dan.sosedoff@gmail.com>