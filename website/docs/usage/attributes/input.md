---
title: Service input arguments
description: Description and examples of using input arguments of service
slug: input
sidebar_label: Input
sidebar_position: 1
pagination_label: Service input arguments
---

# Input

All arguments that service must expect should be described through `input` method.
If the service receives an argument that hasn't been described through input method, it will return an error.

## Options

### Option `type`

This option is validation.
It will check if the value set to `input` corresponds to the specified type (class).
The `is_a?` method is used.

Always required to specify. May contain one or more classes.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        # highlight-next-line
        type: User

  # ...
end
```

```ruby
class ToggleService < ApplicationService::Base
  input :flag,
        # highlight-next-line
        type: [TrueClass, FalseClass]

  # ...
end
```

### Option `required`

This option is validation.
Checks that the value set to `input` is not empty.
The `present?` method is used to check if the value is not `nil` or an empty string.

By default, `required` is set to `true`.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name,
        type: String
  
  input :middle_name,
        type: String,
        # highlight-next-line
        required: false
  
  input :last_name,
        type: String

  # ...
end
```

### Option `internal`

This option is not validation.
Used to prepare an input argument.
For the input argument, a copy will be created as an internal attribute.

By default, `internal` is set to `false`.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        type: User

  make :accept!
  
  private
  
  def accept!
    # highlight-next-line
    inputs.user.accept!
  end
end
```

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        type: User,
        # highlight-next-line
        internal: true

  make :accept!
  
  private
  
  def accept!
    # highlight-next-line
    user.accept!
  end
end
```

### Option `as`

This option is not validation.
Used to prepare the input argument.
This option changes the name of the input within the service.

```ruby
class NotificationService::Create < ApplicationService::Base
  input :customer,
        # highlight-next-line
        as: :user,
        type: User

  output :notification,
         type: Notification

  make :create_notification!

  private

  def create_notification!
    # highlight-next-line
    self.notification = Notification.create!(user: inputs.user)
  end
end
```

### Option `array`

This option is validation.
It will check if the value set to `input` is an array and corresponds to the specified type (class).
The `is_a?` method is used. Works together with options [`type`](#option-type) and [`required`](#option-required).

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        type: String,
        # highlight-next-line
        array: true

  # ...
end
```

### Option `inclusion`

This option is validation.
Checks that the value set in `input` is in the specified array.
The `include?` method is used.

```ruby
class EventService::Send < ApplicationService::Base
  input :event_name,
        type: String,
        # highlight-next-line
        inclusion: %w[created rejected approved]

  # ...
end
```

### Option `must`

This option is validation.
Unlike other validation options, `must` allows to describe the validation internally.

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        type: String,
        array: true,
        # highlight-next-line
        must: {
          # highlight-next-line
          be_6_characters: {
            # highlight-next-line
            is: ->(value:) { value.all? { |id| id.size == 6 } }
            # highlight-next-line
          }
          # highlight-next-line
        }

  # ...
end
```

### Option `prepare`

This option is not validation.
Used to prepare the value of the input argument.

:::caution

Use the `prepare` option carefully and only for simple actions.

:::

```ruby
class PymentsService::Send < ApplicationService::Base
  input :amount_cents,
        as: :amount,
        type: Integer,
        # highlight-next-line
        prepare: ->(value:) { Money.new(cents: value, currency: :USD) }

  # then `inputs.balance` is used in the service

  # ...
end
```

## Helpers

### Helper `optional`

This helper is equivalent to `required: false`.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name,
        type: String

  input :middle_name,
        # highlight-next-line
        :optional,
        type: String

  input :last_name,
        type: String

  # ...
end
```

### Helper `internal`

This helper is equivalent to `internal: true`.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        # highlight-next-line
        :internal,
        type: User

  # ...
end
```

### Helper `as_array`

This helper is equivalent to `array: true`.

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        # highlight-next-line
        :as_array,
        type: String

  # ...
end
```

### Custom

It is possible to add custom helpers.
It is based on the `must` and `prepare` options.

Adding is done via the `input_option_helpers` method in `configuration`.

[Configuration example](../configuration.md#helpers-for-input)

#### Example with `must`

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        # highlight-next-line
        :must_be_6_characters,
        type: String,
        array: true

  # ...
end
```

#### Example with `prepare`

```ruby
class PymentsService::Send < ApplicationService::Base
  input :amount_cents,
        # highlight-next-line
        :to_money,
        as: :amount,
        type: Integer

  # ...
end
```

## Advanced mode

Advanced mode provides more detailed work with the option.

### Option `required`

```ruby
input :first_name,
      type: String,
      required: {
        is: true,
        message: "Input `first_name` is required"
      }
```

```ruby
input :first_name,
      type: String,
      required: {
        message: lambda do |service_class_name:, input:, value:|
          "Input `first_name` is required"
        end
      }
```

### Option `inclusion`

```ruby
input :event_name,
      type: String,
      inclusion: {
        in: %w[created rejected approved]
      }
```

```ruby
input :event_name,
      type: String,
      inclusion: {
        in: %w[created rejected approved],
        message: lambda do |service_class_name:, input:, value:|
          value.present? ? "Incorrect `event_name` specified: `#{value}`" : "Event name not specified"
        end
      }
```

### Option `must`

:::note

The `must` option can work only in advanced mode.

:::

```ruby
input :invoice_numbers,
      type: String,
      array: true,
      must: {
        be_6_characters: {
          is: ->(value:) { value.all? { |id| id.size == 6 } }
        }
      }
```

```ruby
input :invoice_numbers,
      type: String,
      array: true,
      must: {
        be_6_characters: {
          is: ->(value:) { value.all? { |id| id.size == 6 } },
          message: lambda do |service_class_name:, input:, value:, code:|
            "Wrong IDs in `#{input.name}`"
          end
        }
      }
```
