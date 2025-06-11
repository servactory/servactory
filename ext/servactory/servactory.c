#include <ruby.h>

// Basic initialization function
void Init_servactory(void) {
  // Get the Servactory module
  VALUE mServactory = rb_define_module("Servactory");
  
  // Add a Native submodule for C extension functionality
  VALUE mNative = rb_define_module_under(mServactory, "Native");
  
  // Add any C function definitions here
  // Example: rb_define_singleton_method(mNative, "method_name", c_function_name, required_args);
}