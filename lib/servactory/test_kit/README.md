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
# Mock successful service call (minimal - no outputs)
allow_service(NotificationService).as_success

# Mock with outputs
allow_service(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_123", status: :completed)

# Mock with input argument matching
allow_service(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_100")
  .when_called_with(amount: 100)

# Mock with partial input matching
allow_service(PaymentService)
  .as_success
  .when_called_with(including(amount: 100))
```

Use `allow_service!` for mocking `.call!` method (raises exception on failure):

```ruby
# Mock successful call!
allow_service!(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_123")

# Mock failure - raises exception
allow_service!(PaymentService)
  .as_failure
  .with_exception(error)
```

### Failure Mocking

Exception is **required** for failure mocks. Servactory supports custom exception
classes via configuration, so you must explicitly specify which exception to use:

```ruby
# For .call method (returns failure Result)
error = ApplicationService::Exceptions::Failure.new(
  type: :payment_declined,
  message: "Card declined"
)

allow_service(PaymentService)
  .as_failure
  .with_exception(error)

# For .call! method (raises exception)
allow_service!(PaymentService)
  .as_failure
  .with_exception(error)
```

### Sequential Returns

Mock different responses for consecutive calls:

```ruby
# First call returns pending, second returns completed
allow_service(PaymentService)
  .as_success
  .with_outputs(status: :pending)
  .then_as_success
  .with_outputs(status: :completed)

# Failure then success (retry scenario)
allow_service(RetryService)
  .as_failure
  .with_exception(error)
  .then_as_success
  .with_outputs(result: :ok)

# Multiple successes then failure
allow_service(PaymentService)
  .as_success.with_outputs(attempt: 1)
  .then_as_success.with_outputs(attempt: 2)
  .then_as_failure.with_exception(error)
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
      type: :error,
      message: "Failed"
    )
  }
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

Use standard RSpec expectations to verify service calls:

```ruby
# Setup mock first
allow_service(PaymentService)
  .as_success
  .with_outputs(transaction_id: "txn_123")

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
  .as_success
  .validate_outputs!  # Will raise if outputs don't match service definition
  .with_outputs(transaction_id: "txn_123")

# Or skip validation explicitly
allow_service(PaymentService)
  .as_success
  .skip_output_validation
  .with_outputs(anything: "allowed")
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

## Complete Example

```ruby
RSpec.describe CheckoutService, type: :service do
  describe ".call!" do
    subject(:perform) { described_class.call!(**attributes) }

    let(:attributes) do
      {
        cart_id:
      }
    end

    let(:cart_id) { 123 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(PaymentService)
            .as_success
            .with_outputs(
              transaction_id: "txn_123",
              status: :completed
            )
            .when_called_with(including(amount: 100))
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:payment_status).contains(:completed) }
      end

      describe "but the data required for work is invalid" do
        describe "because payment service fails" do
          let(:error) do
            ApplicationService::Exceptions::Failure.new(
              type: :payment_declined,
              message: "Insufficient funds"
            )
          end

          before do
            allow_service(PaymentService)
              .as_failure
              .with_exception(error)
          end

          it "returns expected error", :aggregate_failures do
            expect { perform }.to(
              raise_error do |exception|
                expect(exception).to be_a(ApplicationService::Exceptions::Failure)
                expect(exception.type).to eq(:payment_declined)
              end
            )
          end
        end
      end
    end
  end

  describe ".call" do
    subject(:perform) { described_class.call(**attributes) }

    let(:attributes) do
      {
        cart_id:
      }
    end

    let(:cart_id) { 123 }

    context "when the input arguments are valid" do
      describe "and the data required for work is also valid" do
        before do
          allow_service(PaymentService)
            .as_success
            .with_outputs(transaction_id: "txn_123", status: :completed)
        end

        it_behaves_like "success result class"

        it { expect(perform).to have_output(:payment_status).contains(:completed) }
      end

      describe "but the data required for work is invalid" do
        let(:error) do
          ApplicationService::Exceptions::Failure.new(
            type: :payment_declined,
            message: "Insufficient funds"
          )
        end

        before do
          allow_service(PaymentService)
            .as_failure
            .with_exception(error)
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
