---
title: Неудачи и падения сервиса
description: Описание и примеры использования неудач и падений сервиса
slug: failures
sidebar_label: Неудачи
sidebar_position: 5
pagination_label: Неудачи и падения сервиса
---

# Неудачи сервиса

При простом сценарии использования все неудачи (или падения) сервиса будут возникать из input, output или internal.
Это все будет считаться неожиданным поведением в работе сервиса.

Но помимо этого можно также описать ожидаемые падения в работе сервиса.
Для этого предусмотрены методы, представленные ниже.

### Fail

Базовый метод `.fail!` позволяет передать текст в виде сообщения, а также дополнительную информацию через атрибут `meta`.

При вызове сервиса через метод `.call!` будет вызываться exception с классом `Servactory::Errors::Failure`.

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  # highlight-next-line
  fail!(message: "Invalid invoice number")
end
```

```ruby
fail!(
  message: "Invalid invoice number",
  # highlight-next-line
  meta: {
    # highlight-next-line
    invoice_number: inputs.invoice_number
    # highlight-next-line
  }
)
```

```ruby
exception.detailed_message  # => Invalid invoice number (ApplicationService::Errors::Failure)
exception.message           # => Invalid invoice number
exception.type              # => :fail
exception.meta              # => {:invoice_number=>"BB-7650AE"}
```

### Fail для input

Отличается от `.fail!` обязательным указыванием имени input-аргумента.

При вызове сервиса через метод `.call!` будет явзяться exception с классом `Servactory::Errors::InputError`.

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  # highlight-next-line
  fail_input!(:invoice_number, message: "Invalid invoice number")
end
```
