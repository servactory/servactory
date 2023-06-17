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
    self.inviter = user.inviter
  end
  
  def create_notification!
    self.notification = Notification.create!(user: inputs.user, inviter:)
  end
end
```
