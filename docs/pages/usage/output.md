---
title: Service output attributes
slug: /usage/output
sidebar_label: Output
sidebar_position: 5
pagination_label: Output
---

# Output

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
