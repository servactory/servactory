---
title: Configuration
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
