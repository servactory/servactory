---
title: Configuration
description: Description and examples of service configuration
slug: configuration
sidebar_label: Configuration
sidebar_position: 1
pagination_label: Configuration
---

# Configuration

Services are configured through the `configuration` method, which can be placed, for example, in the base class.

## Configuration examples

### Errors

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

### Helpers for `input`

Custom helpers for `input` are based on the `must` and `prepare` options.

#### Example with `must`

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

#### Example with `prepare`

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

### Aliases for `make`

```ruby {2} title="app/services/application_service/base.rb"
configuration do
  aliases_for_make %i[execute]
end
```

### Shortcuts for `make`

```ruby {4} title="app/services/application_service/base.rb"
module ApplicationService
  class Base < Servactory::Base
    configuration do
      shortcuts_for_make %i[assign perform]
    end
  end
end
```
