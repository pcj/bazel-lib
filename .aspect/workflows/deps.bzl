"""Bazel dependencies for Aspect Workflows"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive", _http_file = "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# TODO: move this to a rule set so repositories on Aspect Workflows can avoid this boilerplate
rosetta_version = "5.9.22"
rosetta_integrity = {
    "darwin_aarch64": "sha256-EXjXWBWQPa2l7QQTz3XbUXo2sz0aPHqxioT+LiOesyw=",
    "darwin_x86_64": "sha256-6+BVUK8oKFNWZtFPW9pSnPvnSd9doDLecNsWdl7zHuk=",
    "linux_aarch64": "sha256-TBHcq62DXuBW2rATy5KGlBmgKnldAT3A6iDSYCt2UBE=",
    "linux_x86_64": "sha256-X4M8I9gBapSkUHlu85/Vi6Gz3qWZv9M06mWW3jAXyfY=",
}

# https://github.com/suzuki-shunsuke/circleci-config-merge/releases
# https://dev.to/suzukishunsuke/splitting-circleci-config-yml-10gk
circleci_config_merge_version = "1.1.6"
circleci_config_merge_integrity = {
    "darwin_aarch64": "sha256-7cQeLrSVRZR+mQu/njn+x//EIb2bhTV2+J8fafRHpr4=",
    "darwin_x86_64": "sha256-vHKDSdDaYK58MaudJ9yOPRKh+OT/LiTQV/9E07RL8qA=",
    "linux_aarch64": "sha256-MaXVQmRK9q9LgsfM5ZzxCIIT8rUcOBbzJ8aVDgK6zWs=",
    "linux_x86_64": "sha256-3eYJn7dShZD1oiS3cgXfqXwdDzclf/N97A2nh7ZfW+w=",
}

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def http_file(name, **kwargs):
    maybe(_http_file, name = name, **kwargs)

# buildifier: disable=function-docstring
def fetch_workflows_deps():
    for platform_arch in rosetta_integrity.keys():
        http_file(
            name = "rosetta_{}".format(platform_arch),
            downloaded_file_path = "rosetta",
            executable = True,
            integrity = rosetta_integrity[platform_arch],
            urls = ["https://static.aspect.build/aspect/{0}/rosetta_real_{1}".format(rosetta_version, platform_arch.replace("aarch64", "arm64"))],
        )

    for platform_arch in circleci_config_merge_integrity.keys():
        http_archive(
            name = "circleci_config_merge_{}".format(platform_arch),
            build_file_content = "exports_files([\"circleci-config-merge\"])",
            integrity = circleci_config_merge_integrity[platform_arch],
            urls = ["https://github.com/suzuki-shunsuke/circleci-config-merge/releases/download/v{0}/circleci-config-merge_{0}_{1}.tar.gz".format(circleci_config_merge_version, platform_arch.replace("aarch64", "arm64").replace("x86_64", "amd64"))],
        )
