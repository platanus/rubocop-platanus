# Rubocop Platanus

[![Gem Version](https://badge.fury.io/rb/rubocop-platanus.svg)](https://badge.fury.io/rb/rubocop-platanus)
[![CircleCI](https://circleci.com/gh/platanus/rubocop-platanus.svg?style=shield)](https://app.circleci.com/pipelines/github/platanus/rubocop-platanus)

A RuboCop extension for enforcing [Platanus](https://github.com/platanus) best practices and code style.

## Installation

```bash
gem install rubocop-platanus
```

Or add to your Gemfile:

```ruby
gem "rubocop-platanus"
```

```bash
bundle install
```

## Usage

You need to tell RuboCop to load the Platanus extension. There are three ways to do this:

### RuboCop configuration file

Put this into your .rubocop.yml.

```yaml
require: rubocop-platanus
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
require:
  - rubocop-other-extension
  - rubocop-platanus
```

Now you can run rubocop and it will automatically load the RuboCop Platanus cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-platanus
```

## Testing

To run the specs you need to execute, **in the root path of the gem**, the following command:

```bash
bundle exec guard
```

You need to put **all your tests** in the `/my_gem/spec/` directory.

## Development

To create a new cop, you need to execute, **in the root path of the gem**, the following command:

```bash
$ bundle exec rake 'new_cop[Foobar/SuperCoolCopName]'
[create] lib/rubocop/cop/foobar/super_cool_name.rb
[create] spec/rubocop/cop/foobar/super_cool_name.rb
[modify] lib/rubocop/cop/potassium_cops.rb - `require_relative 'foobar/super_cool_name'` was injected.
[modify] A configuration for the cop is added into config/default.yml.
Do 4 steps:
  1. Modify the description of Foobar/SuperCoolCopName in config/default.yml
  2. Implement your new cop in the generated file!
  3. Commit your new cop with a message such as
     e.g. "Add new `Foobar/SuperCoolCopName` cop"
  4. Run `bundle exec rake changelog:new` to generate a changelog entry
     for your new cop.
```

## Publishing

On master/main branch...

1. Change `VERSION` in `lib/rubocop-platanus/version.rb`.
2. Change `Unreleased` title to current version in `CHANGELOG.md`.
3. Run `bundle install`.
4. Commit new release. For example: `Releasing v0.1.0`.
5. Create tag. For example: `git tag v0.1.0`.
6. Push tag. For example: `git push origin v0.1.0`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/rubocop-platanus/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

Test Gem is maintained by [platanus](http://platan.us).

## License

Test Gem is © 2022 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
