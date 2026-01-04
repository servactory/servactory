# Servactory Generators

## Installation

```bash
rails generate servactory:install [options]
```

**Options:**
- `--namespace` — Base namespace (default: `ApplicationService`)
- `--locales` — Locales to install (e.g., `--locales=en,ru`)
- `--minimal` — Generate minimal setup without configuration examples

## Service

```bash
rails generate servactory:service NAME [inputs] [options]
```

**Arguments:**
- `NAME` — Service name (e.g., `Users::Create`, `ProcessOrder`)
- `inputs` — Input attributes with optional types (e.g., `email:String count:Integer`)

**Options:**
- `--base-class` — Base class for service (default: `ApplicationService::Base`)
- `--skip-output` — Skip default output declaration

## RSpec

```bash
rails generate servactory:rspec NAME [options]
```

Generates RSpec spec for an existing service using `.info` API.

**Arguments:**
- `NAME` — Existing service name (e.g., `Users::Create`)

**Options:**
- `--skip-validations` — Skip validation examples
- `--skip-pending` — Skip pending placeholder
- `--call-method` — Primary call method: `call` or `call!` (default: `call!`)
