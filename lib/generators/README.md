# Servactory Generators

## Installation

```bash
rails generate servactory:install [options]
```

**Options:**
- `--namespace` — Base namespace (default: `ApplicationService`)
- `--path` — Path to install service files (default: `app/services`)
- `--locales` — Locales to install (available: `en`, `ru`, `de`, `fr`, `es`, `it`)
- `--minimal` — Generate minimal setup without configuration examples

## Service

```bash
rails generate servactory:service NAME [inputs] [options]
```

**Arguments:**
- `NAME` — Service name (e.g., `Users::Create`, `ProcessOrder`)
- `inputs` — Input attributes with optional types (e.g., `email:string name:String user:User`)

**Options:**
- `--base-class` — Base class for service (default: `ApplicationService::Base`)
- `--path` — Path to generate service files (default: `app/services`)
- `--skip-output` — Skip default output declaration

## RSpec

```bash
rails generate servactory:rspec NAME [inputs] [options]
```

Generates RSpec spec for a Servactory service.

**Arguments:**
- `NAME` — Service name (e.g., `Users::Create`)
- `inputs` — Input attributes with optional types (e.g., `email:string name:String`)

**Options:**
- `--call-method` — Primary call method: `call` or `call!` (default: `call!`)
- `--path` — Path to service files (default: `app/services`). Spec path is auto-derived: `app/X` → `spec/X`, `lib/X` → `spec/X`
- `--skip-pending` — Skip pending placeholder
