# Changelog

## 0.1.0 - 2026-05-27

First public development release of OpenScrobbler.

### Added

- Native macOS SwiftUI app shell with menu bar controls, settings, diagnostics, launch-at-login, and proxy configuration.
- ListenBrainz account setup, token validation, now-playing submission, and completed listen submission.
- Offline queueing with retry state across submission backends.
- ListenBrainz archive surfaces for recent listens, top artists, top releases, top recordings, listening activity, and social discovery experiments.
- MusicBrainz metadata lookup for recordings, artists, releases, MBIDs, tags, and related links.
- Local-first shared music and obsession vaults with portable import/export.
- App icon and menu bar artwork refresh.
- Deterministic tests for core submission, queue, ListenBrainz, MusicBrainz, and vault behavior.

### Changed

- Removed product-facing legacy service naming in favor of ListenBrainz, MusicBrainz, listens, people, and compatibility-provider terminology.
- Replaced Keychain-based ListenBrainz token storage with app-owned local token storage to avoid repeated macOS permission prompts during development builds.
- Regenerated the Xcode project from `project.yml`.

### Known Gaps

- Some orchestration still uses migration-era names such as `ScrobbleService`.
- Compatibility-provider adapter code remains transitional and should continue shrinking behind provider-neutral domain models.
- Social and profile surfaces need further ListenBrainz and MusicBrainz hardening before a stable release.
