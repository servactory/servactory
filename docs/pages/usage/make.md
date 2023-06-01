---
title: Calling service methods
slug: /usage/make
sidebar_label: Make
sidebar_position: 7
pagination_label: Calling service methods
---

# Make

Service methods are called only with `make`.

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
Can be useful when inheriting services.

```ruby
make :something,
     # highlight-next-line
     position: 1

def something
  # ...
end
```

## Method shortcuts

Through the `method_shortcuts` configuration, can add frequently used words that are used as prefixes in method names.
The names of the methods themselves will not become shorter, but this will shorten the lines using the `make` method and improve the readability of the service code, making it more expressive.

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
