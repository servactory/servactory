---
title: Service output attributes
description: Description and examples of using output attributes of service
slug: output
sidebar_label: Output
sidebar_position: 2
pagination_label: Service output attributes
---

# Output

All attributes the service must return in `Result` should be described through the `output` method.

## Options

### Option `type`

This option is validation.
It will check that the value set to `output` corresponds to the specified type (class).
In this case `is_a?` method is used.

```ruby
class NotificationService::Create < ApplicationService::Base
  input :user, type: User

  # highlight-next-line
  output :notification, type: Notification

  make :create_notification!
  
  private
  
  def create_notification!
    # highlight-next-line
    self.notification = Notification.create!(user: inputs.user)
  end
end
```
