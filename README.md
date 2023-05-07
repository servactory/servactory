# Servactory

A set of tools for building reliable services of any complexity.

[![Gem version](https://img.shields.io/gem/v/servactory?logo=rubygems&logoColor=fff)](https://rubygems.org/gems/servactory)

## Contents

- [Requirements](#requirements)
- [Getting started](#getting-started)
  - [Conventions](#conventions)
  - [Installation](#installation)
  - [Preparation](#preparation)
- [Usage](#usage)
  - [Minimal example](#minimal-example)
  - [Input attributes](#input-attributes)
    - [Isolated usage](#isolated-usage)
    - [As an internal argument](#isolated-usage)
    - [Optional inputs](#optional-inputs)
    - [An array of specific values](#an-array-of-specific-values)
    - [Inclusion](#inclusion)
    - [Must](#must)
  - [Output attributes](#output-attributes)
  - [Internal attributes](#internal-attributes)
  - [Result](#result)

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

We recommend that you first prepare the following files in your project.

#### ApplicationService::Errors

```ruby
# app/services/application_service/errors.rb

module ApplicationService
  module Errors
    class InputArgumentError < Servactory::Errors::InputArgumentError; end
    class OutputArgumentError < Servactory::Errors::OutputArgumentError; end
    class InternalArgumentError < Servactory::Errors::InternalArgumentError; end

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
      input_argument_error_class ApplicationService::Errors::InputArgumentError
      output_argument_error_class ApplicationService::Errors::OutputArgumentError
      internal_argument_error_class ApplicationService::Errors::InternalArgumentError

      failure_class ApplicationService::Errors::Failure
    end
  end
end
```

## Usage

### Minimal example

```ruby
class MinimalService < ApplicationService::Base
  stage { make :something }
  
  private
  
  def something
    # ...
  end
end
```

[More examples](https://github.com/afuno/servactory/tree/main/examples/usual)

### Input attributes

#### Isolated usage

With this approach, all input attributes are available only from `inputs`. This is default behaviour.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user, type: User
  
  stage { make :accept! }
  
  private
  
  def accept!
    inputs.user.accept!
  end
end
```

#### As an internal argument

With this approach, all input attributes are available from `inputs` as well as directly from the context.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user, type: User, internal: true
  
  stage { make :accept! }
  
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
  input :first_name, type: String, internal: true
  input :middle_name, type: String, required: false
  input :last_name, type: String, internal: true

  # ...
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
  
  stage { make :create_notification! }
  
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
  
  stage do
    make :assign_inviter
    make :create_notification!
  end
  
  private
  
  def assign_inviter
    self.inviter = user.inviter
  end
  
  def create_notification!
    self.notification = Notification.create!(user: inputs.user, inviter:)
  end
end
```

### Result

All services have the result of their work. For example, in case of success this call:

```ruby
service_result = NotificationService::Create.call!(user: User.first)
```

Will return this:

```ruby
#<Servactory::Result:0x0000000112c00748 @notification=...>
```

And then you can work with this result, for example, in this way:

```ruby
Notification::SendJob.perform_later(service_result.notification.id)
```
