---
title: Input
slug: /usage/input
sidebar_label: Input
sidebar_position: 4
pagination_label: Input
---

# Input

## Options

### Option `type`

Always required to specify. May contain one or more classes.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user, type: User

  # ...
end
```

```ruby
class ToggleService < ApplicationService::Base
  input :flag, type: [TrueClass, FalseClass]

  # ...
end
```

### Option `required`

By default, `required` is set to `true`.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name, type: String
  input :middle_name, type: String, required: false
  input :last_name, type: String

  # ...
end
```

### Option `internal`

By default, `internal` is set to `false`.

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

### Option `as`

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

### Option `array`

Using this option will mean that the input argument is an array, each element of which has the specified type.

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers, type: String, array: true

  # ...
end
```

### Option `inclusion`

```ruby
class EventService::Send < ApplicationService::Base
  input :event_name, type: String, inclusion: %w[created rejected approved]

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
        must: {
          be_6_characters: {
            is: ->(value:) { value.all? { |id| id.size == 6 } }
          }
        }

  # ...
end
```
