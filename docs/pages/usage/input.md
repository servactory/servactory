---
title: Service input arguments
slug: /usage/input
sidebar_label: Input
sidebar_position: 4
pagination_label: Service input arguments
---

# Input

## Options

### Option `type`

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

Using this option will mean that the input argument is an array, each element of which has the specified type.

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

Sometimes there are cases that require the implementation of a specific input attribute check. In such cases `must` can help.

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
