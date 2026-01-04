# Servactory Generators

## Installation

```bash
rails generate servactory:install [options]
```

**Options:**
- `--locales` — Locales to install (e.g., `--locales=en ru`)
- `--skip-comments` — Skip configuration comments
- `--namespace` — Base namespace (default: `ApplicationService`)

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
- `--skip-make` — Skip default make method
- `--internal` — Internal attributes (e.g., `--internal=cache data`)
- `--output` — Output attributes (e.g., `--output=result status`)

## RSpec

```bash
rails generate servactory:rspec NAME [inputs] [options]
```

**Arguments:**
- `NAME` — Service name (e.g., `Users::Create`, `ProcessOrder`)
- `inputs` — Input attributes with optional types (e.g., `email:String count:Integer`)

**Options:**
- `--skip-validations` — Skip validation examples
- `--skip-pending` — Skip pending placeholder
- `--call-method` — Primary call method: `call` or `call!` (default: `call!`)
