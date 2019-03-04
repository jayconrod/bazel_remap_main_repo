def x_register_toolchains():
    x_sdk(name = "x_sdk")
    native.register_toolchains("@x_sdk//:x_toolchain")

def _x_sdk_impl(ctx):
    ctx.file("WORKSPACE")
    ctx.template("BUILD.bazel", Label("@io_bazel_rules_x//:x_sdk.BUILD.bazel"))

x_sdk = repository_rule(
    implementation = _x_sdk_impl,
)
