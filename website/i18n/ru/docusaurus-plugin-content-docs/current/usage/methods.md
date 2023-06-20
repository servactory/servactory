---
title: Вызов методов сервиса
description: Описание и примеры использования вызова методов сервиса
slug: methods
sidebar_label: Методы
sidebar_position: 4
pagination_label: Вызов методов сервиса
---

# Методы

Вызов методов сервиса происходит только при помощи метода `make`.

## Примеры

### Минимальный

```ruby
make :something

def something
  # ...
end
```

### Несколько методов

```ruby
# highlight-next-line
make :assign_api_model
# highlight-next-line
make :perform_api_request
# highlight-next-line
make :process_result

# highlight-next-line
def assign_api_model
  internals.api_model = APIModel.new
end

# highlight-next-line
def perform_api_request
  internals.response = APIClient.resource.create(internals.api_model)
end

# highlight-next-line
def process_result
  ARModel.create!(internals.response)
end
```

## Опции

### Опция `if`

Перед вызовом метода будет проверено условие, описанное в `if`.

```ruby
make :something,
     # highlight-next-line
     if: ->(**) { Settings.something.enabled }

def something
  # ...
end
```

### Опция `unless`

Противоположность опции `if`.

```ruby
make :something,
     # highlight-next-line
     unless: ->(**) { Settings.something.disabled }

def something
  # ...
end
```

### Опция `position`

Все методы имеют позицию.
Если какой-то метод нужно вызвать не в тот момент, в который он был добавлен через `make`, то можно воспользоваться опцией `position`.
Может быть полезно при наследовании сервисов.

```ruby
class SomeApiService::Base < ApplicationService::Base
  make :api_request!,
       # highlight-next-line
       position: 2

  # ...
end

class SomeApiService::Posts::Create < SomeApiService::Base
  input :post_name, type: String

  # ...
  
  make :validate!,
       # highlight-next-line
       position: 1

  private

  def validate!
    # ...
  end

  # ...
end
```

## Группа из нескольких методов

Собрать в одну группу выполнение несколько методов можно при помощи метода `stage`.

:::info

Использование опции `position` для `make` будет сортировать только внутри `stage`.

:::

```ruby
stage do
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Опция `only_if`

Перед вызовом методов внутри `stage` будет проверено условие, описанное в `only_if`.

```ruby {2}
stage do
  only_if ->(context:) { Settings.features.preview.enabled }
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Опция `wrap_in`

Группу методов, находящийхся в `stage` можно обернуть во что-то.
Например, это может быть `ActiveRecord::Base.transaction` от Rails.

```ruby {2}
stage do
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods.call } }
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Опция `rollback`

Если в одном из методов в группе или в `wrap_in` возникло исключение, то это можно обработать при помощи метода `rollback`.

```ruby {3,12}
stage do
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods.call } }
  rollback :clear_data_and_fail!
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end

# ...

def clear_data_and_fail!(e)
  # ...

  fail!(message: "Failed to create data: #{e.message}")
end
```

## Алиасы для `make`

Через конфигурацию `aliases_for_make` можно добавить алиас для метода `make`.

```ruby {2,5}
configuration do
  aliases_for_make %i[execute]
end

execute :something

def something
  # ...
end
```

## Сокращения для `make`

Через конфигурацию `shortcuts_for_make` можно добавить часто используемые слова, которые используются в виде префиксов в именах методов.
Имена самих методов короче не станут, но это позволит сократить строки с применением метода `make` и улучшить читаемость кода сервиса, сделав его выразительнее.

```ruby {2,5,6,9,13}
configuration do
  shortcuts_for_make %i[assign perform]
end

assign :api_model
perform :api_request
make :process_result

def assign_api_model
  internals.api_model = APIModel.new
end

def perform_api_request
  internals.response = APIClient.resource.create(internals.api_model)
end

def process_result
  ARModel.create!(internals.response)
end
```
