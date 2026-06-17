# Build read-only development storage scanner

## Goal

Implement the first read-only scanner that measures development storage without deleting anything.

## Scope

- Xcode / iOS Simulator storage
- Android / Gradle storage
- Flutter / Dart / FVM storage
- Flutter project artifacts inside selected roots
- mobile package outputs inside configured roots
- CocoaPods storage
- Node / pnpm / npm storage
- HarmonyOS / DevEco candidates
- manual-review large directories

## Acceptance Criteria

- Scanner returns id, path, size, category, toolchain group, detection source, and status.
- Missing paths are reported as `PathNotFound`.
- Permission failures are reported as `PermissionDenied`.
- No cleanup action is executed.
