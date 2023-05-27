---
title: Service output attributes
slug: /usage/output
sidebar_label: Output
sidebar_position: 5
pagination_label: Service output attributes
---

# Output

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
