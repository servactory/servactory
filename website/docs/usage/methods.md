---
title: Calling service methods
description: Description and examples of using service method calls
slug: methods
sidebar_label: Methods
sidebar_position: 4
pagination_label: Calling service methods
---

# Methods

Service methods are called only with `make` method.

## Examples

### Minimum

```ruby
make :something

def something
  # ...
end
```

### Several methods

```ruby
# highlight-next-line
make :assign_api_model
# highlight-next-line
make :perform_api_request
# highlight-next-line
make :process_result

# highlight-next-line
def assign_api_model
  internals.api_model = APIModel.new
end

# highlight-next-line
def perform_api_request
  internals.response = APIClient.resource.create(internals.api_model)
end

# highlight-next-line
def process_result
  ARModel.create!(internals.response)
end
```

## Options

### Option `if`

Before calling the method, the condition described in `if` will be checked.

```ruby
make :something,
     # highlight-next-line
     if: ->(**) { Settings.something.enabled }

def something
  # ...
end
```

### Option `unless`

The opposite of the `if` option.

```ruby
make :something,
     # highlight-next-line
     unless: ->(**) { Settings.something.disabled }

def something
  # ...
end
```

### Option `position`

All methods have a position.
If a method needs to be called at a different time than it was added via `make`, then the `position` option can be used.
Can be useful at service inheritance.

```ruby
class SomeApiService::Base < ApplicationService::Base
  make :api_request!,
       # highlight-next-line
       position: 2

  # ...
end

class SomeApiService::Posts::Create < SomeApiService::Base
  input :post_name, type: String

  # ...
  
  make :validate!,
       # highlight-next-line
       position: 1

  private

  def validate!
    # ...
  end

  # ...
end
```

## Group of multiple methods

You can use the `stage` method to group multiple methods into one execution group.

:::info

Usage of the `position` option for `make` will sort only in `stage`.

:::

```ruby
stage do
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Option `only_if`

Перед вызовом методов внутри `stage` будет проверено условие, описанное в `only_if`.

```ruby {2}
stage do
  only_if ->(context:) { Settings.features.preview.enabled }
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Option `wrap_in`

Group of methods in `stage` can be wrapped in something.
For example, it could be `ActiveRecord::Base.transaction` from Rails.

```ruby {2}
stage do
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods.call } }
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Option `rollback`

If an exception occurs in one of the methods in the group or in `wrap_in`, this can be handled using the `rollback` method.

```ruby {3,12}
stage do
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods.call } }
  rollback :clear_data_and_fail!
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end

# ...

def clear_data_and_fail!(e)
  # ...

  fail!(message: "Failed to create data: #{e.message}")
end
```

## Aliases for `make`

Through the `aliases_for_make` configuration it is possible to add an alias for the `make` method.

```ruby {2,5}
configuration do
  aliases_for_make %i[execute]
end

execute :something

def something
  # ...
end
```

## Shortcuts for `make`

Add frequently used words that are used as prefixes in method names through the `shortcuts_for_make` configuration.
It won't make the names of methods shorter, but that will shorten the lines using the `make` method and improve the readability of the service code, making it more expressive.

```ruby {2,5,6,9,13}
configuration do
  shortcuts_for_make %i[assign perform]
end

assign :api_model
perform :api_request
make :process_result

def assign_api_model
  internals.api_model = APIModel.new
end

def perform_api_request
  internals.response = APIClient.resource.create(internals.api_model)
end

def process_result
  ARModel.create!(internals.response)
end
```
