def _esbuild_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(
        binary = ctx.executable.binary,
    )]

esbuild_toolchain = rule(
    implementation = _esbuild_toolchain_impl,
    attrs = {
        "binary": attr.label(allow_single_file = True, executable = True, cfg = "exec"),
    },
)

TOOLCHAIN = "@esbuild_toolchain//:toolchain_type"

_default_toolchains = [
    ["@esbuild_darwin//:bin/esbuild", "macos"],
    ["@esbuild_linux//:bin/esbuild", "linux"],
    ["@esbuild_linux_arm64//:bin/esbuild", "linux_arm64"],
    ["@esbuild_windows//:esbuild.exe", "windows"],
]

def define_default_toolchains():
    for repo_path, platform in _default_toolchains:
        esbuild_toolchain(
            name = "esbuild_" + platform,
            binary = repo_path,
        )

        if platform != "linux_arm64":
            native.toolchain(
                name = "esbuild_{}_toolchain".format(platform),
                exec_compatible_with = [
                    "@platforms//os:" + platform,
                    "@platforms//cpu:x86_64",
                ],
                toolchain = ":esbuild_" + platform,
                toolchain_type = ":toolchain_type",
            )
            
        else:
            native.toolchain(
                name = "esbuild_{}_toolchain".format(platform),
                exec_compatible_with = [
                    "@platforms//os:linux",
                    "@platforms//cpu:arm64",
                ],
                toolchain = ":esbuild_" + platform,
                toolchain_type = ":toolchain_type",
            )

def register_default_toolchains():
    for _, platform in _default_toolchains:
        native.register_toolchains("@esbuild_toolchain//:esbuild_{}_toolchain".format(platform))
