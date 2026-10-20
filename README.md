# skiko-patch

[Skiko](https://github.com/JetBrains/skiko)'s native runtimes, built with a few patches.

## The patches

- `0001-registered-fonts-first`: fall back to the fonts an app registers before the system's, in the face nearest
  the text's weight. Without it, text in a font of the app's own draws its emoji and CJK from the machine's fonts
  (Apple Color Emoji and Hiragino on a Mac) instead of the fallbacks the app carries.
- `0002-registered-emoji-first`: the same for emoji on macOS and iOS, where Skia asks for Apple Color Emoji by name
  before it falls back by character: that name is answered with the registered font that draws emoji, when there is
  one.

## What it builds

CI builds, for every push, Skiko's JVM runtime for macOS, Windows and Linux on arm64 and x64, and its wasm runtime,
each as Skiko's own CI does (Linux in Skiko's Docker image, wasm with the Emscripten it names). For a tag,
`v<skiko version>-<revision>`, it releases them as Skiko publishes them, with their SHA-256 sums, and removes that
Skiko's earlier revisions, so each Skiko version has one release:

- `skiko-awt-runtime-<os>-<arch>-<version>.jar`: the native library and its `.sha256`, which Skiko names its
  unpacked copy after, so it never mixes with the stock one.
- `skiko-js-wasm-runtime-<version>.jar`: `skiko.wasm` and its JavaScript.

Only the native code changes, so these replace Skiko's runtime artifacts of the same version, beside its unchanged
Kotlin libraries.

## Building locally

```
git submodule update --init
./apply-patches.sh
cd skiko && ./gradlew -Pdeploy.version=$(cat ../skiko-version) -Pdeploy.release=true :skiko:skikoJvmRuntimeJarMacosArm64
```

The jar is in `skiko/skiko/build/libs/`. A Mac needs the Xcode command line tools; Windows, Visual Studio Build Tools
and LLVM (`clang-cl`); Linux, the packages in `skiko/skiko/docker/linux-compat`. `git -C skiko checkout -- .` undoes
the patches.

## Skiko versions

Each Skiko version has a branch, `skiko-<version>`, with the submodule at Skiko's tag for it, and its releases are
tagged on that branch; there is no other. `./new-version.sh <version>` makes the branch from the one checked out (the
newest Skiko's) and checks that the patches apply; push it, then tag `v<version>-1`. A change to the build or the
patches is made on every branch it applies to. When a patch no longer applies, fix it by hand on the branch,
`git -C skiko diff > patches/<name>.patch`, and put its description back on top.

## License

Skiko and the patches to it are under the Apache License 2.0, as Skiko is.
