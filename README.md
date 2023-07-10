<p align="center">
  <a href="https://tailwindcss.com" target="_blank">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/servactory/servactory/main/.github/logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/servactory/servactory/main/.github/logo-light.svg">
      <img alt="Servactory" src="https://raw.githubusercontent.com/servactory/servactory/main/.github/logo-light.svg" width="350" height="70" style="max-width: 100%;">
    </picture>
  </a>
</p>

<p align="center">
  A set of tools for building reliable services of any complexity.
</p>

<p align="center">
    <a href="https://rubygems.org/gems/servactory"><img src="https://img.shields.io/gem/v/servactory?logo=rubygems&logoColor=fff" alt="Gem version"></a>
    <a href="https://github.com/afuno/servactory/releases"><img src="https://img.shields.io/github/release-date/afuno/servactory" alt="Release Date"></a>
</p>

## Documentation

See [servactory.com](https://servactory.com) for documentation.

## Example

### Installation

```ruby
gem "servactory"
```

### Service

```ruby
class UserService::Authenticate < Servactory::Base
  input :email, type: String
  input :password, type: String

  output :user, type: User

  private

  def call
    if (user = User.find_by(email: inputs.email)&.authenticate(inputs.password))
      outputs.user = user
    else
      fail!(message: "Authentication failed")
    end
  end
end
```

### Usage

```ruby
class SessionsController < ApplicationController
  def create
    service_result = UserService::Authenticate.call(**session_params)

    if service_result.success?
      session[:current_user_id] = service_result.user.id
      redirect_to service_result.user
    else
      flash.now[:message] = service_result.error.message
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
```

## Contributing

This project is intended to be a safe, welcoming space for collaboration. 
Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. 
We recommend reading the [contributing guide](./website/docs/CONTRIBUTING.md) as well.

## License

Servactory is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
