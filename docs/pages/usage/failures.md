---
title: Failures
slug: /usage/failures
sidebar_position: 8
---

# Failures

The methods that are used in `make` may fail. In order to more informatively provide information about this outside the service, the following methods were prepared.

## Fail

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  fail!(message: "Invalid invoice number")
end
```

## Fail for input

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  fail_input!(:invoice_number, message: "Invalid invoice number")
end
```

## Metadata

```ruby
fail!(
  message: "Invalid invoice number", 
  meta: { 
    invoice_number: inputs.invoice_number 
  }
)
```

```ruby
exception.detailed_message  # => Invalid invoice number (ApplicationService::Errors::Failure)
exception.message           # => Invalid invoice number
exception.type              # => :fail
exception.meta              # => {:invoice_number=>"BB-7650AE"}
```
