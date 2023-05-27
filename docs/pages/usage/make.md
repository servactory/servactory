---
title: Make methods
slug: /usage/make
sidebar_label: Make
sidebar_position: 7
pagination_label: Make methods
---

# Make

## Minimal example

```ruby
make :something

def something
  # ...
end
```

## Condition

```ruby
make :something,
     # highlight-next-line
     if: ->(**) { Settings.something.enabled }

def something
  # ...
end
```

## Several

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

## Method shortcuts

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
