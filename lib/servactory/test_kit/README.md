# Servactory TestKit

RSpec matchers and helpers for testing Servactory services.

## Installation

The TestKit is included with Servactory. To use it in your specs, include the helpers:

```ruby
# spec/rails_helper.rb or spec/spec_helper.rb
RSpec.configure do |config|
  config.include Servactory::TestKit::Rspec::Helpers, type: :service
  config.include Servactory::TestKit::Rspec::Matchers, type: :service
end
```

## Mocking Services

### Fluent API

The fluent API provides a readable, chainable interface for mocking services.

Use `allow_service` for mocking `.call` method (returns Result):

```ruby
# Mock successful service call with outputs
allow_service(PaymentService)
  .succeeds(transaction_id: "txn_123", status: :completed)

# Mock with input matching
allow_service(PaymentService)
  .inputs(amount: 100)
  .succeeds(transaction_id: "txn_100")

# Mock with partial input matching
allow_service(PaymentService)
  .inputs(including(amount: 100))
  .succeeds(transaction_id: "txn_100")

# Order doesn't matter - inputs can come after succeeds
allow_service(PaymentService)
  .succeeds(transaction_id: "txn_100")
  .inputs(amount: 100)
```

Use `allow_service!` for mocking `.call!` method (raises exception on failure):

```ruby
# Mock successful call!
allow_service!(PaymentService)
  .succeeds(transaction_id: "txn_123")

# Mock failure - raises exception
allow_service!(PaymentService)
  .fails(message: "Card declined", type: :payment_declined)
```

### Failure Mocking

The `fails()` method creates an exception automatically:

```ruby
# Minimal - only message (type defaults to :base)
allow_service(PaymentService)
  .fails(message: "Card declined")

# With error type
allow_service(PaymentService)
  .fails(message: "Card declined", type: :payment_declined)

# With metadata
allow_service(PaymentService)
  .fails(
    message: "Card declined",
    type: :payment_declined,
    meta: { card_last4: "1234" }
  )

# With custom exception class
allow_service(PaymentService)
  .fails(CustomException, message: "Custom error", type: :error)
```

The exception class is determined by:
1. First positional argument if provided
2. Otherwise `service_class.config.failure_class`

### Sequential Returns

Mock different responses for consecutive calls:

```ruby
# First call returns pending, second returns completed
allow_service(PaymentService)
  .succeeds(status: :pending)
  .then_succeeds(status: :completed)

# Success then failure (retry scenario)
allow_service(RetryService)
  .succeeds(status: :pending)
  .then_fails(message: "Request timed out", type: :timeout)

# Multiple successes then failure
allow_service(PaymentService)
  .succeeds(attempt: 1)
  .then_succeeds(attempt: 2)
  .then_fails(message: "Max retries exceeded", type: :max_retries)
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
  {
    exception: ApplicationService::Exceptions::Failure.new(
      type: :base,
      message: "Failed"
    )
  }
end
```

## Input Matchers

Helpers for flexible input matching:

```ruby
# Match only specified keys
inputs(including(amount: 100))

# Match excluding specified keys
inputs(excluding(secret: anything))

# Match any inputs
inputs(any_inputs)

# Match no inputs
inputs(no_inputs)
```

## Service Verification (Spy Pattern)

Use standard RSpec expectations to verify service calls:

```ruby
# Setup mock first
allow_service(PaymentService)
  .succeeds(transaction_id: "txn_123")

# Execute code that calls the service
described_class.call(amount: 100)

# Verify with standard RSpec
expect(PaymentService).to have_received(:call).with(amount: 100).once
```

### Call Count Constraints

```ruby
.once             # exactly 1 time
.twice            # exactly 2 times
.exactly(3).times # exactly 3 times
.at_least(:once)  # 1 or more times
.at_most(5).times # 5 or fewer times
```

## Output Validation

Enable validation of mock outputs against service schema:

```ruby
allow_service(PaymentService)
  .validate_outputs!  # Will raise if outputs don't match service definition
  .succeeds(transaction_id: "txn_123")

# Or skip validation explicitly
allow_service(PaymentService)
  .skip_output_validation
  .succeeds(anything: "allowed")
```

## Result Matchers

```ruby
# Check success/failure
expect(result).to be_success_service
expect(result).to be_failure_service

# Check failure type
expect(result).to be_failure_service.type(:payment_declined)

# Check outputs
expect(result).to have_output(:transaction_id).contains("txn_123")
expect(result).to have_output(:status).instance_of(Symbol)
```

## Difference Between allow_service and allow_service!

| Method | Mocks | On Failure |
|--------|-------|------------|
| `allow_service(S)` | `.call` | Returns Result with `.error` |
| `allow_service!(S)` | `.call!` | Raises exception |

### Testing Failure with `.call` (Result.error)

```ruby
describe ".call" do
  before do
    allow_service(PaymentService)
      .fails(message: "Insufficient funds", type: :payment_declined)
  end

  it "returns the expected value in `error`", :aggregate_failures do
    expect(perform.error).to be_a(ApplicationService::Exceptions::Failure)
    expect(perform.error).to an_object_having_attributes(
      type: :payment_declined,
      message: "Insufficient funds"
    )
  end
end
```

### Testing Failure with `.call!` (raise_error)

```ruby
describe ".call!" do
  before do
    allow_service!(PaymentService)
      .fails(message: "Insufficient funds", type: :payment_declined)
  end

  it "raises expected exception", :aggregate_failures do
    expect { perform }.to raise_error(ApplicationService::Exceptions::Failure) do |e|
      expect(e.type).to eq(:payment_declined)
      expect(e.message).to eq("Insufficient funds")
    end
  end
end
```

## Complete Example

```ruby
RSpec.describe CheckoutService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) { { cart_id: } }
    let(:cart_id) { 123 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service!(PaymentService)
            .inputs(including(amount: 100))
            .succeeds(transaction_id: "txn_123", status: :completed)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:payment_status).contains(:completed) }
      end

      describe "but the data required for work is invalid" do
        describe "because payment service fails" do
          before do
            allow_service!(PaymentService)
              .fails(message: "Insufficient funds", type: :payment_declined)
          end

          it "raises expected exception", :aggregate_failures do
            expect { perform }.to raise_error(ApplicationService::Exceptions::Failure) do |e|
              expect(e.type).to eq(:payment_declined)
              expect(e.message).to eq("Insufficient funds")
            end
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) { { cart_id: } }
    let(:cart_id) { 123 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(PaymentService)
            .succeeds(transaction_id: "txn_123", status: :completed)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:payment_status).contains(:completed) }
      end

      describe "but the data required for work is invalid" do
        before do
          allow_service(PaymentService)
            .fails(message: "Insufficient funds", type: :payment_declined)
        end

        it "returns the expected value in `error`", :aggregate_failures do
          expect(perform.error).to be_a(ApplicationService::Exceptions::Failure)
          expect(perform.error).to an_object_having_attributes(
            type: :payment_declined,
            message: "Insufficient funds"
          )
        end
      end
    end
  end
end
```
