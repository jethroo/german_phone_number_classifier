# German Phone Number Classifier

Library for checking in which category a german phone number falls in regards to [Bundesnetzagentur classes](https://www.bundesnetzagentur.de/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Nummerierung/start.html).

## Usage

Add the gem to your Gemfile:

```ruby
# TODO to be releases on rubygems
gem 'german_phone_number_classifier', github: 'jethroo/german_phone_number_classifier', branch: 'master'
```

and run `bundle install`.

The module comes with 2 class methods as public interface.

### .classify

This method is for identifying the a telephone number as part of the german phone number system and will put it in a category identified as symbol:

```ruby
irb(main):001:0> GermanPhoneNumberClassifier.classify('+4930120849110')
=> :landline
irb(main):002:0> GermanPhoneNumberClassifier.classify('+4830120849110')
=> :non_german_phone_number
irb(main):003:0> GermanPhoneNumberClassifier.classify('+4915012345678')
=> :mobile
```

Following categories are defined:

* `:no_phone_number`
* `:non_german_phone_number`
* `:authoritative`
* `:provider_selection`
* `:high_connection`
* `:service_hotline`
* `:vpn`
* `:online_and_traffic`
* `:personal_number`
* `:free_service_hotline`
* `:dialer`
* `:mobile`
* `:premium_service_hotline`
* `:test_provider`
* [`:landline`](https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/ONRufnr/ortsnetze_node.html)
* `:unknown_class`

### .landline_location

Furthermore the gem offers a utility function to get the location from prefix mappings for german phone numbers which are `:landline`. All others numbers will get `nil` returned.

```ruby
irb(main):002:0> GermanPhoneNumberClassifier.landline_location('+4930120849110')
=> "Berlin"
```

## Development

Test can be run with rspec: `bundle exec rspec` and rubocop: `bundle exec rubocop`


## Contributing

1. Fork it (https://github.com/jethroo/german_phone_number_classifier/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Notes:

- Contributions without tests won't be accepted.
- Please don't update the gem version.

## License

see [here](LICENSE)
