---
title: Вызов сервиса и результат работы
description: Описание и примеры использования вызова сервиса, а также информация про результата его работы
slug: call-and-result
sidebar_label: Вызов и результат
sidebar_position: 2
pagination_label: Вызов сервиса и результат работы

toc_min_heading_level: 2
toc_max_heading_level: 4
---

# Вызов сервиса и результат работы

## Вызов сервиса

Сервисы могут быть вызваны только через методы `.call` и `.call!`.

### Через `.call!`

Вызов через метод `.call!` будет падать при любом виде исключения.

```ruby
UsersService::Accept.call!(user: User.first)
```

### Через `.call`

Вызов через метод `.call` будет падать с ошибкой только в том случае, если он перехватит исключение в input-аргументах.
Ошибки, возникшие в атрибутах internal и output, а также ошибки, возникшие в методах — все это будет собрано в `Result` сервиса.

```ruby
UsersService::Accept.call(user: User.first)
```

## Результат

Все сервисы имеют результат своей работы. Например, в случае успеха этот вызов:

```ruby
service_result = UsersService::Accept.call(user: User.first)
```

Будет возвращать это:

```ruby
#<Servactory::Result @user=...>
```

И затем можно работать с этим результатом, например, таким образом:

```ruby
Notification::SendJob.perform_later(service_result.user.id)
```

### Содержимое результата

#### Выходящие атрибуты

Все что было добавлено через метод `output` в сервисе будет доступно в `Result`.

#### Хелперы

В результате работы сервиса присутствуют методы `success?` и `failure?`, 
которые могут помочь определить результат работы для дальнейшей обработки.

```ruby
service_result.success? # => true
service_result.failure? # => false
```

#### Ошибка

Информацию об ошибке можно получить через метод `error`.

```ruby
service_result.error

# => <ApplicationService::Errors::Failure: Invalid invoice number>
```

## Информация

Снаружи сервиса можно получить информацию о его input, internal и output атрибутах.

Это может быть полезно, например, при реализации сложной обработки классов.

Например, в сервисе описаны следующие атрибуты:

```ruby
class BuildFullName < ApplicationService::Base
  input :first_name, type: String
  input :middle_name, type: String, required: false
  input :last_name, type: String

  internal :prepared_full_name, type: String

  output :full_name, type: String

  # ...
end
```

Получить информацию о них можно следующими способами:

```ruby
BuildFullName.info

# => <Servactory::Info::Result:0x00000001118c7078 @inputs=[:first_name, :middle_name, :last_name], @internals=[:prepared_full_name], @outputs=[:full_name]>
```

```ruby
BuildFullName.info.inputs

# => [:first_name, :middle_name, :last_name]
```

```ruby
BuildFullName.info.internals

# => [:prepared_full_name]
```

```ruby
BuildFullName.info.outputs

# => [:full_name]
```
