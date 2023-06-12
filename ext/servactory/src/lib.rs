use magnus::{define_module, function, prelude::*, Error};

fn hello(subject: String) -> String {
  format!("Hello from Rust, {}!", subject)
}

#[magnus::init]
fn init() -> Result<(), Error> {
  // let factory = Factory;
  //
  // factory.setup();

  let servactory_module = define_module("Servactory")?;
  let hello_rust_module = servactory_module.define_module("HelloRust")?;

  hello_rust_module.define_singleton_method("hello", function!(hello, 1))?;

  Ok(())
}
