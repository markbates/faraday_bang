# Faraday!
[![Build Status](https://travis-ci.org/markbates/faraday_bang.png)](https://travis-ci.org/markbates/faraday_bang) [![Code Climate](https://codeclimate.com/github/markbates/faraday_bang.png)](https://codeclimate.com/github/markbates/faraday_bang)

[Faraday](https://github.com/lostisland/faraday) is a great HTTP library, but it would be even better if had ! versions of all it's methods to raise errors when the request does not receive a successful response. Enter Farady! (pronounced Faraday Bang).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday_bang'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install faraday_bang
```

## Usage

Using Faraday! is just as easy as using Faraday, except all you have to do is add a `!` to the Faraday methods.

```ruby
response = Faraday.get!('http://sushi.com/nigiri/sake.json')
```

If a response is not successful, then a `Faraday::Bang::ResponseError` error will be raised.

Each of the HTTP error status codes have been given their own sub-class to make catching them even easier. Here are a few examples:

```ruby
Faraday::Bang::Response401Error
Faraday::Bang::Response404Error
Faraday::Bang::Response500Error
Faraday::Bang::Response503Error
```

## But Wait! There's More!

As a special added bonus an `as_json` method has been added to `Faraday::Response` to make it easier to JSON bodies back as a Ruby Hash.

```ruby
response = Faraday.get!('http://example.com/example.json')
json = response.as_json
puts json # => {"name"=>"Mark"}
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/faraday_bang/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
