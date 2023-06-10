---
title: Configuration
description: Description and examples of service configuration
slug: /usage/configuration
sidebar_label: Configuration
sidebar_position: 1
pagination_label: Configuration
---

# Configuration

Services are configured through the `configuration` method, which can be placed, for example, in the base class.

## Configuration examples

### Errors

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

### Helpers for `input`

Custom helpers for `input` should be based on the `must` option.

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

### Method shortcuts

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
