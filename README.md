# ImpossaMod

A disassembly and modification of the ZX Spectrum version of the Impossamole game by Core Design.

## Build

Build with [`sjasmplus`](https://github.com/z00m128/sjasmplus).

### Create build directory

```sh
mkdir build
```

### Check disassembly correctness

```sh
sjasmplus --syntax=b --fullpath=rel --outprefix=build/ src/orig/_main.asm
cmp -b reference/original.tap build/original.tap
```

### Build modified version

```sh
sjasmplus --syntax=b --fullpath=rel --outprefix=build/ --sld=build/impossamod.sld src/_main.asm
```
