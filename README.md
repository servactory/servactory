# Servactory

A set of tools for building reliable services of any complexity.

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
class SendService < ApplicationService::Base
  stage { make :something }
  
  private
  
  def something
    # ...
  end
end
```

### Input attributes

#### Isolated usage

With this approach, all input attributes are available only from `inputs`.

```ruby
class UserService::Accept < ApplicationService::Base
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
class UserService::Accept < ApplicationService::Base
  input :user, type: User, internal: true
  
  stage { make :accept! }
  
  private
  
  def accept!
    user.accept!
  end
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
