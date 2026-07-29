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

alias l := lint
[doc('Run nix fmt')]
[group('lint')]
lint:
    nix fmt