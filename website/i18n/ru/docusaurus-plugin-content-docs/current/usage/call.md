---
title: Вызов сервиса
description: Описание и примеры использования вызова сервиса
slug: call
sidebar_label: Вызов
sidebar_position: 2
pagination_label: Вызов сервиса
---

# Вызов сервиса

Сервисы могут быть вызваны только через методы `.call` и `.call!`.

Вызов через метод `.call` будет падать с ошибкой только в том случае, если он перехватит исключение в input-аргументах.
Ошибки, возникшие в атрибутах internal и output, а также ошибки, возникшие в методах — все это будет собрано в `Result` сервиса.

Вызов через метод `.call!` будет падать при любом виде исключения.

### Через `.call`

```ruby
UsersService::Accept.call(user: User.first)
```

### Через `.call!`

```ruby
UsersService::Accept.call!(user: User.first)
```

### Результат сервиса

Все сервисы имеют результат своей работы. Например, в случае успеха этот вызов:

```ruby
service_result = UsersService::Accept.call!(user: User.first)
```

Будет возвращать это:

```ruby
#<Servactory::Result:0x0000000107ad9e88 @user="...">
```

И затем можно работать с этим результатом, например, таким образом:

```ruby
Notification::SendJob.perform_later(service_result.user.id)
```
