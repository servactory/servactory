---
title: Конфигурация
description: Описание и примеры конфигурирования сервисов
slug: /usage/configuration
sidebar_label: Конфигурация
sidebar_position: 1
pagination_label: Конфигурация
---

# Конфигурация

Сервисы конфигурируются через `configuration` метод, который может быть расположен, например, в базовом классе.

## Примеры конфигурации

### Ошибки

```ruby title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      # highlight-next-line
      input_error_class ApplicationService::Errors::InputError
      # highlight-next-line
      output_error_class ApplicationService::Errors::OutputError
      # highlight-next-line
      internal_error_class ApplicationService::Errors::InternalError

      # highlight-next-line
      failure_class ApplicationService::Errors::Failure
    end
  end
end
```

### Хелперы для `input`

Пользовательские хелперы для `input` следует основывать на опции `must`.

```ruby title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      # highlight-next-line
      input_option_helpers(
        [
          Servactory::Inputs::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: ->(value:) { value.all? { |id| id.size == 6 } },
                  message: lambda do |input:, **|
                    "Wrong IDs in `#{input.name}`"
                  end
                }
              }
            }
          )
        ]
      )
    end
  end
end
```

### Сокращения для методов

```ruby title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      # highlight-next-line
      method_shortcuts %i[assign perform]
    end
  end
end
```
