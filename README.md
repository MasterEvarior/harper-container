# harper-container

> [!WARNING]
> This is not an official image

A Nix-built Docker image that packages [`harper-cli`](https://writewithharper.com) as a portable grammar and spell checker for Typst, Markdown, and other text files. Mainly for me to use as a spell checker in CI.

## Usage

Lint a file by mounting it into the container:

```bash
docker run --rm \
  -v "$(pwd)/document.typ:/lint_target" \
  ghcr.io/masterevarior/harper:latest lint /lint_target
```

`harper-cli` is the image entrypoint, so any subcommand works:

```bash
docker run --rm ghcr.io/masterevarior/harper:latest --help
```

## Development

Requires [Nix](https://nixos.org), [just](https://just.systems) and an installed container runtime.

See all available recipes:

```shell
just
```
