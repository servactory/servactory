---
title: Service failures
slug: /usage/failures
sidebar_label: Failures
sidebar_position: 8
pagination_label: Service failures
---

# Failures

The methods that are used in `make` may fail. In order to more informatively provide information about this outside the service, the following methods were prepared.

## Via `.fail!`

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

## Via `.fail_input!`

```ruby
make :check!

def check!
  return if inputs.invoice_number.start_with?("AA")

  # highlight-next-line
  fail_input!(:invoice_number, message: "Invalid invoice number")
end
```
