# Servactory

A set of tools for building reliable services of any complexity.

[![Gem version](https://img.shields.io/gem/v/servactory?logo=rubygems&logoColor=fff)](https://rubygems.org/gems/servactory)
[![Release Date](https://img.shields.io/github/release-date/afuno/servactory)](https://github.com/afuno/servactory/releases)

## Documentation

See [servactory.com](https://servactory.com) for documentation.

## Examples

### Service

```ruby
class UserService::Authenticate < ApplicationService::Base
  input :email, type: String
  input :password, type: String

  output :user, type: User

  private

  def call
    if (user = User.find_by(email: inputs.email)&.authenticate(inputs.password))
      self.user = user
    else
      fail!(message: "Authentication failed")
    end
  end
end
```

### Using in controller

```ruby
class SessionsController < ApplicationController
  def create
    service_result = UserService::Authenticate.call(**session_params)

    if service_result.success?
      session[:current_user_id] = service_result.user.id
      redirect_to service_result.user
    else
      flash.now[:message] = service_result.errors.first.message
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

This project is intended to be a safe, welcoming space for collaboration. Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. We recommend reading the [contributing guide](./website/docs/CONTRIBUTING.md) as well.

## License

ViewComponent is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
