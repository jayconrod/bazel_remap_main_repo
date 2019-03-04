def _x_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo()]

x_toolchain = rule(
    implementation = _x_toolchain_impl,
)

def _x_library_impl(ctx):
    pass

x_library = rule(
    implementation = _x_library_impl,
    toolchains = ["@io_bazel_rules_x//:x_toolchain_type"],
)
