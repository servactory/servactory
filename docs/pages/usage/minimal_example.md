---
title: Minimal example
slug: /usage/minimal-example
sidebar_label: Minimal example
sidebar_position: 1
pagination_label: Minimal example
---

# Minimal example

```ruby
class MinimalService < ApplicationService::Base
  make :call
  
  private
  
  def call
    # ...
  end
end
```

```ruby
MinimalService.call
```
