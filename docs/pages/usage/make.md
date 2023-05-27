---
title: Make
slug: /usage/make
sidebar_position: 7
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
make :something, if: ->(**) { Settings.something.enabled }

def something
  # ...
end
```

## Several

```ruby
make :assign_api_model
make :perform_api_request
make :process_result

def assign_api_model
  self.api_model = APIModel.new
end

def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

def process_result
  ARModel.create!(response)
end
```

## Method shortcuts

```ruby
configuration do
  method_shortcuts %i[assign perform]
end

assign :api_model
perform :api_request
make :process_result

def assign_api_model
  self.api_model = APIModel.new
end

def perform_api_request
  self.response = APIClient.resource.create(api_model)
end

def process_result
  ARModel.create!(response)
end
```
