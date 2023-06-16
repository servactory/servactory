---
title: Getting started
description: Description and examples of use
slug: getting-started
sidebar_label: Getting started
sidebar_position: 2
pagination_label: Getting started
---

# Getting started

## Conventions

- All services are subclasses of `Servactory::Base` and are located in the `app/services` directory. It is common practice to create and inherit from `ApplicationService::Base`, which is a subclass of `Servactory::Base`.
- Name services by what they do, not by what they accept. Use verbs in names. For example, `UsersService::Create` instead of `UsersService::Creation`.

## Installation

Add this to `Gemfile`:

```ruby
gem "servactory"
```

And execute:

```shell
bundle install
```

## Preparation

As a first step, it is recommended to prepare the base class for further inheritance.

### ApplicationService::Errors

```ruby title="app/services/application_service/errors.rb"
module ApplicationService
  module Errors
    class InputError < Servactory::Errors::InputError; end
    class OutputError < Servactory::Errors::OutputError; end
    class InternalError < Servactory::Errors::InternalError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
```

### ApplicationService::Base

```ruby title="app/services/application_service/base.rb"
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
