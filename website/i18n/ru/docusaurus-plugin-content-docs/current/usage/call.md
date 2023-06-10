---
title: Вызов сервиса
description: Описание и примеры использования вызова сервиса
slug: /usage/call
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
