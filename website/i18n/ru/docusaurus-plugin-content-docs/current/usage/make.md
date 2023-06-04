---
title: Вызов методов сервиса
slug: /usage/make
sidebar_label: Make
sidebar_position: 7
pagination_label: Вызов методов сервиса
---

# Make

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
  self.api_model = APIModel.new
end

# highlight-next-line
def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

# highlight-next-line
def process_result
  ARModel.create!(response)
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

class SomeApiService::Posts::Create < ApplicationService::Base
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

```ruby
stage do
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Оборачивание

Группу методов, находящийхся в `stage` можно обернуть во что-то.
Например, это может быть `ActiveRecord::Base.transaction` от Rails.

```ruby
stage do
  # highlight-next-line
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods } }
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Откат

Если в одном из методов в группе или в `wrap_in` возникло исключение, то это можно обработать при помощи метода `rollback`.

```ruby
stage do
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods } }
  # highlight-next-line
  rollback :clear_data_and_fail!
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end

# ...

# highlight-next-line
def clear_data_and_fail!(e)
  post&.destroy!
  blog&.destroy!
  user&.destroy!

  fail!(message: "Failed to create data: #{e.message}")
end
```

## Сокращение для методов

Через конфигурацию `method_shortcuts` можно добавить часто используемые слова, которые используются в виде префиксов в именах методов.
Имена самих методов короче не станут, но это позволит сократить строки с применением метода `make` и улучшить читаемость кода сервиса, сделав его выразительнее.

```ruby
configuration do
  # highlight-next-line
  method_shortcuts %i[assign perform]
end

# highlight-next-line
assign :api_model
# highlight-next-line
perform :api_request
make :process_result

# highlight-next-line
def assign_api_model
  self.api_model = APIModel.new
end

# highlight-next-line
def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

def process_result
  ARModel.create!(response)
end
```
