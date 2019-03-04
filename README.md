This repository minimally reproduces an error I'm seeing with
`bazel --incompatible_remap_main_repo` in Bazel 0.24.0rc2:

```
$ bazel --incompatible_remap_main_repo :x_library
Loading: 
Loading: 0 packages loaded
INFO: Build option --toolchain_resolution_debug has changed, discarding analysis cache.
Analyzing: target //:x_library (0 packages loaded, 0 targets configured)
ERROR: While resolving toolchains for target //:x_library: no matching toolchains found for types @io_bazel_rules_x//:x_toolchain_type
ERROR: Analysis of target '//:x_library' failed; build aborted: no matching toolchains found for types @io_bazel_rules_x//:x_toolchain_type
INFO: Elapsed time: 0.098s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded, 28 targets configured)
FAILED: Build did NOT complete successfully (0 packages loaded, 28 targets configured)
```

The target `//:x_library` is an instance of the `x_library` rule, defined in
`def.bzl`. `x_library` requires a toolchain of type
`@io_bazel_rules_x//:x_toolchain_type`.

The WORKSPACE for this repository declares an external repo, `x_sdk` with the
build file `x_sdk.BUILD.bazel`. This build file declares `x_toolchain_impl`, a
`x_toolchain` target (loaded from `@io_bazel_rules_x//:def.bzl`) and
`x_toolchain`, a
`toolchain` target for `x_toolchain_impl` with type
`@io_bazel_rules_x//:x_toolchain_type`. The WORKSPACE for this repository
calls `register_toolchains("@x_sdk//:x_toolchain")`.

My expectation is that `//:x_library` will use the toolchain
`@x_sdk//:x_toolchain`. This seems to work without the flag. When the flag is
on, it's as if the toolchain doesn't exist. When `--toolchain_resolution_debug`
is given, it's as if the toolchain doesn't exist.
