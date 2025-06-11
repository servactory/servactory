# Servactory C Extensions

This directory contains C extensions for the Servactory gem that can provide performance improvements for critical operations.

## Structure

- `ext/servactory/` - Contains the C extension code
  - `extconf.rb` - Configuration file for building the extension
  - `servactory.c` - C code for the extension

## Building

The extension is automatically built when the gem is installed through the `rake-compiler` gem. However, you can manually build it with:

```
bundle exec rake compile
```

## Development

To add new functionality to the C extension:

1. Modify `ext/servactory/servactory.c` to add your C functions
2. Update the `Init_servactory` function to expose your functions to Ruby
3. Rebuild the extension with `bundle exec rake compile`
4. Test your changes

## Example Usage

```ruby
# The C extension is automatically loaded in lib/servactory.rb
# You can access it via Servactory::Native

# Example (once you've implemented functions in the C extension):
# result = Servactory::Native.your_c_function(args)
```

## Fallback

The gem is designed to work even when the C extension cannot be compiled. In such cases, it will fall back to a pure Ruby implementation.