---
title: Calling service methods
slug: /usage/methods
sidebar_label: Methods
sidebar_position: 7
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
  self.api_model = APIModel.new
end

# highlight-next-line
def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

# highlight-next-line
def process_result
  ARModel.create!(response)
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

## Group of several methods

```ruby
stage do
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Wrapping

```ruby
stage do
  # highlight-next-line
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods } }
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end
```

### Rollback

```ruby
stage do
  wrap_in ->(methods:) { ActiveRecord::Base.transaction { methods } }
  # highlight-next-line
  rollback :clear_data_and_fail!
  
  make :create_user!
  make :create_blog_for_user!
  make :create_post_for_user_blog!
end

# ...

# highlight-next-line
def clear_data_and_fail!(e)
  # ...

  fail!(message: "Failed to create data: #{e.message}")
end
```

## Method shortcuts

Add frequently used words that are used as prefixes in method names through the `method_shortcuts` configuration.
It won't make the names of methods shorter, but that will shorten the lines using the `make` method and improve the readability of the service code, making it more expressive.

```ruby
configuration do
  # highlight-next-line
  method_shortcuts %i[assign perform]
end

# highlight-next-line
assign :api_model
# highlight-next-line
perform :api_request
make :process_result

# highlight-next-line
def assign_api_model
  self.api_model = APIModel.new
end

# highlight-next-line
def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

def process_result
  ARModel.create!(response)
end
```
