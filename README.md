# RSpec Isolate

Enforce isolation in your unit tests.

When asked, it will block access to collaborator classes, making your tests fail until you mock out the dependencies.

This is a learning and feedback tool. Use it to help you achieve isolation in your unit tests, but don't rely on it for anything heavy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-isolate'
```

And then execute:

```bash
$ bundle
```

## Usage

Require `rspec/isolate` in your `spec_helper.rb` as below.

```ruby
# spec_helper.rb
require 'rspec/isolate'
```

Add a tag to your describe block as below.

```ruby
RSpec.describe ClassUnderTest, error_on_call: [ CollaboratorClassOne, CollaboratorClassTwo ] do
  # Calling any method on `CollaboratorClassOne` and `CollaboratorClassTwo` in
  # the course of this test suite will raise an error.
end
```

Or, if you prefer warnings to errors.

```ruby
RSpec.describe ClassUnderTest, warn_on_call: [ CollaboratorClassOne, CollaboratorClassTwo ] do
  # Calling any method on `CollaboratorClassOne` and `CollaboratorClassTwo` in
  # the course of this test suite will present a warning.
end
```

A fuller example follows.

```ruby
# lib/statement_formatter.rb
class StatementFormatter
  HEADER = "Date | Amount"

  def initialize
    @transaction_formatter = TransactionFormatter.new
  end

  def format(transactions)
    HEADER + "\n" + format_transactions(transactions)
  end

  private

  def format_transactions
    transactions.map do |transaction|
      @transaction_formatter.format(transaction)
    end.join("\n")
  end
end

# lib/transaction_formatter.rb
class TransactionFormatter
  def format
    "#{transaction[:date]} | #{transaction[:amount]}"
  end
end

# spec/statement_formatter.rb

RSpec.describe StatementFormatter, error_on_call: [ TransactionFormatter ] do
  describe "#format" do

    # This will fail, as `StatementFormatter` will call `TransactionFormatter`
    it "formats a statement" do
      statement_formatter = StatementFormatter.new
      formatted = statement_formatter.format([
        {date: "01/01/70", amount: 400},
        {date: "02/01/70", amount: -200}
      ])
      expect(formatted).to eq(
        "Date | Amount\n" \
        "01/01/70 | 400\n" \
        "02/01/70 | -200" \
      )
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/neoeno/rspec-isolate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `rspec-isolate` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rspec-isolate/blob/master/CODE_OF_CONDUCT.md).
