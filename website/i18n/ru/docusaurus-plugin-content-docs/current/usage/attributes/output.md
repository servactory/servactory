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

## Использование

Назначение и использование выходящих аргументов сервиса осуществляется через методы `outputs=`/`outputs` или их алиасы `out=`/`out`.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name, type: String
  input :middle_name, type: String
  input :last_name, type: String

  output :full_name, type: String

  # ...

  def something
    outputs.full_name = [inputs.first_name, inputs.middle_name, inputs.last_name].compact.join(" ")
    # или
    # out.full_name = [inp.first_name, inp.middle_name, inp.last_name].compact.join(" ")
  end
end
```

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
    outputs.notification = Notification.create!(user: inputs.user)
  end
end
```
