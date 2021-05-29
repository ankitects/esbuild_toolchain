import argparse
import hashlib
import fileinput
import subprocess
import urllib.request

# Parse arguments
parser = argparse.ArgumentParser(description='Set checkum in esbuild_repo.bzl file')
parser.add_argument('version', type=str, help='Version argument is required')
args = parser.parse_args()

# Variables
package_name="esbuild-linux-arm64"
file_name="esbuild_repo.bzl"

# Get checksum
contents = urllib.request.urlopen("https://registry.npmjs.org/" + package_name + "/-/" + package_name + "-" + args.version + ".tgz").read()
m = hashlib.sha256(contents)
sha256=m.hexdigest()

# Print to stdout
print('http_archive(')
print('    name = "esbuild_linux_arm64",')
print('    urls = [')
print('        "https://registry.npmjs.org/' + package_name + '/-/' + package_name + '-%s.tgz" % version,"')
print('    ],')
print('    strip_prefix = "package",')
print('    build_file_content = """exports_files(["bin/esbuild"])""",')
print('    sha256 = "' + sha256 + '",')
print(')')