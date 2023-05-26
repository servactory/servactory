---
title: Output
slug: /usage/output
sidebar_position: 5
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
