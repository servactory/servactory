---
title: Service internal attributes
description: Description and examples of using internal attributes of service
slug: internal
sidebar_label: Internal
sidebar_position: 3
pagination_label: Service internal attributes
---

# Internal

Internal private attributes can be defined through the `internal` method.

## Usage

The assignment and use of internal service arguments is done through the `internals=`/`internals` methods or their `int=`/`int` aliases.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name, type: String

  # ...

  def something
    internals.full_name = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
    # or
    # int.full_name = [inp.first_name, inp.middle_name, inp.last_name].compact.join(" ")
  end
end
```

## Options

### Option `type`

This option is validation.
It will check that the value set to `internal` corresponds to the specified type (class).
In this case `is_a?` method is used.

```ruby
class NotificationService::Create < ApplicationService::Base
  input :user, type: User

  # highlight-next-line
  internal :inviter, type: User
  
  output :notification, type: Notification

  make :assign_inviter
  make :create_notification!
  
  private
  
  def assign_inviter
    # highlight-next-line
    internals.inviter = inputs.user.inviter
  end
  
  def create_notification!
    outputs.notification = Notification.create!(user: inputs.user, inviter: internals.inviter)
  end
end
```
