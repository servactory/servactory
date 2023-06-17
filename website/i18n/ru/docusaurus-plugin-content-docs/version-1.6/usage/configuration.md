---
title: Конфигурация
description: Описание и примеры конфигурирования сервисов
slug: configuration
sidebar_label: Конфигурация
sidebar_position: 1
pagination_label: Конфигурация
---

# Конфигурация

Сервисы конфигурируются через `configuration` метод, который может быть расположен, например, в базовом классе.

## Примеры конфигурации

### Ошибки

```ruby {4-6,8} title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      input_error_class ApplicationService::Errors::InputError
      output_error_class ApplicationService::Errors::OutputError
      internal_error_class ApplicationService::Errors::InternalError

      failure_class ApplicationService::Errors::Failure
    end
  end
end
```

### Хелперы для `input`

Пользовательские хелперы для `input` основываются на опциях `must` и `prepare`.

#### Пример с `must`

```ruby {4-20} title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
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

#### Пример с `prepare`

```ruby {4-13} title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      input_option_helpers(
        [
          Servactory::Inputs::OptionHelper.new(
            name: :to_money,
            equivalent: {
              prepare: ->(value:) { Money.new(cents: value, currency: :USD) }
            }
          )
        ]
      )
    end
  end
end
```

### Сокращения для методов

```ruby {4} title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      method_shortcuts %i[assign perform]
    end
  end
end
```
