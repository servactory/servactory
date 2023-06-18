---
title: Service call and result of work
description: Description and examples of how to use service call
slug: call-and-result
sidebar_label: Call and Result
sidebar_position: 2
pagination_label: Service call and result of work
---

# Service call and result of work

Services can only be called via `.call` and `.call!` methods.

## Via `.call!`

The `.call!` method will fail if it catches any exception.

```ruby
UsersService::Accept.call!(user: User.first)
```

## Via `.call`

The `.call` method will only fail if it catches an exception in the input arguments. 
Internal and output attributes, as well as methods for failures — all this will be collected in the result.

```ruby
UsersService::Accept.call(user: User.first)
```

## Result

All services have the result of their work. For example, in case of success this call:

```ruby
service_result = UsersService::Accept.call(user: User.first)
```

Will return this:

```ruby
#<Servactory::Result:0x0000000107ad9e88 @user="...">
```

And then work with thе result in this way:

```ruby
Notification::SendJob.perform_later(service_result.user.id)
```

### Result content

#### Output attributes

Anything that has been added via the `output` method in the service will be available in `Result`.

#### Helpers

As a result of the work of the service, there are `success?` and `failure?` methods, 
which can help determine the result of the work for further processing.

#### Errors

It is possible to get all errors via the `errors` method, or just the first one via the `error` method.

## Info

From outside the service, can get information about its input, internal, and output attributes.

It is valuable, when implementing complex class handling, for example.

For example, the following attributes are described in a service:

```ruby
class BuildFullName < ApplicationService::Base
  input :first_name, type: String
  input :middle_name, type: String, required: false
  input :last_name, type: String

  internal :prepared_full_name, type: String

  output :full_name, type: String

  # ...
end
```

Get information about them in the following ways:

```ruby
BuildFullName.info

# => <Servactory::Info::Result:0x00000001118c7078 @inputs=[:first_name, :middle_name, :last_name], @internals=[:prepared_full_name], @outputs=[:full_name]>
```

```ruby
BuildFullName.info.inputs

# => [:first_name, :middle_name, :last_name]
```

```ruby
BuildFullName.info.internals

# => [:prepared_full_name]
```

```ruby
BuildFullName.info.outputs

# => [:full_name]
```
