---
title: Service call
description: Description and examples of how to use service call
slug: call
sidebar_label: Call
sidebar_position: 2
pagination_label: Service call
---

# Call

Services can only be called via `.call` and `.call!` methods.

The `.call` method will only fail if it catches an exception in the input arguments. Internal and output attributes, as well as methods for failures — all this will be collected in the result.

The `.call!` method will fail if it catches any exception.

### Via `.call`

```ruby
UsersService::Accept.call(user: User.first)
```

### Via `.call!`

```ruby
UsersService::Accept.call!(user: User.first)
```
