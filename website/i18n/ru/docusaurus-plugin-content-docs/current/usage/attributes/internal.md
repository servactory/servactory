---
title: Внутренние атрибуты сервиса
description: Описание и примеры использования внутренних атрибутов сервиса
slug: internal
sidebar_label: Internal
sidebar_position: 3
pagination_label: Внутренние атрибуты сервиса
---

# Internal

Внутренние приватные атрибуты можно определять через метод `internal`.

## Опции

### Опция `type`

Эта опция является валидацией.
Будет проверяться чтобы переданное как internal значение соответствовало указанному типу (классу).
Используется метод `is_a?`.

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
