[doc('List all available recipes')]
default:
    just --list

alias b := build
[doc('Build image')]
[group('build')]
build:
    nix build

alias bl := build-and-load
[doc('Build and load image')]
[group('build')]
build-and-load:
    nix build
    docker load < result

alias v := version
[doc('Get the version of harper-cli')]
[group('build')]
version:
    @nix build .#version > /dev/null 2>&1
    @cat result

alias t := tag
[doc('Get the tag of the generated OCI image')]
[group('build')]
tag:
    @nix build .#image-tag > /dev/null 2>&1
    @cat result

alias l := lint
[doc('Run nix fmt')]
[group('lint')]
lint:
    nix fmt

[doc('Run some basic tests')]
[group('test')]
test IMAGE="$(just tag)":
    {{justfile_directory()}}/test/test.sh {{IMAGE}} {{justfile_directory()}}/test/test.typ

[doc('Run some basic tests')]
[group('test')]
build-and-test IMAGE="$(just tag)": build-and-load
    {{justfile_directory()}}/test/test.sh {{IMAGE}} {{justfile_directory()}}/test/test.typ 