---
title: Internal
slug: /usage/internal
sidebar_position: 6
---

# Internal

```ruby
class NotificationService::Create < ApplicationService::Base
  input :user, type: User

  internal :inviter, type: User
  
  output :notification, type: Notification

  make :assign_inviter
  make :create_notification!
  
  private
  
  def assign_inviter
    self.inviter = user.inviter
  end
  
  def create_notification!
    self.notification = Notification.create!(user: inputs.user, inviter:)
  end
end
```
