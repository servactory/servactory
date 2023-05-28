---
title: Overview
description: A set of tools for building reliable services of any complexity.
slug: /
sidebar_label: Overview
sidebar_position: 1
pagination_label: Overview
---

# Servactory

A set of tools for building reliable services of any complexity.

[![Gem version](https://img.shields.io/gem/v/servactory?logo=rubygems&logoColor=fff)](https://rubygems.org/gems/servactory)
[![Release Date](https://img.shields.io/github/release-date/afuno/servactory)](https://github.com/afuno/servactory/releases)

## What is a Servacory?

Servactory is a standardization of a unified approach to the development of reliable services of any complexity.

With Servactory, you can do something simple:

```ruby
class MinimalService < ApplicationService::Base
  make :call
  
  private
  
  def call
    # ...
  end
end
```

And then call with:

```ruby
MinimalService.call!
```

Or create something more complex:

```ruby
class NotificationService::Send < ApplicationService::Base
  input :comment, type: Comment
  input :provider, type: NotificationProvider, internal: true

  internal :user, type: User
  internal :status, type: String
  internal :response, type: NotificatorApi::Models::Notification

  output :notification, type: Notification

  make :assign_user
  make :assign_status

  make :create_notification!
  make :send_notification
  make :update_notification!
  make :update_comment!
  make :assign_status

  private

  def assign_user
    self.user = comment.user
  end

  def assign_status
    self.status = StatusEnum::NOTIFIED
  end

  def create_notification!
    self.notification = Notification.create!(user:, comment: inputs.comment, provider:)
  end

  def send_notification
    service_result = NotificatorService::API::Send.call(notification:)

    return fail!(message: service_result.errors.first.message) if service_result.failure?

    self.response = service_result.response
  end

  def update_notification!
    notification.update!(original_data: response)
  end

  def update_comment!
    comment.update!(status:)
  end
end
```

With a call like this:

```ruby
# comment = Comment.first
# provider = NotificationProvider.first

NotificationService::Send.call!(comment:, provider:)
```

## Why use Servactory?

### Unified approach

The Ruby language is multifaceted. 
This leads to the fact that the services in the applications begin to vary greatly, implementing a different approach to development.
Over time, this complicates the development in the project and can make it difficult to understand the services.

Servactory standardizes the approach to development by offering to implement services only through the proposed API.

### Testing

Services written under Servactory are tested like regular Ruby classes.
As a result of a unified approach to the development of services, their testing also becomes uniform.