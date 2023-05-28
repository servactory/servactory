---
title: Выходные атрибута сервиса
slug: /usage/output
sidebar_label: Output
sidebar_position: 5
pagination_label: Выходные атрибута сервиса
---

# Output

Все атрибуты, которые должен возвращать сервис в `Result` должны быть описаны через `output` метод.

## Опции

### Опция `type`

Эта опция является валидацией.
Будет проверяться чтобы переданное в `output` значение соответствовало указанному типу (классу).
Используется метод `is_a?`.

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
