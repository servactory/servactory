---
title: Выходные атрибуты сервиса
description: Описание и примеры использования выходных атрибутов сервиса
slug: output
sidebar_label: Output
sidebar_position: 2
pagination_label: Выходные атрибуты сервиса
---

# Output

Все атрибуты, которые должен возвращать сервис в `Result` должны быть описаны через метод `output`.

## Опции

### Опция `type`

Эта опция является валидацией.
Будет проверяться чтобы переданное как output значение соответствовало указанному типу (классу).
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
