# Servactory RSpec Test Kit

A comprehensive RSpec integration for testing Servactory services, providing matchers, helpers, and utilities for service validation testing.

## Table of Contents

- [Setup \& Configuration](#setup--configuration)
- [Service Mocking Helpers](#service-mocking-helpers)
- [Result Factory](#result-factory)
- [Service Result Matchers](#service-result-matchers)
  - [be\_success\_service](#be_success_service)
  - [be\_failure\_service](#be_failure_service)
- [Input Matchers](#input-matchers)
- [Internal Matchers](#internal-matchers)
- [Output Matchers](#output-matchers)
- [Utilities](#utilities)
- [Common Testing Patterns](#common-testing-patterns)

---

## Setup & Configuration

The RSpec test kit is **not auto-loaded** by Zeitwerk. You must manually require it in your `spec_helper.rb` or `rails_helper.rb`:

```ruby
# spec/spec_helper.rb or spec/rails_helper.rb

require "servactory/test_kit/rspec/helpers"
require "servactory/test_kit/rspec/matchers"

RSpec.configure do |config|
  # Include helpers and matchers for tests with type: :service
  config.include Servactory::TestKit::Rspec::Helpers, type: :service
  config.include Servactory::TestKit::Rspec::Matchers, type: :service
end
```

Then use `type: :service` metadata in your specs:

```ruby
RSpec.describe MyService, type: :service do
  # Helpers and matchers are available here
end
```

---

## Service Mocking Helpers

Helpers for mocking service calls in tests. Useful when testing services that depend on other services.

### `allow_service_as_success!(service_class, with: nil, &block)`

Mocks the `call!` method to return a successful result.

**Parameters:**
- `service_class` - The service class to mock
- `with:` (optional) - Expected arguments matcher (Hash or RSpec matcher)
- `&block` - Block returning Hash of output attributes

**Example:**

```ruby
before do
  allow_service_as_success!(PaymentService) do
    { transaction_id: "txn_123", status: :completed }
  end
end

it "processes payment" do
  result = OrderService.call!(order: order)
  expect(result).to be_success_service
end
```

**With argument matching:**

```ruby
before do
  allow_service_as_success!(PaymentService, with: { amount: 100 }) do
    { transaction_id: "txn_123" }
  end
end
```

### `allow_service_as_success(service_class, with: nil, &block)`

Same as `allow_service_as_success!` but mocks the `call` method (non-bang version).

```ruby
before do
  allow_service_as_success(PaymentService) do
    { transaction_id: "txn_123" }
  end
end
```

### `allow_service_as_failure!(service_class, with: nil, &block)`

Mocks the `call!` method to raise a failure exception.

**Parameters:**
- `service_class` - The service class to mock
- `with:` (optional) - Expected arguments matcher
- `&block` - Block returning an exception or Hash with `:exception` key

**Example:**

```ruby
before do
  allow_service_as_failure!(PaymentService) do
    Servactory::Exceptions::Failure.new(
      type: :payment_declined,
      message: "Card declined"
    )
  end
end

it "handles payment failure" do
  expect { OrderService.call!(order: order) }.to raise_error(
    Servactory::Exceptions::Failure
  )
end
```

### `allow_service_as_failure(service_class, with: nil, &block)`

Same as `allow_service_as_failure!` but mocks the `call` method to return a failure result (without raising).

```ruby
before do
  allow_service_as_failure(PaymentService) do
    { exception: Servactory::Exceptions::Failure.new(message: "Failed") }
  end
end
```

---

## Result Factory

Create mock service results without invoking actual services. Useful for unit testing components that receive service results.

### `Servactory::TestKit::Result.as_success(**attributes)`

Creates a successful `Servactory::Result` instance.

**Parameters:**
- `**attributes` - Output attributes to include in the result
- `service_class:` (optional) - Service class for context

**Example:**

```ruby
result = Servactory::TestKit::Result.as_success(
  user: user,
  token: "abc123"
)

expect(result.success?).to be(true)
expect(result.user).to eq(user)
expect(result.token).to eq("abc123")
```

**With service class context:**

```ruby
result = Servactory::TestKit::Result.as_success(
  user: user,
  service_class: UserRegistrationService
)
```

### `Servactory::TestKit::Result.as_failure(**attributes)`

Creates a failed `Servactory::Result` instance.

**Parameters:**
- `**attributes` - Output attributes for the failure context
- `service_class:` (optional) - Service class for context
- `exception:` (optional) - Exception to include in the failure

**Example:**

```ruby
result = Servactory::TestKit::Result.as_failure(
  exception: Servactory::Exceptions::Failure.new(
    type: :validation_error,
    message: "Invalid email format"
  )
)

expect(result.failure?).to be(true)
expect(result.error.type).to eq(:validation_error)
```

---

## Service Result Matchers

### `be_success_service`

Asserts that a service result is successful.

**Basic usage:**

```ruby
it "returns success" do
  result = MyService.call(params)
  expect(result).to be_success_service
end
```

#### Chain: `.with_output(key, value)`

Asserts a single output value:

```ruby
it "returns user data" do
  result = UserService.call(id: 1)
  expect(result).to be_success_service
    .with_output(:user_name, "John")
end
```

#### Chain: `.with_outputs(hash)`

Asserts multiple output values:

```ruby
it "returns full user data" do
  result = UserService.call(id: 1)
  expect(result).to be_success_service
    .with_outputs(
      user_name: "John",
      email: "john@example.com",
      active: true
    )
end
```

**Combining chains:**

```ruby
expect(result).to be_success_service
  .with_output(:status, :completed)
  .with_outputs(amount: 100, currency: "USD")
```

---

### `be_failure_service`

Asserts that a service result is a failure.

**Basic usage:**

```ruby
it "returns failure" do
  result = MyService.call(invalid_params)
  expect(result).to be_failure_service
end
```

#### Chain: `.with(failure_class)`

Specifies the expected exception class:

```ruby
expect(result).to be_failure_service
  .with(Servactory::Exceptions::Failure)
```

**With custom exception class:**

```ruby
expect(result).to be_failure_service
  .with(ApplicationService::Exceptions::Failure)
```

#### Chain: `.type(expected_type)`

Asserts the error type (Symbol). Default expected type is `:base`.

```ruby
expect(result).to be_failure_service
  .type(:validation_error)
```

#### Chain: `.message(expected_message)`

Asserts the error message (String):

```ruby
expect(result).to be_failure_service
  .message("Email is invalid")
```

#### Chain: `.meta(expected_meta)`

Asserts the error metadata (Hash or object):

```ruby
expect(result).to be_failure_service
  .meta({ field: :email, code: "invalid_format" })
```

**Combining all chains:**

```ruby
expect(result).to be_failure_service
  .with(Servactory::Exceptions::Failure)
  .type(:validation_error)
  .message("Email is invalid")
  .meta({ field: :email })
```

---

## Input Matchers

### `have_service_input(input_name)` / `have_input`

Tests service input attribute configuration.

**Basic usage:**

```ruby
RSpec.describe UserService, type: :service do
  it { expect(described_class).to have_input(:email) }
end
```

#### Chain: `.type(type)`

Asserts a single input type:

```ruby
it { expect(described_class).to have_input(:email).type(String) }
it { expect(described_class).to have_input(:count).type(Integer) }
```

#### Chain: `.types(*types)`

Asserts multiple allowed types:

```ruby
it { expect(described_class).to have_input(:enabled).types(TrueClass, FalseClass) }
it { expect(described_class).to have_input(:data).types(String, Integer, Array) }
```

#### Chain: `.required(custom_message = nil)`

Asserts input is required:

```ruby
it { expect(described_class).to have_input(:email).required }
```

**With custom error message:**

```ruby
it { expect(described_class).to have_input(:email).required("Email is required") }
```

#### Chain: `.optional`

Asserts input is optional:

```ruby
it { expect(described_class).to have_input(:nickname).optional }
```

#### Chain: `.default(value)`

Asserts the default value:

```ruby
it { expect(described_class).to have_input(:status).default(:pending) }
it { expect(described_class).to have_input(:count).default(0) }
it { expect(described_class).to have_input(:data).default(nil) }
```

#### Chain: `.consists_of(*types)`

For collection inputs, asserts element types:

```ruby
it do
  expect(described_class).to have_input(:tags)
    .type(Array)
    .consists_of(String)
end

it do
  expect(described_class).to have_input(:scores)
    .type(Array)
    .consists_of(Integer, Float)
end
```

#### Chain: `.schema(data = {})`

Asserts schema validation template:

```ruby
it do
  expect(described_class).to have_input(:address)
    .type(Hash)
    .schema({
      street: { type: String, required: true },
      city: { type: String, required: true },
      zip: { type: String }
    })
end
```

#### Chain: `.inclusion(values)`

Asserts allowed values (inclusion validation):

```ruby
it do
  expect(described_class).to have_input(:status)
    .type(String)
    .inclusion(%w[pending active completed])
end

it do
  expect(described_class).to have_input(:priority)
    .type(Integer)
    .inclusion([1, 2, 3, 4, 5])
end
```

#### Chain: `.must(*must_names)`

Asserts custom validation methods:

```ruby
it do
  expect(described_class).to have_input(:invoice_numbers)
    .type(Array)
    .consists_of(String)
    .must(:be_6_characters)
end

it do
  expect(described_class).to have_input(:email)
    .type(String)
    .must(:be_valid_email, :not_disposable)
end
```

#### Chain: `.message(message)`

Asserts the validation error message for the previous chain. Can use string or RSpec matcher.

```ruby
it do
  expect(described_class).to have_input(:age)
    .type(Integer)
    .inclusion(18..120)
    .message("Age must be between 18 and 120")
end

it do
  expect(described_class).to have_input(:name)
    .type(String)
    .required
    .message(match(/required/i))
end
```

#### Chain: `.target(values, options = {})`

Asserts dynamic option targeting:

```ruby
it do
  expect(described_class).to have_input(:user_ids)
    .type(Array)
    .target([:sidekiq, :active_job])
end
```

**With custom option name:**

```ruby
it do
  expect(described_class).to have_input(:data)
    .target([:background], name: :job_options)
end
```

#### Chain: `.valid_with(attributes)` [DEPRECATED]

> **Note:** This method is deprecated and will be removed in a future version.

Tests input validation with a complete set of attributes:

```ruby
let(:attributes) { { email: "test@example.com", name: "John" } }

it do
  expect { perform }.to have_input(:email)
    .valid_with(attributes)
    .type(String)
    .required
end
```

**Combined example:**

```ruby
it do
  expect(described_class).to have_input(:invoice_numbers)
    .type(Array)
    .required
    .consists_of(String)
    .must(:be_6_characters)
    .message("Each invoice number must be 6 characters")
end
```

---

## Internal Matchers

### `have_service_internal(internal_name)` / `have_internal`

Tests service internal attribute configuration. Same API as input matchers except without `.required`, `.optional`, `.default`, and `.valid_with` chains.

**Available chains:**
- `.type(type)` / `.types(*types)`
- `.consists_of(*types)`
- `.schema(data = {})`
- `.inclusion(values)`
- `.must(*must_names)`
- `.message(message)`
- `.target(values, options = {})`

**Example:**

```ruby
RSpec.describe OrderProcessor, type: :service do
  it { expect(described_class).to have_internal(:calculated_total).type(BigDecimal) }

  it do
    expect(described_class).to have_internal(:line_items)
      .type(Array)
      .consists_of(Hash)
  end

  it do
    expect(described_class).to have_internal(:status)
      .type(Symbol)
      .inclusion(%i[pending processing completed])
  end
end
```

---

## Output Matchers

### `have_service_output(output_name)` / `have_output`

Tests service output values after execution.

**Basic usage:**

```ruby
it { expect(result).to have_output(:user_id) }
```

#### Chain: `.instance_of(class_or_name)`

Asserts output is instance of a specific class:

```ruby
it { expect(result).to have_output(:user).instance_of(User) }
it { expect(result).to have_output(:created_at).instance_of(Time) }
```

#### Chain: `.nested(*values)`

Navigates through nested method calls on the output:

```ruby
it { expect(result).to have_output(:user).nested(:profile, :avatar_url).contains("https://...") }
it { expect(result).to have_output(:order).nested(:items, :first, :name).contains("Product A") }
```

#### Chain: `.contains(value)`

Asserts the output value. Uses smart matching based on value type:

| Value Type | Matcher Used |
|------------|--------------|
| `Array` | `contain_exactly` |
| `Hash` | `match` (pattern) |
| `TrueClass`/`FalseClass` | `equal` |
| `NilClass` | `be_nil` |
| Other | `eq` |

**Examples:**

```ruby
# String comparison
it { expect(result).to have_output(:name).contains("John Doe") }

# Array comparison (order-independent)
it { expect(result).to have_output(:tags).contains(%w[ruby rails api]) }

# Hash pattern matching
it { expect(result).to have_output(:meta).contains({ status: "ok", count: 5 }) }

# Boolean comparison
it { expect(result).to have_output(:active?).contains(true) }

# Nil check
it { expect(result).to have_output(:deleted_at).contains(nil) }
```

**Predicate methods:**

```ruby
it { expect(result).to have_output(:valid?).contains(true) }
it { expect(result).to have_output(:user_name).contains("Alice") }
```

---

## Utilities

### FakeType Class

A sentinel class used for type validation testing.

**Location:** `lib/servactory/test_kit/fake_type.rb`

**Usage:**

Used internally by `ValidWithMatcher` to verify that type validation correctly rejects invalid types:

```ruby
# Internal usage example
prepared_attributes = attributes.merge(input_name => Servactory::TestKit::FakeType.new)
# This should trigger a type validation error
```

### Faker Utility

Generates fake values for different types. Used internally for validation testing.

**Location:** `lib/servactory/test_kit/utils/faker.rb`

**Method:**

```ruby
Servactory::TestKit::Utils::Faker.fetch_value_for(class_or_name, of: :string)
```

**Parameters:**
- `class_or_name` - The class or class name to generate a fake value for
- `of:` - Element type for collections (`:string` or `:integer`)

**Supported types:**

| Class | Fake Value |
|-------|------------|
| `Symbol` | `:fake` |
| `String` | `"fake"` |
| `Integer` | `123` |
| `Float` | `12.3` |
| `Range` | `1..3` |
| `TrueClass` | `true` |
| `FalseClass` | `false` |
| `NilClass` | `nil` |
| Other | Attempts `.new` or returns class |

**Collection types with `of:` parameter:**

| Class | When `of: :integer` | When `of: :string` (default) |
|-------|---------------------|------------------------------|
| `Array` | `[1, 2, 3]` | `["fake"]` |
| `Hash` | `{ fake: 1 }` | `{ fake: :yes }` |

---

## Common Testing Patterns

### Basic Service Test Structure

```ruby
RSpec.describe UserRegistrationService, type: :service do
  subject(:perform) { described_class.call!(**attributes) }

  let(:attributes) do
    {
      email: "user@example.com",
      password: "secure123",
      name: "John Doe"
    }
  end

  describe ".call!" do
    context "when inputs are valid" do
      it { expect(perform).to be_success_service }
      it { expect(perform).to have_output(:user).instance_of(User) }
      it { expect(perform).to have_output(:welcome_email_sent).contains(true) }
    end

    context "when email is invalid" do
      let(:attributes) { super().merge(email: "invalid") }

      it "returns validation failure" do
        expect { perform }.to raise_error(Servactory::Exceptions::Input)
      end
    end
  end
end
```

### Input Validation Testing

```ruby
RSpec.describe OrderService, type: :service do
  describe "inputs" do
    it { expect(described_class).to have_input(:user_id).type(Integer).required }
    it { expect(described_class).to have_input(:items).type(Array).required.consists_of(Hash) }
    it { expect(described_class).to have_input(:coupon_code).type(String).optional }
    it { expect(described_class).to have_input(:priority).type(Symbol).default(:normal) }
    it { expect(described_class).to have_input(:status).type(String).inclusion(%w[pending confirmed]) }
  end

  describe "internals" do
    it { expect(described_class).to have_internal(:total_amount).type(BigDecimal) }
    it { expect(described_class).to have_internal(:discount).type(BigDecimal) }
  end
end
```

### Output Verification

```ruby
RSpec.describe ReportGeneratorService, type: :service do
  subject(:result) { described_class.call!(params) }

  let(:params) { { start_date: Date.today - 30, end_date: Date.today } }

  it "returns report data" do
    expect(result).to be_success_service
      .with_outputs(
        report_id: be_a(String),
        generated_at: be_a(Time),
        row_count: be > 0
      )
  end

  it { expect(result).to have_output(:data).instance_of(Array) }
  it { expect(result).to have_output(:summary).nested(:total_sales).contains(be_a(Numeric)) }
end
```

### Failure Case Testing

```ruby
RSpec.describe PaymentService, type: :service do
  subject(:result) { described_class.call(amount: amount, card_token: token) }

  context "when payment is declined" do
    let(:amount) { 1000 }
    let(:token) { "invalid_token" }

    it "returns payment failure" do
      expect(result).to be_failure_service
        .with(Servactory::Exceptions::Failure)
        .type(:payment_declined)
        .message("Card was declined")
        .meta({ decline_code: "insufficient_funds" })
    end
  end

  context "when amount is zero" do
    let(:amount) { 0 }
    let(:token) { "valid_token" }

    it "returns validation failure" do
      expect(result).to be_failure_service
        .type(:validation_error)
        .message("Amount must be greater than zero")
    end
  end
end
```

### Service Mocking in Integration Tests

```ruby
RSpec.describe CheckoutController, type: :controller do
  describe "POST #create" do
    before do
      allow_service_as_success!(PaymentService) do
        { transaction_id: "txn_123", status: :completed }
      end

      allow_service_as_success!(InventoryService) do
        { reserved: true, reservation_id: "res_456" }
      end
    end

    it "completes checkout successfully" do
      post :create, params: { order_id: order.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "when payment fails" do
    before do
      allow_service_as_failure!(PaymentService) do
        Servactory::Exceptions::Failure.new(
          type: :payment_declined,
          message: "Insufficient funds"
        )
      end
    end

    it "handles payment failure" do
      post :create, params: { order_id: order.id }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
```

### Testing with Mocked Results

```ruby
RSpec.describe OrderPresenter do
  subject(:presenter) { described_class.new(service_result) }

  describe "#display_status" do
    context "when order is successful" do
      let(:service_result) do
        Servactory::TestKit::Result.as_success(
          order_id: "ORD-123",
          status: :completed,
          total: 99.99
        )
      end

      it { expect(presenter.display_status).to eq("Order ORD-123 completed") }
    end

    context "when order failed" do
      let(:service_result) do
        Servactory::TestKit::Result.as_failure(
          exception: Servactory::Exceptions::Failure.new(
            type: :inventory_error,
            message: "Out of stock"
          )
        )
      end

      it { expect(presenter.display_status).to eq("Order failed: Out of stock") }
    end
  end
end
```

---

## License

This test kit is part of the Servactory gem and is released under the same license.
