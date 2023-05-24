# Servactory

A set of tools for building reliable services of any complexity.

[![Gem version](https://img.shields.io/gem/v/servactory?logo=rubygems&logoColor=fff)](https://rubygems.org/gems/servactory)
[![Release Date](https://img.shields.io/github/release-date/afuno/servactory)](https://github.com/afuno/servactory/releases)

## Contents

- [Requirements](#requirements)
- [Getting started](#getting-started)
  - [Conventions](#conventions)
  - [Installation](#installation)
  - [Preparation](#preparation)
- [Usage](#usage)
  - [Minimal example](#minimal-example)
  - [Call](#call)
  - [Result](#result)
  - [Input attributes](#input-attributes)
    - [Isolated usage](#isolated-usage)
    - [As an internal attribute](#isolated-usage)
    - [Optional inputs](#optional-inputs)
    - [As (internal name)](#as-internal-name)
    - [An array of specific values](#an-array-of-specific-values)
    - [Inclusion](#inclusion)
    - [Must](#must)
  - [Output attributes](#output-attributes)
  - [Internal attributes](#internal-attributes)
  - [Make](#make)
  - [Failures](#failures)
- [I18n](#i18n)
- [Testing](#testing)
- [Thanks](#thanks)
- [Contributing](#contributing)

## Requirements

- Ruby >= 2.7

## Getting started

### Conventions

- Services are subclasses of `Servactory::Base` and are located in the `app/services` directory. It is common practice to create and inherit from `ApplicationService::Base`, which is a subclass of `Servactory::Base`.
- Name services by what they do, not by what they accept. Try to use verbs in names. For example, `UsersService::Create` instead of `UsersService::Creation`.

### Installation

Add this to `Gemfile`:

```ruby
gem "servactory"
```

And execute:

```shell
bundle install
```

### Preparation

As a first step, it is recommended to prepare the base class for further inheritance.

#### ApplicationService::Errors

```ruby
# app/services/application_service/errors.rb

module ApplicationService
  module Errors
    class InputError < Servactory::Errors::InputError; end
    class OutputError < Servactory::Errors::OutputError; end
    class InternalError < Servactory::Errors::InternalError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
```

#### ApplicationService::Base

```ruby
# app/services/application_service/base.rb

module ApplicationService
  class Base < Servactory::Base
    configuration do
      input_error_class ApplicationService::Errors::InputError
      output_error_class ApplicationService::Errors::OutputError
      internal_error_class ApplicationService::Errors::InternalError

      failure_class ApplicationService::Errors::Failure
    end
  end
end
```

## Usage

### Minimal example

```ruby
class MinimalService < ApplicationService::Base
  make :call
  
  private
  
  def call
    # ...
  end
end
```

[More examples](https://github.com/afuno/servactory/tree/main/examples/usual)

### Call

Services can only be called via `.call` and `.call!` methods.

The `.call` method will only fail if it catches an exception in the input attributes.
Internal and output attributes, as well as methods for failures - all this will be collected in the result.

The `.call!` method will fail if it catches any exception.

#### Via .call

```ruby
UsersService::Accept.call(user: User.first)
```

#### Via .call!

```ruby
UsersService::Accept.call!(user: User.first)
```

### Result

All services have the result of their work. For example, in case of success this call:

```ruby
service_result = UsersService::Accept.call!(user: User.first)
```

Will return this:

```ruby
#<Servactory::Result:0x0000000107ad9e88 @user="...">
```

And then you can work with this result, for example, in this way:

```ruby
Notification::SendJob.perform_later(service_result.user.id)
```

### Input attributes

#### Isolated usage

With this approach, all input attributes are available only from `inputs`. This is default behaviour.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user, type: User

  make :accept!
  
  private
  
  def accept!
    inputs.user.accept!
  end
end
```

#### As an internal attribute

With this approach, all input attributes are available from `inputs` as well as directly from the context.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user, type: User, internal: true

  make :accept!
  
  private
  
  def accept!
    user.accept!
  end
end
```

#### Optional inputs

By default, all inputs are required. To make an input optional, specify `false` in the `required` option.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name, type: String
  input :middle_name, type: String, required: false
  input :last_name, type: String

  # ...
end
```

#### As (internal name)

This option changes the name of the input within the service.

```ruby
class NotificationService::Create < ApplicationService::Base
  input :customer, as: :user, type: User

  output :notification, type: Notification

  make :create_notification!

  private

  def create_notification!
    self.notification = Notification.create!(user: inputs.user)
  end
end
```

#### An array of specific values

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers, type: String, array: true

  # ...
end
```

#### Inclusion

```ruby
class EventService::Send < ApplicationService::Base
  input :event_name, type: String, inclusion: %w[created rejected approved]

  # ...
end
```

#### Must

Sometimes there are cases that require the implementation of a specific input attribute check. In such cases `must` can help.

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        type: String,
        array: true,
        must: {
          be_6_characters: {
            is: ->(value:) { value.all? { |id| id.size == 6 } }
          }
        }

  # ...
end
```

### Output attributes

```ruby
class NotificationService::Create < ApplicationService::Base
  input :user, type: User
  
  output :notification, type: Notification

  make :create_notification!
  
  private
  
  def create_notification!
    self.notification = Notification.create!(user: inputs.user)
  end
end
```

### Internal attributes

```ruby
class NotificationService::Create < ApplicationService::Base
  input :user, type: User

  internal :inviter, type: User
  
  output :notification, type: Notification

  make :assign_inviter
  make :create_notification!
  
  private
  
  def assign_inviter
    self.inviter = user.inviter
  end
  
  def create_notification!
    self.notification = Notification.create!(user: inputs.user, inviter:)
  end
end
```

### Make

#### Minimal example

```ruby
make :something

def something
  # ...
end
```

#### Condition

```ruby
make :something, if: -> { Settings.something.enabled }

def something
  # ...
end
```

#### Several

```ruby
make :assign_api_model
make :perform_api_request
make :process_result

def assign_api_model
  self.api_model = APIModel.new
end

def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

def process_result
  ARModel.create!(response)
end
```

#### Inheritance

Service inheritance is also supported.

### Failures

The methods that are used in `make` may fail. In order to more informatively provide information about this outside the service, the following methods were prepared.

#### Fail

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  fail!(message: "Invalid invoice number")
end
```

#### Fail for input

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  fail_input!(:invoice_number, message: "Invalid invoice number")
end
```

#### Metadata

```ruby
fail!(
  message: "Invalid invoice number", 
  meta: { 
    invoice_number: inputs.invoice_number 
  }
)
```

```ruby
exception.detailed_message  # => Invalid invoice number (ApplicationService::Errors::Failure)
exception.message           # => Invalid invoice number
exception.type              # => :fail
exception.meta              # => {:invoice_number=>"BB-7650AE"}
```

## I18n

All texts are stored in the localization file. All texts can be changed or supplemented by new locales.

[See en.yml file](https://github.com/afuno/servactory/tree/main/config/locales/en.yml)

## Testing

Testing Servactory services is the same as testing regular Ruby classes.

## Thanks

Thanks to [@sunny](https://github.com/sunny) for [Service Actor](https://github.com/sunny/actor).

## Contributing

1. Fork it (https://github.com/afuno/servactory/fork);
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am "Add some feature"`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create a new Pull Request.
