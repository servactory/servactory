---
title: Приступая к работе
description: Описание и примеры использования
slug: getting-started
sidebar_label: Приступая к работе
sidebar_position: 2
pagination_label: Приступая к работе
---

# Начиная

## Соглашения

- Все сервисы являются подклассами `Servactory::Base` и располагаются в директории `app/services`. Общепринятой практикой является создание и наследование от `ApplicationService::Base`, который является подклассом `Servactory::Base`.
- Называйте сервисы по тому что они делают, а не по тому что они принимают. Используйте глаголы в именах. Например, назовите сервис `UsersService::Create` вместо `UsersService::Creation`.

## Установка

Добавьте это в файл `Gemfile`:

```ruby
gem "servactory"
```

Затем выполните:

```shell
bundle install
```

## Подготовка

Для начала рекомендуется подготовить базовый класс для дальнейшего наследования.

### ApplicationService::Errors

```ruby title="app/services/application_service/errors.rb"
module ApplicationService
  module Errors
    class InputError < Servactory::Errors::InputError; end
    class OutputError < Servactory::Errors::OutputError; end
    class InternalError < Servactory::Errors::InternalError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
```

### ApplicationService::Base

```ruby title="app/services/application_service/base.rb"
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
