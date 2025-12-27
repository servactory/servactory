# Servactory TestKit

RSpec matchers and helpers for testing Servactory services.

## Installation

The TestKit is included with Servactory. To use it in your specs, include the helpers:

```ruby
# spec/rails_helper.rb or spec/spec_helper.rb
RSpec.configure do |config|
  config.include Servactory::TestKit::Rspec::Helpers
  config.include Servactory::TestKit::Rspec::Matchers
end
```

## Mocking Services

### Fluent API (Recommended)

The fluent API provides a readable, chainable interface for mocking services:

```ruby
# Mock successful service call
mock_service(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_123", status: :completed)

# Mock with input argument matching
mock_service(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_100")
  .when_called_with(amount: 100)

# Mock with partial input matching
mock_service(PaymentService)
  .as_success
  .when_called_with(including(amount: 100))

# Mock failure with exception
mock_service(PaymentService)
  .as_failure
  .with_exception(
    Servactory::Exceptions::Failure.new(
      type: :payment_declined,
      message: "Card declined"
    )
  )

# Mock call! method (raises exception on failure)
mock_service(PaymentService)
  .as_failure
  .with_exception(error)
  .using_call!
```

### Sequential Returns

Mock different responses for consecutive calls:

```ruby
# First call returns pending, second returns completed
mock_service(PaymentService)
  .as_success
  .with_outputs(status: :pending)
  .then_as_success
  .with_outputs(status: :completed)

# Last value is repeated for additional calls
mock_service(RetryService)
  .as_failure
  .with_exception(error)
  .then_as_success
  .with_outputs(result: :ok)
```

### Legacy API

The legacy API is still supported for backward compatibility:

```ruby
# Mock call method (returns Result)
allow_service_as_success(PaymentService) do
  { transaction_id: "txn_123" }
end

# Mock call! method (raises on failure)
allow_service_as_success!(PaymentService, with: { amount: 100 }) do
  { transaction_id: "txn_123" }
end

# Mock failure
allow_service_as_failure(PaymentService) do
  { exception: Servactory::Exceptions::Failure.new(type: :error, message: "Failed") }
end
```

## Argument Matchers

Helpers for flexible argument matching:

```ruby
# Match only specified keys
when_called_with(including(amount: 100))

# Match excluding specified keys
when_called_with(excluding(secret: anything))

# Match any inputs
when_called_with(any_inputs)

# Match no inputs
when_called_with(no_inputs)
```

## Service Verification (Spy Pattern)

Verify that a service was called with specific arguments:

```ruby
# Setup spy and execute code
expect_service(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_123")
  .to_have_been_called
  .once

# Execute code that calls the service
described_class.call(amount: 100)

# Verify with arguments
expect_service(PaymentService)
  .to_have_been_called
  .with(amount: 100)
  .once
```

### Call Count Constraints

```ruby
.once             # exactly 1 time
.twice            # exactly 2 times
.times(3)         # exactly 3 times
.at_least(2)      # 2 or more times
.at_most(5)       # 5 or fewer times
```

## Output Validation

Enable validation of mock outputs against service schema:

```ruby
mock_service(PaymentService)
  .as_success
  .validate_outputs!  # Will raise if outputs don't match service definition
  .with_outputs(transaction_id: "txn_123")
```

## Result Matchers

```ruby
# Check success/failure
expect(result).to be_success_service
expect(result).to be_failure_service

# Check outputs
expect(result).to have_service_output(:transaction_id).with("txn_123")
expect(result).to have_service_output(:status).of_type(Symbol)

# Check failure type
expect(result).to be_failure_service.of(:payment_declined)
```

## Complete Example

```ruby
RSpec.describe CheckoutService, type: :service do
  describe ".call" do
    subject(:result) { described_class.call(cart_id: cart.id) }

    let(:cart) { create(:cart, total: 100) }

    context "when payment succeeds" do
      before do
        mock_service(PaymentService)
          .as_success
          .with_outputs(
            transaction_id: "txn_123",
            status: :completed
          )
          .when_called_with(including(amount: 100))
      end

      it "returns success" do
        expect(result).to be_success_service
      end

      it "includes transaction details" do
        expect(result).to have_service_output(:payment_status).with(:completed)
      end
    end

    context "when payment fails" do
      let(:error) do
        Servactory::Exceptions::Failure.new(
          type: :payment_declined,
          message: "Insufficient funds"
        )
      end

      before do
        mock_service(PaymentService)
          .as_failure
          .with_exception(error)
      end

      it "returns failure" do
        expect(result).to be_failure_service
      end
    end
  end
end
```
