---
title: Входные аргументы сервиса
slug: /usage/input
sidebar_label: Input
sidebar_position: 4
pagination_label: Входные аргументы сервиса
---

# Input

## Опции

### Опция `type`

Эта опция является валидацией.
Будет проверяться чтобы переданное в `input` значение соответствовало указанному типу (классу).
Используется метод `is_a?`.

Всегда обязательно для указания. Может содержать один или несколько классов.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        # highlight-next-line
        type: User

  # ...
end
```

```ruby
class ToggleService < ApplicationService::Base
  input :flag,
        # highlight-next-line
        type: [TrueClass, FalseClass]

  # ...
end
```

### Опция `required`

Эта опция является валидацией.
Будет проверяться чтобы переданное в `input` значение не было пустым.
Используется метод `present?` чтобы проверить, является ли значение не `nil` или не пустой строкой.

По умолчанию `required` имеет значение `true`.

```ruby
class UsersService::Create < ApplicationService::Base
  input :first_name,
        type: String
  
  input :middle_name,
        type: String,
        # highlight-next-line
        required: false
  
  input :last_name,
        type: String

  # ...
end
```

### Опция `internal`

Эта опция не является валидацией.
Она используется для подготовки `input` аргумента.
Для `input` аргумента будет создана копия в виде internal-атрибута.

По умолчанию `internal` имеет значение `false`.

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        type: User

  make :accept!
  
  private
  
  def accept!
    # highlight-next-line
    inputs.user.accept!
  end
end
```

```ruby
class UsersService::Accept < ApplicationService::Base
  input :user,
        type: User,
        # highlight-next-line
        internal: true

  make :accept!
  
  private
  
  def accept!
    # highlight-next-line
    user.accept!
  end
end
```

### Опция `as`

Эта опция не является валидацией.
Она используется для подготовки `input` аргумента.
Для `input` аргумента будет назначено указанное через `:as` имя.

```ruby
class NotificationService::Create < ApplicationService::Base
  input :customer,
        # highlight-next-line
        as: :user,
        type: User

  output :notification,
         type: Notification

  make :create_notification!

  private

  def create_notification!
    # highlight-next-line
    self.notification = Notification.create!(user: inputs.user)
  end
end
```

### Опция `array`

Эта опция является валидацией.
Будет проверяться чтобы переданное в `input` значение было массивом и соответствовало указанному типу (классу).
Используется метод `is_a?`. Работает совместно с опциями [`type`](#опция-type) и [`required`](#опция-required).

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        type: String,
        # highlight-next-line
        array: true

  # ...
end
```

### Опция `inclusion`

Эта опция является валидацией.
Будет проверяться чтобы переданное в `input` значение находилось в указанном массиве.
Используется метод `include?`.

```ruby
class EventService::Send < ApplicationService::Base
  input :event_name,
        type: String,
        # highlight-next-line
        inclusion: %w[created rejected approved]

  # ...
end
```

### Опция `must`

Эта опция является валидацией.
Но в отличии от других валидационных опций, `:must` позволяет описывать валидацию внутри себя.

```ruby
class PymentsService::Send < ApplicationService::Base
  input :invoice_numbers,
        type: String,
        array: true,
        # highlight-next-line
        must: {
          # highlight-next-line
          be_6_characters: {
            # highlight-next-line
            is: ->(value:) { value.all? { |id| id.size == 6 } }
            # highlight-next-line
          }
          # highlight-next-line
        }

  # ...
end
```
