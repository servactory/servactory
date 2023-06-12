use magnus::{define_module, function, prelude::*};

struct Factory;

impl Factory {
  fn setup(&self) {
    servactory_hello_rust();
  }

  fn servactory_hello_rust(&self) {
    let servactory_module = define_module("Servactory")?;
    let hello_rust_module = servactory_module.define_module("HelloRust")?;

    hello_rust_module.define_singleton_method("hello", function!(hello, 1))?;
  }
}
