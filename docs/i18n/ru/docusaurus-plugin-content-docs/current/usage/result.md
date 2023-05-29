---
title: Результат работы
slug: /usage/result
sidebar_label: Результат работы
sidebar_position: 3
pagination_label: Результат работы
---

# Результат сервиса

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
