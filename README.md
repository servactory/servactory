<p align="center">
  <a href="https://servactory.com" target="_blank">
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
  <a href="https://github.com/servactory/servactory/releases"><img src="https://img.shields.io/github/release-date/servactory/servactory" alt="Release Date"></a>
  <a href="https://rubygems.org/gems/servactory"><img src="https://img.shields.io/gem/dt/servactory" alt="Downloads"></a>
  <a href="https://www.ruby-lang.org"><img src="https://img.shields.io/badge/Ruby-3.2+-red" alt="Ruby version"></a>
</p>


## 📚 Documentation

See [servactory.com](https://servactory.com) for comprehensive documentation, including:

- Detailed guides for all features
- Advanced configuration options
- Best practices and patterns
- Migration guides
- API reference

## 💡 Why Servactory?

Building reliable services shouldn't be complicated. Servactory provides a battle-tested framework for creating service objects with:

- 🛡️ **Type Safety** - Enforce types on inputs and outputs, catch errors early
- ✅ **Built-in Validation** - Rich validation DSL with custom rules
- 🧪 **Test-Friendly** - RSpec matchers for easy testing
- 📊 **Structured Output** - Consistent Result object pattern
- 🔧 **Highly Configurable** - Extensions, helpers, and custom options
- 📚 **Well Documented** - Comprehensive guides and examples

## 🚀 Quick Start

### Installation

```ruby
gem "servactory"
```

### Define service

```ruby
class UserService::Authenticate < Servactory::Base
  input :email, type: String
  input :password, type: String

  output :user, type: User

  make :authenticate!

  private

  def authenticate!
    if (user = User.authenticate_by(email: inputs.email, password: inputs.password)).present?
      outputs.user = user
    else
      fail!(message: "Authentication failed", meta: { email: inputs.email })
    end
  end
end
```

### Usage in controller

```ruby
class SessionsController < ApplicationController
  def create
    service = UserService::Authenticate.call(**session_params)

    if service.success?
      session[:current_user_id] = service.user.id
      redirect_to service.user
    else
      flash.now[:alert] = service.error.message
      render :new, status: :unprocessable_entity
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
```

## 🤝 Contributing

We love contributions! Check out our [Contributing Guide](https://servactory.com/CONTRIBUTING) to get started.

**Ways to contribute:**
- 🐛 Report bugs and issues
- 💡 Suggest new features
- 📝 Improve documentation
- 🧪 Add test cases
- 🔧 Submit pull requests

## 🙏 Acknowledgments

Special thanks to all our [contributors](https://github.com/servactory/servactory/graphs/contributors)!

## 📄 License

Servactory is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
