# Changelog

## [v2.13.2](https://github.com/servactory/servactory/tree/v2.13.2) (2025-03-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.13.1...v2.13.2)

**Fixed:**

- Fix handling of default values ​​in inputs and dynamic option schema [\#269](https://github.com/servactory/servactory/pull/269) ([afuno](https://github.com/afuno))

## [v2.13.1](https://github.com/servactory/servactory/tree/v2.13.1) (2025-03-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.13.0...v2.13.1)

**Fixed:**

- Fix definition of default value for input [\#268](https://github.com/servactory/servactory/pull/268) ([afuno](https://github.com/afuno))

## [v2.13.0](https://github.com/servactory/servactory/tree/v2.13.0) (2025-03-06)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.12.0...v2.13.0)

**Implemented enhancements:**

- Add support for `prepare` option inside `schema` dynamic option [\#267](https://github.com/servactory/servactory/pull/267) ([afuno](https://github.com/afuno))

## [v2.12.0](https://github.com/servactory/servactory/tree/v2.12.0) (2025-03-02)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.12.0.rc4...v2.12.0)

**Implemented enhancements:**

- Rewrite `inclusion` option as dynamic [\#262](https://github.com/servactory/servactory/pull/262) ([afuno](https://github.com/afuno))
- Rewrite `schema` option as dynamic [\#260](https://github.com/servactory/servactory/pull/260) ([afuno](https://github.com/afuno))
- Rework storage to use it for all attribute types [\#259](https://github.com/servactory/servactory/pull/259) ([afuno](https://github.com/afuno))

**Fixed:**

- Fix optionality for dynamic option `schema` [\#264](https://github.com/servactory/servactory/pull/264) ([afuno](https://github.com/afuno))

**Dependencies:**

- \[02.03.2025\] Update dependencies [\#266](https://github.com/servactory/servactory/pull/266) ([afuno](https://github.com/afuno))
- \[19.02.2025\] Update libraries [\#263](https://github.com/servactory/servactory/pull/263) ([afuno](https://github.com/afuno))
- \[08.02.2025\] Update libraries [\#261](https://github.com/servactory/servactory/pull/261) ([afuno](https://github.com/afuno))

## [v2.12.0.rc4](https://github.com/servactory/servactory/tree/v2.12.0.rc4) (2025-03-01)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.12.0.rc3...v2.12.0.rc4)

## [v2.12.0.rc3](https://github.com/servactory/servactory/tree/v2.12.0.rc3) (2025-03-01)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.12.0.rc2...v2.12.0.rc3)

## [v2.12.0.rc2](https://github.com/servactory/servactory/tree/v2.12.0.rc2) (2025-02-18)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.12.0.rc1...v2.12.0.rc2)

## [v2.12.0.rc1](https://github.com/servactory/servactory/tree/v2.12.0.rc1) (2025-02-08)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.11.0...v2.12.0.rc1)

## [v2.11.0](https://github.com/servactory/servactory/tree/v2.11.0) (2025-01-01)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.10.0...v2.11.0)

**Implemented enhancements:**

- Refactor input handling to centralize argument management [\#258](https://github.com/servactory/servactory/pull/258) ([afuno](https://github.com/afuno))
- Add support for Ruby 3.4 [\#257](https://github.com/servactory/servactory/pull/257) ([afuno](https://github.com/afuno))

## [v2.10.0](https://github.com/servactory/servactory/tree/v2.10.0) (2024-12-20)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.2...v2.10.0)

**Implemented enhancements:**

- Handle absence of rollback during method execution failure [\#253](https://github.com/servactory/servactory/pull/253) ([afuno](https://github.com/afuno))

**Fixed:**

- Fix handling of `on_failure` hook in `allow_service` helpers for RSpec [\#255](https://github.com/servactory/servactory/pull/255) ([nflm](https://github.com/nflm))
- Improve message handling for RSpec chain `with_outputs` [\#252](https://github.com/servactory/servactory/pull/252) ([afuno](https://github.com/afuno))

**Dependencies:**

- \[20.12.2024\] Update libraries [\#256](https://github.com/servactory/servactory/pull/256) ([afuno](https://github.com/afuno))

## [v2.9.2](https://github.com/servactory/servactory/tree/v2.9.2) (2024-12-09)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.1...v2.9.2)

## [v2.9.1](https://github.com/servactory/servactory/tree/v2.9.1) (2024-11-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0...v2.9.1)

## [v2.9.0](https://github.com/servactory/servactory/tree/v2.9.0) (2024-11-08)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc9...v2.9.0)

**Breaking changes:**

- Change internal method names and associated translation keys [\#241](https://github.com/servactory/servactory/pull/241) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Apply Servactory RuboCop [\#249](https://github.com/servactory/servactory/pull/249) ([afuno](https://github.com/afuno))
- Add `with` support for RSpec Mocks [\#248](https://github.com/servactory/servactory/pull/248) ([afuno](https://github.com/afuno))
- Improve `be_failure_service` matcher in RSpec [\#245](https://github.com/servactory/servactory/pull/245) ([afuno](https://github.com/afuno))
- Add access to context in exceptions for use inside Datory [\#243](https://github.com/servactory/servactory/pull/243) ([afuno](https://github.com/afuno))
- Add service information to attribute exceptions [\#242](https://github.com/servactory/servactory/pull/242) ([afuno](https://github.com/afuno))
- Improve uniqueness of types [\#240](https://github.com/servactory/servactory/pull/240) ([afuno](https://github.com/afuno))
- Native support for Datory [\#238](https://github.com/servactory/servactory/pull/238) ([afuno](https://github.com/afuno))

**Fixed:**

- Update spec matchers from `with` to `contains` [\#247](https://github.com/servactory/servactory/pull/247) ([afuno](https://github.com/afuno))
- Fix class checking inside `be_failure_service` [\#244](https://github.com/servactory/servactory/pull/244) ([afuno](https://github.com/afuno))

**Dependencies:**

- \[08.11.2024\] Remove deprecated files and update dependencies [\#251](https://github.com/servactory/servactory/pull/251) ([afuno](https://github.com/afuno))
- \[14.10.2024\] Update libraries [\#246](https://github.com/servactory/servactory/pull/246) ([afuno](https://github.com/afuno))
- Add support for Ruby version 3.4.0-preview2 [\#227](https://github.com/servactory/servactory/pull/227) ([afuno](https://github.com/afuno))

**Merged pull requests:**

- Clarify Rails 8.0 versions in CI [\#250](https://github.com/servactory/servactory/pull/250) ([afuno](https://github.com/afuno))

## [v2.9.0.rc9](https://github.com/servactory/servactory/tree/v2.9.0.rc9) (2024-11-03)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc8...v2.9.0.rc9)

## [v2.9.0.rc8](https://github.com/servactory/servactory/tree/v2.9.0.rc8) (2024-10-27)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc7...v2.9.0.rc8)

## [v2.9.0.rc7](https://github.com/servactory/servactory/tree/v2.9.0.rc7) (2024-10-22)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc6...v2.9.0.rc7)

## [v2.9.0.rc6](https://github.com/servactory/servactory/tree/v2.9.0.rc6) (2024-10-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc5...v2.9.0.rc6)

## [v2.9.0.rc5](https://github.com/servactory/servactory/tree/v2.9.0.rc5) (2024-10-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc4...v2.9.0.rc5)

## [v2.9.0.rc4](https://github.com/servactory/servactory/tree/v2.9.0.rc4) (2024-09-30)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc3...v2.9.0.rc4)

## [v2.9.0.rc3](https://github.com/servactory/servactory/tree/v2.9.0.rc3) (2024-09-23)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc2...v2.9.0.rc3)

## [v2.9.0.rc2](https://github.com/servactory/servactory/tree/v2.9.0.rc2) (2024-09-22)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.9.0.rc1...v2.9.0.rc2)

## [v2.9.0.rc1](https://github.com/servactory/servactory/tree/v2.9.0.rc1) (2024-09-17)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.8.0...v2.9.0.rc1)

## [v2.8.0](https://github.com/servactory/servactory/tree/v2.8.0) (2024-08-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.7.0...v2.8.0)

**Breaking changes:**

- Remove deprecated error classes and configurations [\#237](https://github.com/servactory/servactory/pull/237) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Implement `to_h` method for `Result` [\#236](https://github.com/servactory/servactory/pull/236) ([afuno](https://github.com/afuno))

**Dependencies:**

- \[28.08.2024\] Update libraries [\#235](https://github.com/servactory/servactory/pull/235) ([afuno](https://github.com/afuno))

## [v2.7.0](https://github.com/servactory/servactory/tree/v2.7.0) (2024-08-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.3...v2.7.0)

**Breaking changes:**

- Drop support for Ruby 3.0 [\#218](https://github.com/servactory/servactory/pull/218) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Add dynamic option `multiple_of` [\#231](https://github.com/servactory/servactory/pull/231) ([afuno](https://github.com/afuno))
- Improve text translation mechanism in dynamic option `consists_of` [\#230](https://github.com/servactory/servactory/pull/230) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update Ruby version and Bundler version [\#229](https://github.com/servactory/servactory/pull/229) ([afuno](https://github.com/afuno))
- \[05.07.2024\] Update libraries [\#228](https://github.com/servactory/servactory/pull/228) ([afuno](https://github.com/afuno))

**Merged pull requests:**

- Add support for Rails 7.2 [\#234](https://github.com/servactory/servactory/pull/234) ([afuno](https://github.com/afuno))
- Add support for Rails 7.2 [\#233](https://github.com/servactory/servactory/pull/233) ([afuno](https://github.com/afuno))

## [v2.6.3](https://github.com/servactory/servactory/tree/v2.6.3) (2024-07-26)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.2...v2.6.3)

## [v2.6.2](https://github.com/servactory/servactory/tree/v2.6.2) (2024-05-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.1...v2.6.2)

**Fixed:**

- Add support for optional values for dynamic option `format` [\#226](https://github.com/servactory/servactory/pull/226) ([afuno](https://github.com/afuno))

## [v2.6.1](https://github.com/servactory/servactory/tree/v2.6.1) (2024-05-15)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.0...v2.6.1)

**Implemented enhancements:**

- Add `collection_mode_class_names` configuration to template for generator [\#225](https://github.com/servactory/servactory/pull/225) ([afuno](https://github.com/afuno))
- Improve naming of some variables [\#224](https://github.com/servactory/servactory/pull/224) ([afuno](https://github.com/afuno))

**Fixed:**

- Correct location of translations [\#223](https://github.com/servactory/servactory/pull/223) ([afuno](https://github.com/afuno))
- Correct translation for `format.unknown` [\#222](https://github.com/servactory/servactory/pull/222) ([afuno](https://github.com/afuno))

## [v2.6.0](https://github.com/servactory/servactory/tree/v2.6.0) (2024-05-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.0.rc5...v2.6.0)

**Breaking changes:**

- Replace `service_class_name` attribute with `service` [\#212](https://github.com/servactory/servactory/pull/212) ([afuno](https://github.com/afuno))
- Rewrite `consists_of` option as dynamic and refuse collection mode [\#180](https://github.com/servactory/servactory/pull/180) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Add example for `predicate_methods_enabled` configuration [\#221](https://github.com/servactory/servactory/pull/221) ([afuno](https://github.com/afuno))
- Refactor configuration [\#220](https://github.com/servactory/servactory/pull/220) ([afuno](https://github.com/afuno))
- Revert `collection_mode_class_names` configuration and improve translations [\#216](https://github.com/servactory/servactory/pull/216) ([afuno](https://github.com/afuno))
- Add config `i18n_root_key` [\#213](https://github.com/servactory/servactory/pull/213) ([afuno](https://github.com/afuno))

**Fixed:**

- Update attribute to `service` in `valid_with` [\#219](https://github.com/servactory/servactory/pull/219) ([afuno](https://github.com/afuno))
- Improve work and examples for `consists_of` option [\#217](https://github.com/servactory/servactory/pull/217) ([afuno](https://github.com/afuno))
- Fix check in `consists_of` option of input when it is optional [\#215](https://github.com/servactory/servactory/pull/215) ([afuno](https://github.com/afuno))
- Fix `consists_of` option for optional attribute with default value [\#214](https://github.com/servactory/servactory/pull/214) ([afuno](https://github.com/afuno))

## [v2.6.0.rc5](https://github.com/servactory/servactory/tree/v2.6.0.rc5) (2024-05-11)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.0.rc4...v2.6.0.rc5)

## [v2.6.0.rc4](https://github.com/servactory/servactory/tree/v2.6.0.rc4) (2024-05-11)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.0.rc3...v2.6.0.rc4)

## [v2.6.0.rc3](https://github.com/servactory/servactory/tree/v2.6.0.rc3) (2024-05-11)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.0.rc2...v2.6.0.rc3)

## [v2.6.0.rc2](https://github.com/servactory/servactory/tree/v2.6.0.rc2) (2024-05-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.6.0.rc1...v2.6.0.rc2)

## [v2.6.0.rc1](https://github.com/servactory/servactory/tree/v2.6.0.rc1) (2024-05-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.2...v2.6.0.rc1)

## [v2.5.2](https://github.com/servactory/servactory/tree/v2.5.2) (2024-05-02)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.1...v2.5.2)

**Fixed:**

- Fix work with RSpec [\#211](https://github.com/servactory/servactory/pull/211) ([afuno](https://github.com/afuno))

## [v2.5.1](https://github.com/servactory/servactory/tree/v2.5.1) (2024-05-01)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0...v2.5.1)

**Fixed:**

- Add RSpec Expectations [\#210](https://github.com/servactory/servactory/pull/210) ([afuno](https://github.com/afuno))

## [v2.5.0](https://github.com/servactory/servactory/tree/v2.5.0) (2024-04-30)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0.rc7...v2.5.0)

**Breaking changes:**

- Drop Ruby 2.7 support [\#198](https://github.com/servactory/servactory/pull/198) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Add `duration` format for dynamic option `format` [\#207](https://github.com/servactory/servactory/pull/207) ([afuno](https://github.com/afuno))
- Delete `prepare_vs_must` conflict handling [\#206](https://github.com/servactory/servactory/pull/206) ([afuno](https://github.com/afuno))
- Add `uuid` format for dynamic option `format` [\#205](https://github.com/servactory/servactory/pull/205) ([afuno](https://github.com/afuno))
- Add configuration option for predicate methods [\#204](https://github.com/servactory/servactory/pull/204) ([afuno](https://github.com/afuno))
- Delete `prepare_vs_collection` conflict handling [\#203](https://github.com/servactory/servactory/pull/203) ([afuno](https://github.com/afuno))
- Add `result_class` configuration [\#202](https://github.com/servactory/servactory/pull/202) ([afuno](https://github.com/afuno))
- Add generators [\#201](https://github.com/servactory/servactory/pull/201) ([afuno](https://github.com/afuno))
- Add helpers and matchers for RSpec [\#197](https://github.com/servactory/servactory/pull/197) ([afuno](https://github.com/afuno))
- Add `fail_on!` method to catch unexpected service exceptions [\#196](https://github.com/servactory/servactory/pull/196) ([afuno](https://github.com/afuno))

**Fixed:**

- Fix usage of `collection_mode_class_names` configuration [\#200](https://github.com/servactory/servactory/pull/200) ([afuno](https://github.com/afuno))

**Dependencies:**

- \[01.05.2024\] Update libraries [\#209](https://github.com/servactory/servactory/pull/209) ([afuno](https://github.com/afuno))
- Update libraries from 11.04.2024 [\#199](https://github.com/servactory/servactory/pull/199) ([afuno](https://github.com/afuno))

## [v2.5.0.rc7](https://github.com/servactory/servactory/tree/v2.5.0.rc7) (2024-04-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0.rc6...v2.5.0.rc7)

## [v2.5.0.rc6](https://github.com/servactory/servactory/tree/v2.5.0.rc6) (2024-04-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0.rc5...v2.5.0.rc6)

## [v2.5.0.rc5](https://github.com/servactory/servactory/tree/v2.5.0.rc5) (2024-04-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0.rc4...v2.5.0.rc5)

## [v2.5.0.rc4](https://github.com/servactory/servactory/tree/v2.5.0.rc4) (2024-04-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0.rc3...v2.5.0.rc4)

## [v2.5.0.rc3](https://github.com/servactory/servactory/tree/v2.5.0.rc3) (2024-04-23)

[Full Changelog](https://github.com/servactory/servactory/compare/2.5.0.rc2...v2.5.0.rc3)

## [2.5.0.rc2](https://github.com/servactory/servactory/tree/2.5.0.rc2) (2024-04-21)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.5.0.rc1...2.5.0.rc2)

## [v2.5.0.rc1](https://github.com/servactory/servactory/tree/v2.5.0.rc1) (2024-04-21)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.4.3...v2.5.0.rc1)

## [v2.4.3](https://github.com/servactory/servactory/tree/v2.4.3) (2024-03-29)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.4.2...v2.4.3)

**Implemented enhancements:**

- Add output data transfer to `on_failure` in `Result` [\#195](https://github.com/servactory/servactory/pull/195) ([afuno](https://github.com/afuno))

## [v2.4.2](https://github.com/servactory/servactory/tree/v2.4.2) (2024-03-29)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.4.1...v2.4.2)

**Implemented enhancements:**

- Add output data transfer to Result in case of failure [\#194](https://github.com/servactory/servactory/pull/194) ([afuno](https://github.com/afuno))

## [v2.4.1](https://github.com/servactory/servactory/tree/v2.4.1) (2024-03-26)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.4.0...v2.4.1)

**Fixed:**

- Refuse change to rename `Result` [\#193](https://github.com/servactory/servactory/pull/193) ([afuno](https://github.com/afuno))

## [v2.4.0](https://github.com/servactory/servactory/tree/v2.4.0) (2024-03-26)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.3.1...v2.4.0)

**Implemented enhancements:**

- Improve name of Result class by adding name of service class [\#192](https://github.com/servactory/servactory/pull/192) ([afuno](https://github.com/afuno))
- Add `boolean` format for dynamic option `format` [\#189](https://github.com/servactory/servactory/pull/189) ([afuno](https://github.com/afuno))
- Add ability to customize formats in dynamic option `format` [\#188](https://github.com/servactory/servactory/pull/188) ([afuno](https://github.com/afuno))
- Rename `setup` method to `use` for dynamic options [\#187](https://github.com/servactory/servactory/pull/187) ([afuno](https://github.com/afuno))
- Add `datetime` format for dynamic option `format` [\#186](https://github.com/servactory/servactory/pull/186) ([afuno](https://github.com/afuno))
- Simplify `date` format for dynamic option `format` [\#185](https://github.com/servactory/servactory/pull/185) ([afuno](https://github.com/afuno))
- Add `time` format for dynamic option `format` [\#184](https://github.com/servactory/servactory/pull/184) ([afuno](https://github.com/afuno))
- Add `password` format for dynamic option `format` [\#183](https://github.com/servactory/servactory/pull/183) ([afuno](https://github.com/afuno))
- Add `email` format for dynamic option `format` [\#182](https://github.com/servactory/servactory/pull/182) ([afuno](https://github.com/afuno))
- Add dynamic option `format` with first format for `date` [\#181](https://github.com/servactory/servactory/pull/181) ([afuno](https://github.com/afuno))
- Add translations for dynamic options [\#179](https://github.com/servactory/servactory/pull/179) ([afuno](https://github.com/afuno))
- Improve collections and `consists_of` option [\#178](https://github.com/servactory/servactory/pull/178) ([afuno](https://github.com/afuno))
- Improve handling of `input`, `internal` and `output` in their options [\#176](https://github.com/servactory/servactory/pull/176) ([afuno](https://github.com/afuno))
- Implement dynamic options [\#175](https://github.com/servactory/servactory/pull/175) ([afuno](https://github.com/afuno))
- Implement new approach to storing service data [\#174](https://github.com/servactory/servactory/pull/174) ([afuno](https://github.com/afuno))
- Add support for `meta` option for `fail_input!`, `fail_internal!` and `fail_output!` methods [\#173](https://github.com/servactory/servactory/pull/173) ([afuno](https://github.com/afuno))

**Fixed:**

- Fix mock call [\#191](https://github.com/servactory/servactory/pull/191) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 20.03.2024 [\#190](https://github.com/servactory/servactory/pull/190) ([afuno](https://github.com/afuno))

## [v2.3.1](https://github.com/servactory/servactory/tree/v2.3.1) (2024-03-22)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.3.0...v2.3.1)

## [v2.3.0](https://github.com/servactory/servactory/tree/v2.3.0) (2024-03-06)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.3...v2.3.0)

**Breaking changes:**

- Rename exception classes and configs [\#163](https://github.com/servactory/servactory/pull/163) ([afuno](https://github.com/afuno))

## [v2.2.3](https://github.com/servactory/servactory/tree/v2.2.3) (2024-03-05)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.2...v2.2.3)

**Fixed:**

- Fix inheritance of `internal_option_helpers` and `output_option_helpers` configurations [\#177](https://github.com/servactory/servactory/pull/177) ([afuno](https://github.com/afuno))

## [v2.2.2](https://github.com/servactory/servactory/tree/v2.2.2) (2024-03-01)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.1...v2.2.2)

**Fixed:**

- Delete previously added exceptions for `NoMethodError` and `NameError` [\#172](https://github.com/servactory/servactory/pull/172) ([afuno](https://github.com/afuno))
- Simplify error texts for `NoMethodError` and `NameError` exceptions [\#171](https://github.com/servactory/servactory/pull/171) ([afuno](https://github.com/afuno))

## [v2.2.1](https://github.com/servactory/servactory/tree/v2.2.1) (2024-02-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.0...v2.2.1)

**Fixed:**

- Add default value for `type` in `Failure` [\#170](https://github.com/servactory/servactory/pull/170) ([afuno](https://github.com/afuno))

## [v2.2.0](https://github.com/servactory/servactory/tree/v2.2.0) (2024-02-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.0.rc4...v2.2.0)

**Implemented enhancements:**

- Add example of service behavior when calling `fail!` before assigning `output` [\#167](https://github.com/servactory/servactory/pull/167) ([afuno](https://github.com/afuno))
- Prevent overwriting reserved methods [\#166](https://github.com/servactory/servactory/pull/166) ([afuno](https://github.com/afuno))
- Added tests to check async work [\#165](https://github.com/servactory/servactory/pull/165) ([afuno](https://github.com/afuno))
- Add `success!` method for early success [\#162](https://github.com/servactory/servactory/pull/162) ([afuno](https://github.com/afuno))
- Add `outputs` attribute for `on_success` [\#161](https://github.com/servactory/servactory/pull/161) ([afuno](https://github.com/afuno))
- Move error translations to separate place [\#159](https://github.com/servactory/servactory/pull/159) ([afuno](https://github.com/afuno))
- Add helper support for `internal` and `output` [\#158](https://github.com/servactory/servactory/pull/158) ([afuno](https://github.com/afuno))
- Add support for `on_success` and `on_failure` methods for `Result` [\#155](https://github.com/servactory/servactory/pull/155) ([afuno](https://github.com/afuno))
- Add support for `type` option for `fail!` method [\#154](https://github.com/servactory/servactory/pull/154) ([afuno](https://github.com/afuno))
- Add support for `inclusion` option for `internal` and `output` [\#153](https://github.com/servactory/servactory/pull/153) ([afuno](https://github.com/afuno))
- Improve examples in tests [\#152](https://github.com/servactory/servactory/pull/152) ([afuno](https://github.com/afuno))
- Improve exception handling and exception texts [\#150](https://github.com/servactory/servactory/pull/150) ([afuno](https://github.com/afuno))
- Add support for `must` option for `output` [\#149](https://github.com/servactory/servactory/pull/149) ([afuno](https://github.com/afuno))
- Add support for `must` option for `internal` [\#148](https://github.com/servactory/servactory/pull/148) ([afuno](https://github.com/afuno))
- Add support for nested types for `consists_of` option [\#142](https://github.com/servactory/servactory/pull/142) ([afuno](https://github.com/afuno))

**Fixed:**

- Added passing `type` inside `fail_result!` [\#169](https://github.com/servactory/servactory/pull/169) ([afuno](https://github.com/afuno))
- Add configs and examples for helper options [\#168](https://github.com/servactory/servactory/pull/168) ([afuno](https://github.com/afuno))

**Merged pull requests:**

- Add support for Rails versions from 4.2 to 5.2 [\#151](https://github.com/servactory/servactory/pull/151) ([afuno](https://github.com/afuno))

## [v2.2.0.rc4](https://github.com/servactory/servactory/tree/v2.2.0.rc4) (2024-02-27)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.0.rc3...v2.2.0.rc4)

## [v2.2.0.rc3](https://github.com/servactory/servactory/tree/v2.2.0.rc3) (2024-02-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.0.rc2...v2.2.0.rc3)

## [v2.2.0.rc2](https://github.com/servactory/servactory/tree/v2.2.0.rc2) (2024-02-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.2.0.rc1...v2.2.0.rc2)

**Fixed:**

- Fix data definition for `as_success` method in `Result` [\#164](https://github.com/servactory/servactory/pull/164) ([afuno](https://github.com/afuno))

## [v2.2.0.rc1](https://github.com/servactory/servactory/tree/v2.2.0.rc1) (2024-02-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.1.1...v2.2.0.rc1)

**Dependencies:**

- \[03.02.2024\] Update libraries [\#157](https://github.com/servactory/servactory/pull/157) ([afuno](https://github.com/afuno))

## [v2.1.1](https://github.com/servactory/servactory/tree/v2.1.1) (2024-01-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.1.0...v2.1.1)

**Implemented enhancements:**

- Add support for Ruby 3.3 [\#146](https://github.com/servactory/servactory/pull/146) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 10.01.2024 [\#147](https://github.com/servactory/servactory/pull/147) ([afuno](https://github.com/afuno))

## [v2.1.0](https://github.com/servactory/servactory/tree/v2.1.0) (2023-12-18)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.4...v2.1.0)

**Implemented enhancements:**

- Delete `value` from `input` in favor of local definition [\#145](https://github.com/servactory/servactory/pull/145) ([afuno](https://github.com/afuno))
- Single validation for all attributes [\#143](https://github.com/servactory/servactory/pull/143) ([afuno](https://github.com/afuno))
- Cataloging of examples and tests [\#140](https://github.com/servactory/servactory/pull/140) ([afuno](https://github.com/afuno))
- Add `fail_result!` method [\#139](https://github.com/servactory/servactory/pull/139) ([afuno](https://github.com/afuno))

**Fixed:**

- Fix definition of input value [\#144](https://github.com/servactory/servactory/pull/144) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 12.12.2023 [\#138](https://github.com/servactory/servactory/pull/138) ([afuno](https://github.com/afuno))
- Update libraries from 16.12.2023 [\#141](https://github.com/servactory/servactory/pull/141) ([afuno](https://github.com/afuno))

## [v2.0.4](https://github.com/servactory/servactory/tree/v2.0.4) (2023-12-18)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.3...v2.0.4)

## [v2.0.3](https://github.com/servactory/servactory/tree/v2.0.3) (2023-11-16)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.2...v2.0.3)

**Implemented enhancements:**

- Optimize adding options to `input`, `internal` and `output` attributes [\#137](https://github.com/servactory/servactory/pull/137) ([afuno](https://github.com/afuno))

## [v2.0.2](https://github.com/servactory/servactory/tree/v2.0.2) (2023-11-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.1...v2.0.2)

**Implemented enhancements:**

- Improve work of types in collection mode [\#135](https://github.com/servactory/servactory/pull/135) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 13.11.2023 [\#136](https://github.com/servactory/servactory/pull/136) ([afuno](https://github.com/afuno))

## [v2.0.1](https://github.com/servactory/servactory/tree/v2.0.1) (2023-11-05)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.7...v2.0.1)

**Breaking changes:**

- Delete `inputs`, `internals` and `outputs` aliases [\#131](https://github.com/servactory/servactory/pull/131) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Fix method name [\#133](https://github.com/servactory/servactory/pull/133) ([afuno](https://github.com/afuno))
- Minor improvements in code [\#132](https://github.com/servactory/servactory/pull/132) ([afuno](https://github.com/afuno))

**Dependencies:**

- Add support for Rails 7.1 [\#134](https://github.com/servactory/servactory/pull/134) ([afuno](https://github.com/afuno))

## [v1.9.7](https://github.com/servactory/servactory/tree/v1.9.7) (2023-11-03)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.0.rc6...v1.9.7)

## [v2.0.0.rc6](https://github.com/servactory/servactory/tree/v2.0.0.rc6) (2023-10-29)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.0.rc5...v2.0.0.rc6)

## [v2.0.0.rc5](https://github.com/servactory/servactory/tree/v2.0.0.rc5) (2023-10-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.0.rc4...v2.0.0.rc5)

## [v2.0.0.rc4](https://github.com/servactory/servactory/tree/v2.0.0.rc4) (2023-10-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.0.rc3...v2.0.0.rc4)

**Breaking changes:**

- Change names of configs for Actions [\#127](https://github.com/servactory/servactory/pull/127) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Fix config usage [\#128](https://github.com/servactory/servactory/pull/128) ([afuno](https://github.com/afuno))
- Improve structure and naming of Actions [\#126](https://github.com/servactory/servactory/pull/126) ([afuno](https://github.com/afuno))
- Implement advanced mode support for hash mode [\#125](https://github.com/servactory/servactory/pull/125) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 28.10.2023 [\#124](https://github.com/servactory/servactory/pull/124) ([afuno](https://github.com/afuno))
- Update libraries from 20.10.2023 [\#123](https://github.com/servactory/servactory/pull/123) ([afuno](https://github.com/afuno))

## [v2.0.0.rc3](https://github.com/servactory/servactory/tree/v2.0.0.rc3) (2023-10-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.0.rc2...v2.0.0.rc3)

**Implemented enhancements:**

- Improvements for collections and code optimization [\#122](https://github.com/servactory/servactory/pull/122) ([afuno](https://github.com/afuno))

## [v2.0.0.rc2](https://github.com/servactory/servactory/tree/v2.0.0.rc2) (2023-10-17)

[Full Changelog](https://github.com/servactory/servactory/compare/v2.0.0.rc1...v2.0.0.rc2)

**Implemented enhancements:**

- Implement work with Hash [\#121](https://github.com/servactory/servactory/pull/121) ([afuno](https://github.com/afuno))

## [v2.0.0.rc1](https://github.com/servactory/servactory/tree/v2.0.0.rc1) (2023-10-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.6...v2.0.0.rc1)

**Breaking changes:**

- Implement new way of working with collections [\#120](https://github.com/servactory/servactory/pull/120) ([afuno](https://github.com/afuno))
- Refuse `required` option from `internal` [\#116](https://github.com/servactory/servactory/pull/116) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Add support for extensions [\#118](https://github.com/servactory/servactory/pull/118) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 07.10.2023 [\#119](https://github.com/servactory/servactory/pull/119) ([afuno](https://github.com/afuno))
- Update libraries from 11.09.2023 [\#115](https://github.com/servactory/servactory/pull/115) ([afuno](https://github.com/afuno))

## [v1.9.6](https://github.com/servactory/servactory/tree/v1.9.6) (2023-10-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.5...v1.9.6)

## [v1.9.5](https://github.com/servactory/servactory/tree/v1.9.5) (2023-08-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.4...v1.9.5)

**Implemented enhancements:**

- Optimize Input when working with `option_helpers` [\#113](https://github.com/servactory/servactory/pull/113) ([afuno](https://github.com/afuno))
- Add `only` and `except` support for `inputs`, `internals` and `outputs` [\#111](https://github.com/servactory/servactory/pull/111) ([afuno](https://github.com/afuno))
- Improve storage method naming [\#110](https://github.com/servactory/servactory/pull/110) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 19.08.2023 [\#114](https://github.com/servactory/servactory/pull/114) ([afuno](https://github.com/afuno))
- Update libraries from 05.08.2023 [\#112](https://github.com/servactory/servactory/pull/112) ([afuno](https://github.com/afuno))

## [v1.9.4](https://github.com/servactory/servactory/tree/v1.9.4) (2023-07-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.3...v1.9.4)

**Implemented enhancements:**

- Add `context` attribute to `wrap_in` [\#109](https://github.com/servactory/servactory/pull/109) ([afuno](https://github.com/afuno))

## [v1.9.3](https://github.com/servactory/servactory/tree/v1.9.3) (2023-07-27)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.2...v1.9.3)

**Implemented enhancements:**

- Improve errors about undefined attributes [\#107](https://github.com/servactory/servactory/pull/107) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 27.07.2023 [\#108](https://github.com/servactory/servactory/pull/108) ([afuno](https://github.com/afuno))

## [v1.9.2](https://github.com/servactory/servactory/tree/v1.9.2) (2023-07-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.1...v1.9.2)

**Fixed:**

- Fix definition of inputs when passing from params [\#106](https://github.com/servactory/servactory/pull/106) ([afuno](https://github.com/afuno))

## [v1.9.1](https://github.com/servactory/servactory/tree/v1.9.1) (2023-07-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.9.0...v1.9.1)

**Fixed:**

- Fix definition of inputs when passing from params [\#105](https://github.com/servactory/servactory/pull/105) ([afuno](https://github.com/afuno))

## [v1.9.0](https://github.com/servactory/servactory/tree/v1.9.0) (2023-07-20)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.8...v1.9.0)

**Breaking changes:**

- Improve work with `Servactory::TestKit::Result` [\#104](https://github.com/servactory/servactory/pull/104) ([afuno](https://github.com/afuno))

## [v1.8.8](https://github.com/servactory/servactory/tree/v1.8.8) (2023-07-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.7...v1.8.8)

**Implemented enhancements:**

- Change work with configuration [\#102](https://github.com/servactory/servactory/pull/102) ([afuno](https://github.com/afuno))
- Add new locale [\#101](https://github.com/servactory/servactory/pull/101) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 20.07.2023 [\#103](https://github.com/servactory/servactory/pull/103) ([afuno](https://github.com/afuno))

## [v1.8.7](https://github.com/servactory/servactory/tree/v1.8.7) (2023-07-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.6...v1.8.7)

**Implemented enhancements:**

- Add optionality for `inclusion` in `input` [\#100](https://github.com/servactory/servactory/pull/100) ([afuno](https://github.com/afuno))
- Add custom message for `call` method [\#98](https://github.com/servactory/servactory/pull/98) ([afuno](https://github.com/afuno))

## [v1.8.6](https://github.com/servactory/servactory/tree/v1.8.6) (2023-07-04)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.5...v1.8.6)

**Implemented enhancements:**

- Add `only_unless` for `stage` [\#96](https://github.com/servactory/servactory/pull/96) ([afuno](https://github.com/afuno))
- Delete conflict checking [\#95](https://github.com/servactory/servactory/pull/95) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 04.07.2023 [\#97](https://github.com/servactory/servactory/pull/97) ([afuno](https://github.com/afuno))

## [v1.8.5](https://github.com/servactory/servactory/tree/v1.8.5) (2023-06-29)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.4...v1.8.5)

**Implemented enhancements:**

- Add query attributes [\#94](https://github.com/servactory/servactory/pull/94) ([afuno](https://github.com/afuno))

## [v1.8.4](https://github.com/servactory/servactory/tree/v1.8.4) (2023-06-29)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.3...v1.8.4)

**Fixed:**

- Safely getting data from internals and outputs [\#93](https://github.com/servactory/servactory/pull/93) ([afuno](https://github.com/afuno))

## [v1.8.3](https://github.com/servactory/servactory/tree/v1.8.3) (2023-06-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.2...v1.8.3)

**Fixed:**

- Improve data processing and performance [\#92](https://github.com/servactory/servactory/pull/92) ([afuno](https://github.com/afuno))

## [v1.8.2](https://github.com/servactory/servactory/tree/v1.8.2) (2023-06-28)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.1...v1.8.2)

**Implemented enhancements:**

- Steep and RBS [\#89](https://github.com/servactory/servactory/pull/89) ([afuno](https://github.com/afuno))

**Fixed:**

- Add check for presence of attributes [\#91](https://github.com/servactory/servactory/pull/91) ([afuno](https://github.com/afuno))

**Documentation:**

- Move documentation to separate repository [\#90](https://github.com/servactory/servactory/pull/90) ([afuno](https://github.com/afuno))

## [v1.8.1](https://github.com/servactory/servactory/tree/v1.8.1) (2023-06-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.8.0...v1.8.1)

**Implemented enhancements:**

- Improve input options [\#88](https://github.com/servactory/servactory/pull/88) ([afuno](https://github.com/afuno))
- Improve result [\#87](https://github.com/servactory/servactory/pull/87) ([afuno](https://github.com/afuno))
- Improve display of attributes in IDE [\#86](https://github.com/servactory/servactory/pull/86) ([afuno](https://github.com/afuno))

## [v1.8.0](https://github.com/servactory/servactory/tree/v1.8.0) (2023-06-20)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.7.1...v1.8.0)

**Breaking changes:**

- Rename `method_shortcuts` to `shortcuts_for_make` [\#83](https://github.com/servactory/servactory/pull/83) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Add alias support for `make` [\#82](https://github.com/servactory/servactory/pull/82) ([afuno](https://github.com/afuno))

**Fixed:**

- Improve result of service [\#81](https://github.com/servactory/servactory/pull/81) ([afuno](https://github.com/afuno))

**Documentation:**

- Create documentation version 1.7 [\#85](https://github.com/servactory/servactory/pull/85) ([afuno](https://github.com/afuno))
- Add generator for CHANGELOG.md [\#80](https://github.com/servactory/servactory/pull/80) ([afuno](https://github.com/afuno))

## [v1.7.1](https://github.com/servactory/servactory/tree/v1.7.1) (2023-06-18)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.7.0...v1.7.1)

**Implemented enhancements:**

- Add `error` method and update examples [\#79](https://github.com/servactory/servactory/pull/79) ([afuno](https://github.com/afuno))

## [v1.7.0](https://github.com/servactory/servactory/tree/v1.7.0) (2023-06-17)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.14...v1.7.0)

**Breaking changes:**

- Rewrite work with attributes and improve performance [\#76](https://github.com/servactory/servactory/pull/76) ([afuno](https://github.com/afuno))

**Documentation:**

- Add analytics to documentation [\#75](https://github.com/servactory/servactory/pull/75) ([afuno](https://github.com/afuno))

## [v1.6.14](https://github.com/servactory/servactory/tree/v1.6.14) (2023-06-16)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.13...v1.6.14)

**Implemented enhancements:**

- Rename `Test` to `TestKit` [\#73](https://github.com/servactory/servactory/pull/73) ([afuno](https://github.com/afuno))
- Add ability to get information about class [\#72](https://github.com/servactory/servactory/pull/72) ([afuno](https://github.com/afuno))

**Documentation:**

- Update sections in documentation [\#74](https://github.com/servactory/servactory/pull/74) ([afuno](https://github.com/afuno))

## [v1.6.13](https://github.com/servactory/servactory/tree/v1.6.13) (2023-06-14)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.12...v1.6.13)

**Fixed:**

- Improve functionality [\#71](https://github.com/servactory/servactory/pull/71) ([afuno](https://github.com/afuno))

## [v1.6.12](https://github.com/servactory/servactory/tree/v1.6.12) (2023-06-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.11...v1.6.12)

**Fixed:**

- Fix variable definition [\#70](https://github.com/servactory/servactory/pull/70) ([afuno](https://github.com/afuno))

## [v1.6.11](https://github.com/servactory/servactory/tree/v1.6.11) (2023-06-13)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.10...v1.6.11)

**Fixed:**

- Fix conflict between input and output [\#69](https://github.com/servactory/servactory/pull/69) ([afuno](https://github.com/afuno))

## [v1.6.10](https://github.com/servactory/servactory/tree/v1.6.10) (2023-06-12)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.9...v1.6.10)

**Implemented enhancements:**

- Add `only_if` method for `stage` [\#68](https://github.com/servactory/servactory/pull/68) ([afuno](https://github.com/afuno))
- Update examples [\#66](https://github.com/servactory/servactory/pull/66) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 12.06.2023 [\#67](https://github.com/servactory/servactory/pull/67) ([afuno](https://github.com/afuno))

## [v1.6.9](https://github.com/servactory/servactory/tree/v1.6.9) (2023-06-11)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.8...v1.6.9)

**Implemented enhancements:**

- Add `prepare` option to `input` [\#65](https://github.com/servactory/servactory/pull/65) ([afuno](https://github.com/afuno))

## [v1.6.8](https://github.com/servactory/servactory/tree/v1.6.8) (2023-06-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.7...v1.6.8)

**Implemented enhancements:**

- Add custom helpers for `input` [\#63](https://github.com/servactory/servactory/pull/63) ([afuno](https://github.com/afuno))

**Documentation:**

- Add and update texts in documentation [\#64](https://github.com/servactory/servactory/pull/64) ([afuno](https://github.com/afuno))

## [v1.6.7](https://github.com/servactory/servactory/tree/v1.6.7) (2023-06-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.6...v1.6.7)

**Fixed:**

- Improve work and prepare tools for testing [\#62](https://github.com/servactory/servactory/pull/62) ([afuno](https://github.com/afuno))

## [v1.6.6](https://github.com/servactory/servactory/tree/v1.6.6) (2023-06-10)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.5...v1.6.6)

**Implemented enhancements:**

- Add helpers for `input` [\#61](https://github.com/servactory/servactory/pull/61) ([afuno](https://github.com/afuno))

**Documentation:**

- Improve examples in documentation and repository [\#60](https://github.com/servactory/servactory/pull/60) ([afuno](https://github.com/afuno))

## [v1.6.5](https://github.com/servactory/servactory/tree/v1.6.5) (2023-06-06)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.4...v1.6.5)

**Implemented enhancements:**

- Add `stage` with `wrap_in` and `rollback` support [\#58](https://github.com/servactory/servactory/pull/58) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update libraries from 03.06.2023 [\#57](https://github.com/servactory/servactory/pull/57) ([afuno](https://github.com/afuno))

**Documentation:**

- Move documentation site from `docs` to `website` [\#56](https://github.com/servactory/servactory/pull/56) ([afuno](https://github.com/afuno))

## [v1.6.4](https://github.com/servactory/servactory/tree/v1.6.4) (2023-06-03)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.3...v1.6.4)

**Implemented enhancements:**

- Add `position` option for `make` [\#54](https://github.com/servactory/servactory/pull/54) ([afuno](https://github.com/afuno))

**Documentation:**

- Improve examples and texts in documentation [\#55](https://github.com/servactory/servactory/pull/55) ([afuno](https://github.com/afuno))
- Add an example with custom message for `must` [\#53](https://github.com/servactory/servactory/pull/53) ([afuno](https://github.com/afuno))
- Add search [\#52](https://github.com/servactory/servactory/pull/52) ([afuno](https://github.com/afuno))
- Fix typos in Russian documentation [\#47](https://github.com/servactory/servactory/pull/47) ([nikogdanikomu](https://github.com/nikogdanikomu))
- Improve English documentation [\#41](https://github.com/servactory/servactory/pull/41) ([nikogdanikomu](https://github.com/nikogdanikomu))

## [v1.6.3](https://github.com/servactory/servactory/tree/v1.6.3) (2023-05-30)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.2...v1.6.3)

**Implemented enhancements:**

- Improve `internal` behavior for `input` [\#51](https://github.com/servactory/servactory/pull/51) ([afuno](https://github.com/afuno))
- Add use of `call` method if `make` was not used [\#50](https://github.com/servactory/servactory/pull/50) ([afuno](https://github.com/afuno))
- Add `unless` for `make` [\#49](https://github.com/servactory/servactory/pull/49) ([afuno](https://github.com/afuno))
- Rename "check" to "validation" [\#45](https://github.com/servactory/servactory/pull/45) ([afuno](https://github.com/afuno))
- Rename "check" to "validation" [\#43](https://github.com/servactory/servactory/pull/43) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update versions of dependencies from 27.05.2023 [\#40](https://github.com/servactory/servactory/pull/40) ([afuno](https://github.com/afuno))

**Documentation:**

- Add "Advanced mode" examples [\#48](https://github.com/servactory/servactory/pull/48) ([afuno](https://github.com/afuno))
- Add Russian version of documentation [\#46](https://github.com/servactory/servactory/pull/46) ([afuno](https://github.com/afuno))
- Add Russian version of documentation [\#44](https://github.com/servactory/servactory/pull/44) ([afuno](https://github.com/afuno))
- Improve the appearance of documentation [\#42](https://github.com/servactory/servactory/pull/42) ([afuno](https://github.com/afuno))

## [v1.6.2](https://github.com/servactory/servactory/tree/v1.6.2) (2023-05-27)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.6.0...v1.6.2)

**Implemented enhancements:**

- Add method shortcuts [\#38](https://github.com/servactory/servactory/pull/38) ([afuno](https://github.com/afuno))

**Documentation:**

- Apply new documentation [\#39](https://github.com/servactory/servactory/pull/39) ([afuno](https://github.com/afuno))
- Add documentation [\#37](https://github.com/servactory/servactory/pull/37) ([afuno](https://github.com/afuno))

## [v1.6.0](https://github.com/servactory/servactory/tree/v1.6.0) (2023-05-24)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.5.2...v1.6.0)

**Breaking changes:**

- Improve and simplify naming [\#35](https://github.com/servactory/servactory/pull/35) ([afuno](https://github.com/afuno))
- Simplify the use of the `array` option [\#34](https://github.com/servactory/servactory/pull/34) ([afuno](https://github.com/afuno))
- Rework error handling [\#33](https://github.com/servactory/servactory/pull/33) ([afuno](https://github.com/afuno))
- Add support for the `meta` attribute for the `fail!` method [\#31](https://github.com/servactory/servactory/pull/31) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update versions of dependencies from 23.05.2023 [\#36](https://github.com/servactory/servactory/pull/36) ([afuno](https://github.com/afuno))

**Documentation:**

- Add Yard [\#32](https://github.com/servactory/servactory/pull/32) ([afuno](https://github.com/afuno))

## [v1.5.2](https://github.com/servactory/servactory/tree/v1.5.2) (2023-05-21)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.5.1...v1.5.2)

**Implemented enhancements:**

- Add custom message support for `inclusion` option [\#30](https://github.com/servactory/servactory/pull/30) ([afuno](https://github.com/afuno))

## [v1.5.1](https://github.com/servactory/servactory/tree/v1.5.1) (2023-05-20)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.5.0...v1.5.1)

**Fixed:**

- Fix work with input attribute options [\#29](https://github.com/servactory/servactory/pull/29) ([afuno](https://github.com/afuno))

## [v1.5.0](https://github.com/servactory/servactory/tree/v1.5.0) (2023-05-20)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.7...v1.5.0)

**Breaking changes:**

- Use `Make` instead of `Stage` [\#27](https://github.com/servactory/servactory/pull/27) ([afuno](https://github.com/afuno))

**Implemented enhancements:**

- Improve inheritance for attributes and methods [\#26](https://github.com/servactory/servactory/pull/26) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update versions of dependencies from 20.05.2023 [\#28](https://github.com/servactory/servactory/pull/28) ([afuno](https://github.com/afuno))

## [v1.4.7](https://github.com/servactory/servactory/tree/v1.4.7) (2023-05-19)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.6...v1.4.7)

**Implemented enhancements:**

- Add Rails support for use as needed [\#25](https://github.com/servactory/servactory/pull/25) ([afuno](https://github.com/afuno))

## [v1.4.6](https://github.com/servactory/servactory/tree/v1.4.6) (2023-05-16)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.5...v1.4.6)

**Implemented enhancements:**

- Add support for I18n and transfer all texts to the localization file [\#24](https://github.com/servactory/servactory/pull/24) ([afuno](https://github.com/afuno))

## [v1.4.5](https://github.com/servactory/servactory/tree/v1.4.5) (2023-05-15)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.4...v1.4.5)

**Implemented enhancements:**

- Improve syntax for `define_input_conflicts` [\#23](https://github.com/servactory/servactory/pull/23) ([afuno](https://github.com/afuno))
- Improve syntax for `define_input_methods` [\#22](https://github.com/servactory/servactory/pull/22) ([afuno](https://github.com/afuno))
- Uniform style for adding an element to `Set` [\#21](https://github.com/servactory/servactory/pull/21) ([afuno](https://github.com/afuno))
- Add `call` method and statuses to the result [\#18](https://github.com/servactory/servactory/pull/18) ([afuno](https://github.com/afuno))

**Dependencies:**

- Update versions of dependencies from 15.05.2023 [\#20](https://github.com/servactory/servactory/pull/20) ([afuno](https://github.com/afuno))

## [v1.4.4](https://github.com/servactory/servactory/tree/v1.4.4) (2023-05-15)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.3...v1.4.4)

**Implemented enhancements:**

- Add `as` option to override internal input name [\#19](https://github.com/servactory/servactory/pull/19) ([afuno](https://github.com/afuno))
- Use `Set` instead of `Array` [\#17](https://github.com/servactory/servactory/pull/17) ([afuno](https://github.com/afuno))
- Make the `new` method private [\#16](https://github.com/servactory/servactory/pull/16) ([afuno](https://github.com/afuno))

## [v1.4.3](https://github.com/servactory/servactory/tree/v1.4.3) (2023-05-12)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.2...v1.4.3)

**Implemented enhancements:**

- Add methods for failures, improve error handling, improve configuration [\#15](https://github.com/servactory/servactory/pull/15) ([afuno](https://github.com/afuno))

## [v1.4.2](https://github.com/servactory/servactory/tree/v1.4.2) (2023-05-08)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.1...v1.4.2)

**Implemented enhancements:**

- Improve work with attributes [\#14](https://github.com/servactory/servactory/pull/14) ([afuno](https://github.com/afuno))
- Add checks for the class of the returned result [\#13](https://github.com/servactory/servactory/pull/13) ([afuno](https://github.com/afuno))

## [v1.4.1](https://github.com/servactory/servactory/tree/v1.4.1) (2023-05-07)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.4.0...v1.4.1)

**Implemented enhancements:**

- Improve `required` and `types` checks [\#12](https://github.com/servactory/servactory/pull/12) ([afuno](https://github.com/afuno))

**Dependencies:**

- Specify gem versions [\#11](https://github.com/servactory/servactory/pull/11) ([afuno](https://github.com/afuno))

## [v1.4.0](https://github.com/servactory/servactory/tree/v1.4.0) (2023-05-07)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.3.0...v1.4.0)

**Implemented enhancements:**

- Add support for collections of input argument options and add the basis for an "advanced mode" [\#9](https://github.com/servactory/servactory/pull/9) ([afuno](https://github.com/afuno))

**Documentation:**

- Add information to the README [\#10](https://github.com/servactory/servactory/pull/10) ([afuno](https://github.com/afuno))

## [v1.3.0](https://github.com/servactory/servactory/tree/v1.3.0) (2023-05-06)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.2.0...v1.3.0)

**Implemented enhancements:**

- Add advanced mode support for `array` [\#6](https://github.com/servactory/servactory/pull/6) ([afuno](https://github.com/afuno))

**Documentation:**

- Add examples to the README [\#8](https://github.com/servactory/servactory/pull/8) ([afuno](https://github.com/afuno))

**Merged pull requests:**

- Change the workflow for a release [\#7](https://github.com/servactory/servactory/pull/7) ([afuno](https://github.com/afuno))

## [v1.2.0](https://github.com/servactory/servactory/tree/v1.2.0) (2023-05-05)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.1.0...v1.2.0)

**Implemented enhancements:**

- Add support for Ruby 2.7 [\#5](https://github.com/servactory/servactory/pull/5) ([afuno](https://github.com/afuno))
- Add support for Ruby 3.0 [\#4](https://github.com/servactory/servactory/pull/4) ([afuno](https://github.com/afuno))
- Add support for Ruby 3.1 and update error text in `must` [\#3](https://github.com/servactory/servactory/pull/3) ([afuno](https://github.com/afuno))

## [v1.1.0](https://github.com/servactory/servactory/tree/v1.1.0) (2023-05-05)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.0.2...v1.1.0)

**Implemented enhancements:**

- Rename gem to Servactory [\#2](https://github.com/servactory/servactory/pull/2) ([afuno](https://github.com/afuno))

## [v1.0.2](https://github.com/servactory/servactory/tree/v1.0.2) (2023-05-05)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.0.1...v1.0.2)

## [v1.0.1](https://github.com/servactory/servactory/tree/v1.0.1) (2023-05-05)

[Full Changelog](https://github.com/servactory/servactory/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/servactory/servactory/tree/v1.0.0) (2023-05-05)

[Full Changelog](https://github.com/servactory/servactory/compare/47ca7469c935321c36fcc5d956b102c0edc106fd...v1.0.0)

**Implemented enhancements:**

- Prepare the foundation and implement the DSL prototype [\#1](https://github.com/servactory/servactory/pull/1) ([afuno](https://github.com/afuno))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
