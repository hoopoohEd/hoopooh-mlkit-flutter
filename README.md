# hoopooh-mlkit-flutter

`google_mlkit_face_detection` and `google_mlkit_commons` built with Swift
Package Manager on iOS instead of CocoaPods, for the hoopooh app's on-device
"Blur faces" step.

## Why this exists

The published plugins pull ML Kit in through CocoaPods. The app builds Firebase
through Swift Package Manager, and the ML Kit pods add second copies of
GoogleUtilities, GoogleDataTransport, FBLPromises and nanopb. iOS then loads 31
Google classes twice at launch. With Swift Package Manager, both share one
copy.

## Provenance

Both packages are copied unchanged from upstream PR
[flutter-ml/google_ml_kit_flutter#890](https://github.com/flutter-ml/google_ml_kit_flutter/pull/890)
(`pumano/google_ml_kit_flutter`, branch `feature/spm-for-all-packages`, commit
`ecc971beefdd565d3f34bd11688b0b555c5955d8`), plugin version 0.14.0 and commons
0.12.0. The PR was still open when this was copied (Oct 2026).

Changes from that commit:
- Both `ios/*/Package.swift` files depend on
  [`hoopooh-mlkit-swiftpm`](https://github.com/hoopoohEd/hoopooh-mlkit-swiftpm)
  (`9.0.0-hoopooh.2`), a trimmed copy of the binary wrapper the PR used.
- Commons depends on the `MLKitVision` product, not `MLKitBarcodeScanning`. The
  barcode product was only there because the PR's wrapper had no vision-only
  product.
- The nested `Package.resolved` pinning the old wrapper was removed.
- Dart, Kotlin and Swift sources are unchanged.

The two packages must stay side by side under `packages/`:
`google_mlkit_face_detection`'s `Package.swift` reaches commons by the relative
path `../../../google_mlkit_commons/ios/google_mlkit_commons`.

## Using it from the app

In the app's `pubspec.yaml`. Commons goes in `dependency_overrides` because
face detection declares `google_mlkit_commons: ^0.12.0` as a hosted dependency;
both must come from the same commit.

```yaml
dependencies:
  google_mlkit_face_detection:
    git:
      url: https://github.com/hoopoohEd/hoopooh-mlkit-flutter
      ref: <commit sha>
      path: packages/google_mlkit_face_detection

dependency_overrides:
  google_mlkit_commons:
    git:
      url: https://github.com/hoopoohEd/hoopooh-mlkit-flutter
      ref: <same commit sha>
      path: packages/google_mlkit_commons
```

The app needs, on iOS:
- Swift Package Manager enabled (`enable-swift-package-manager: true`) and
  iOS 15.5 or later.
- **`GoogleMVFaceDetectorResources.bundle` as an app resource** (Runner target,
  Copy Bundle Resources). ML Kit loads its face models only from the top level
  of the app bundle, and Swift Package Manager cannot put them there. Without
  it, detection silently returns no faces. See the wrapper's README for where
  the bundle comes from.
- **`-ObjC` in the Runner target's Other Linker Flags.** ML Kit is static
  Objective-C, and without the flag category-only object files are dropped:
  it crashes after detection with
  `-[MLKITx_CCTLogContext hashForFilePath]: unrecognized selector`.
  CocoaPods used to add this flag automatically.

## When to drop this

When upstream ships a Swift Package Manager release of
`google_mlkit_face_detection` (PR #890 or a successor), switch back to the
pub.dev package and archive this repo and `hoopooh-mlkit-swiftpm`.

## Licences

MIT, from upstream (see `LICENSE` and each package's `LICENSE`).
