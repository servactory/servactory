# frozen_string_literal: true

require "yaml"

LOCALES_DIR = File.expand_path("../config/locales", __dir__)
BASE_LOCALE = "en"

def flatten_keys(hash, prefix = nil)
  hash.each_with_object({}) do |(key, value), result|
    full_key = [prefix, key].compact.join(".")
    if value.is_a?(Hash)
      result.merge!(flatten_keys(value, full_key))
    else
      result[full_key] = value
    end
  end
end

def extract_variables(text)
  return [] unless text.is_a?(String)

  text.scan(/%\{(\w+)\}/).flatten.sort
end

errors = []

# Discover locale files dynamically
locale_files = Dir.glob(File.join(LOCALES_DIR, "*.yml")).sort
locale_names = locale_files.map { |f| File.basename(f, ".yml") }

if locale_files.empty?
  puts "❌ No locale files found in #{LOCALES_DIR}"
  exit 1
end

unless locale_names.include?(BASE_LOCALE)
  puts "❌ Base locale file '#{BASE_LOCALE}.yml' not found in #{LOCALES_DIR}"
  exit 1
end

# Parse all locale files
locales = {}

locale_files.each do |file|
  name = File.basename(file, ".yml")

  begin
    yaml = YAML.safe_load_file(file, permitted_classes: [Symbol])
  rescue Psych::SyntaxError => e
    errors << "#{name}.yml: invalid YAML syntax — #{e.message}"
    next
  end

  unless yaml.is_a?(Hash) && yaml.key?(name)
    errors << "#{name}.yml: root key must be '#{name}'"
    next
  end

  locales[name] = flatten_keys(yaml.fetch(name))
end

base_keys = locales[BASE_LOCALE]

unless base_keys
  puts "❌ Failed to parse base locale '#{BASE_LOCALE}.yml'"
  errors.each { |e| puts "  • #{e}" }
  exit 1
end

# Validate each non-base locale
locales.each do |name, keys|
  next if name == BASE_LOCALE

  # Missing keys
  (base_keys.keys - keys.keys).each do |key|
    errors << "#{name}.yml: missing key '#{key}'"
  end

  # Extra keys
  (keys.keys - base_keys.keys).each do |key|
    errors << "#{name}.yml: extra key '#{key}'"
  end

  # Interpolation variables
  (base_keys.keys & keys.keys).each do |key|
    expected = extract_variables(base_keys[key])
    got = extract_variables(keys[key])

    next if expected == got

    errors << "#{name}.yml: key '#{key}' has different interpolation variables " \
              "(expected #{expected.inspect}, got #{got.inspect})"
  end
end

# Value checks for all locales
locales.each do |name, keys|
  keys.each do |key, value|
    next unless value.is_a?(String)

    if value.strip.empty?
      errors << "#{name}.yml: key '#{key}' has empty value"
    end

    if value.count("[") != value.count("]")
      errors << "#{name}.yml: key '#{key}' has unbalanced brackets"
    end

    if value.count("`").odd?
      errors << "#{name}.yml: key '#{key}' has odd number of backticks"
    end
  end

  keys.each do |key, value|
    if value.nil?
      errors << "#{name}.yml: key '#{key}' has nil value"
    end
  end
end

if errors.any?
  puts "❌ Found #{errors.size} error(s):\n\n"
  errors.each { |e| puts "  • #{e}" }
  exit 1
else
  sorted = locale_names.sort
  puts "✅ All locale files are valid (#{sorted.join(", ")})"
  puts "   Base locale: #{BASE_LOCALE}"
  puts "   Keys: #{base_keys.size}"
  exit 0
end
