# OpenScrobbler Roadmap

This roadmap replaces the earlier "clean home" placeholder state with an execution plan based on the code currently present in this repository.

The short version:

- The app already has a functional macOS shell, queueing, menu bar workflow, local-first vault features, and a first ListenBrainz integration.
- The product is now recognizably aligned with the ListenBrainz-first repository vision.
- The main remaining work is to finish the architecture migration into an OpenScrobbler domain built around ListenBrainz, MusicBrainz, and portable user-owned listening data.

## Product Goal

OpenScrobbler should become the native desktop home for open listening history:

- ListenBrainz-first for account, submission, charts, recent listens, profile context, playlists, pins, recommendations, and open social discovery.
- MusicBrainz-aware for portable identifiers and cleaner metadata.
- Local-first for resilience, memory features, exports, and user ownership.
- Temporary migration shims only where they are still needed, with the end state clearly centered on ListenBrainz, MusicBrainz, and portable local data.

## Current State

### Already working

- Native macOS app shell with window, settings, menu bar extra, launch-at-login, and proxy support.
- Track monitoring, scrobble thresholds, queue persistence, retry behavior, and diagnostics.
- ListenBrainz token validation and native JSON submission for now playing and completed listens.
- ListenBrainz archive charts for recent listens, top artists, top recordings, top releases, and total listen count.
- Shared and Obsessions vaults with local persistence and portable import/export.
- Build succeeds and the current test suite passes.

### Not yet aligned with the intended product

- Core orchestration still exposes some migration-era models and naming.
- Social/profile/detail flows need continued ListenBrainz and MusicBrainz hardening.
- Queue and storage migration is incomplete; some paths still use legacy `LegacyOpenScrobbler` naming.
- ListenBrainz support is useful but still incomplete relative to the product vision.
- Test coverage is decent for the baseline but not yet strong enough for a broad migration.
- The current app icon works as a placeholder, but it does not yet feel distinctive or premium.

## Guiding Principles

1. Finish the architecture migration before stacking too many surface-level features.
2. Make ListenBrainz the primary backend and retire legacy service-shaped assumptions from the app surface.
3. Keep local-first resilience as a core product value, not an optional extra.
4. Prefer portable identifiers and stable domain models over service-specific terminology.
5. Expand only behind tests, fixtures, and deterministic infrastructure.
6. Use design polish to clarify the product direction, not merely decorate it.

## Phase 1: Identity And Domain Migration

### Goals

- Remove the remaining technical identity drift from compatibility-provider structures.
- Introduce a provider-neutral domain model that the rest of the app can build on.

### Deliverables

- Replace remaining legacy storage paths and migration leftovers with `OpenScrobbler` identities.
- Add migration code so existing users keep queue, vault, and account data.
- Introduce domain-first models such as:
  - `Listen`
  - `Recording`
  - `Release`
  - `Artist`
  - `User`
  - `Connection`
  - `Playlist`
- Reduce direct `Compatibility*` model exposure from the main app layer.
- Split backend adapters from app-facing view models and orchestration.
- Make queue logic backend-neutral by default, while still supporting per-backend state.

### Acceptance criteria

- No new persistence written into legacy compatibility paths.
- The app can read legacy state and rewrite it into the new structure.
- New features can be added without introducing compatibility-provider-specific types into the app shell.

## Phase 2: ListenBrainz As Primary Backend

### Goals

- Move from "ListenBrainz integration" to "ListenBrainz-led product behavior".

### Deliverables

- Expand `ListenBrainzService` to support:
  - profile/user context
  - richer recent listens
  - playlists
  - pins
  - follow relationships
  - recommendation surfaces
  - metadata lookup hooks and MBID hydration
- Add robust caching and refresh policies for archive data.
- Expand queue and diagnostics to clearly show per-backend success and failure states.
- Add self-hosted / compatible endpoint validation hardening.
- Improve error handling and user guidance around invalid token, disabled scopes, network failures, and partial data.

### Acceptance criteria

- A connected ListenBrainz account can drive the main archive experience.
- Now playing, completed listen submission, charts, and recent listens feel like one coherent backend, not an add-on.
- Queue behavior is stable under partial backend outages.

## Phase 3: Open Social Discovery

### Goals

- Rebuild social discovery around ListenBrainz-compatible and open-data concepts.

### Deliverables

- Replace compatibility-provider "profile/friends/neighbours/subscriber" framing in the main UI with:
  - public listening overlap
  - follows / follow graph
  - related users or discovery candidates
  - recommendation-driven exploration
  - graph-based local analysis
- Add a dedicated social discovery surface driven by:
  - ListenBrainz relationships when available
  - public listen overlap heuristics
  - local graph analysis and memory context
- Introduce recommendation cards and person-to-person archive context.
- Do not reintroduce legacy service vocabulary into primary navigation, naming, or feature framing.

### Acceptance criteria

- Social discovery is understandable without legacy provider vocabulary.
- The app has at least one clear ListenBrainz-first discovery flow and one open-data graph exploration flow.

## Phase 4: MusicBrainz And Metadata Enrichment

### Goals

- Make the archive more portable and semantically clean.

### Deliverables

- Store MBIDs whenever possible for artist, recording, and release entities.
- Add best-effort enrichment for listens that arrive with incomplete metadata.
- Improve deduplication and cross-source merging using identifiers when present.
- Surface metadata quality and provenance in diagnostics where useful.

### Acceptance criteria

- Archive items can carry stable identifiers beyond display strings.
- UI remains forgiving when metadata is partial or unavailable.

## Phase 5: Shared And Obsessions Evolution

### Goals

- Keep local-first memory features, but align them with the open archive direction.

### Deliverables

- Strengthen the current vault model with better filtering, tagging groundwork, and provenance detail.
- Add export pathways that can evolve toward open playlist/list formats.
- Explore ListenBrainz-connected enhancements:
  - export shared bundles as playlist-compatible artifacts
  - optional pin-driven obsession import
  - optional "archive to playlist" pathways
- Keep imports and exports versioned and migration-safe.

### Acceptance criteria

- Vault features remain user-owned and portable.
- Their structure is compatible with future open archive and playlist integration.

## Phase 6: UI And Product Polish

### Goals

- Make the app feel intentionally designed around "open listening history" rather than around a migrated prototype.

### Deliverables

- Refine dashboard and settings language to consistently reflect the ListenBrainz-first product.
- Improve hierarchy and affordances around:
  - queue state
  - backend state
  - archive status
  - discovery
  - local memory features
- Tighten responsive behavior and visual QA across light mode, dark mode, narrow layouts, and large desktop widths.
- Review menu bar workflow for speed and clarity.

### Acceptance criteria

- The app reads as one product, not as a stitched migration.
- Primary tasks are discoverable without knowing the project history.

## Phase 7: Test Overhaul

### Goals

- Make the migration safe and keep the backend expansion maintainable.

### Deliverables

- Add `ListenBrainzService` test coverage for:
  - token validation
  - missing token
  - invalid token
  - HTTP failure mapping
  - `playing_now` payload shape
  - completed listen payload shape
  - stats decoding
  - partial / sparse payloads
  - custom base URL behavior
- Add storage and migration tests for:
  - queue migration from legacy layout
  - vault schema compatibility
  - account storage migration
- Expand `ScrobbleServiceTests` for:
  - dual-backend success/failure combinations
  - partial submission success
  - per-backend retry behavior
  - queue deduplication across backends
  - pause/resume and race conditions
  - offline recovery
  - validation state transitions
- Introduce deterministic test infrastructure:
  - URL loading mocks via `URLProtocol`
  - injectable token store
  - injectable clock/scheduler where timing matters
  - temp-directory-backed persistence
- Add UI tests for:
  - ListenBrainz account setup
  - queue and diagnostics views
  - archive charts loading states
  - vault import/export entry points
- Add snapshot or visual regression coverage for core surfaces if the project adopts a snapshot tool.

### Acceptance criteria

- Critical queue, storage, and backend transitions are covered by deterministic tests.
- Regression risk is materially lower during refactors.

## Phase 8: Icon And Brand Refresh

### Goals

- Replace the current functional placeholder icon with a more elegant, memorable identity.

### Current icon assessment

- The present icon communicates "music + orbit + dashboard", but it is visually busy.
- The multiple outline frames dilute the silhouette.
- The symbol loses distinctiveness at small sizes.
- The palette is serviceable but does not yet feel premium.

### New icon direction

- Favor one dominant silhouette over decorative framing.
- Keep the concept of "open archive + rhythm" rather than literal app chrome.
- Ensure recognizability at menu bar, small app icon, and large Finder sizes.

### Recommended direction

`Open disc + minimal waveform`

- A circular open arc suggests archive, orbit, and openness.
- A compact vertical waveform or pulse shape suggests live listening/scrobbling.
- A restrained accent node can hint at graph/discovery if it remains subtle.
- Background should be richer and calmer than the current neon-leaning treatment.

### Deliverables

- 2-3 icon explorations before choosing a final direction.
- Updated app icon set across all asset sizes.
- Refined monochrome menu bar glyph tuned separately from the app icon.
- Visual QA on light and dark menu bars and Finder/Desktop contexts.

### Acceptance criteria

- The icon remains legible at 16px and 32px.
- The final mark feels more premium and less prototype-like.
- The menu bar icon has crisp state contrast for enabled/disabled scrobbling.

## Phase 9: Release Hardening

### Goals

- Prepare the app for reliable iteration and eventual distribution.

### Deliverables

- Better diagnostics and support export for backend and queue issues.
- Stronger recovery messaging for auth, network, and partial backend failure.
- Signing and notarization readiness.
- Clear release notes structure based on roadmap phases.
- Optional GitHub Actions coverage for build/test validation.

### Acceptance criteria

- The app is easier to support, ship, and iterate without hidden migration risk.

## Suggested Execution Order

1. Phase 1: Identity and domain migration
2. Phase 7: Test overhaul foundations in parallel with Phase 1
3. Phase 2: ListenBrainz primary backend completion
4. Phase 3: Open social discovery
5. Phase 4: MusicBrainz enrichment
6. Phase 5: Shared and Obsessions evolution
7. Phase 6: UI and product polish
8. Phase 8: Icon and brand refresh
9. Phase 9: Release hardening

## Immediate Next Sprint

The next sprint should focus on the highest-leverage structural work:

- Replace remaining `LegacyOpenScrobbler` persistence paths with migration support.
- Define provider-neutral domain models and a migration boundary around `ScrobbleService`.
- Create `ListenBrainzServiceTests`.
- Expand queue and backend-state tests for dual-backend behavior.
- Draft 2-3 icon directions and choose one.

## Expanded ListenBrainz And MusicBrainz Product Plan

This section captures the product expansion requested after the first baseline review.

### Neighbor Listening

Status: first native pass implemented.

- Show recent public listens from users you follow and users who follow you.
- Keep this explicitly ListenBrainz-based, using public listen history rather than legacy provider friend activity.
- Next: add filters for followers, following, similar users, and "currently active" inferred from recent timestamps.

### ListenBrainz-Style Stats And Graphs

Status: first native activity chart implemented.

- Port ListenBrainz statistics gradually instead of embedding website pages.
- Current app coverage now includes top artists, recordings, releases, artist origins, affinity graph experiments, and listening activity.
- Next: add listening activity comparison against previous period, daily/weekly heatmaps, release-group stats, year-in-music summaries, and better empty/loading states.

### Track, Artist, Album, And Related Entity Detail

Status: first open metadata inspector implemented.

- The inspector now performs a MusicBrainz lookup for opened tracks, artists, and releases.
- It surfaces recording, artist, and release MBIDs, tags, country/type/disambiguation, and direct MusicBrainz/ListenBrainz links.
- Share and obsession drafts now preserve resolved MBIDs when available.
- Next: prefer ListenBrainz-supplied MBIDs before fuzzy MusicBrainz search, add release-group/work links, cover art, and richer relationship graphs.

### Profile Direction

ListenBrainz has account and social data but not a full personal profile surface in the same product sense. MusicBrainz has authenticated user profile and collection/rating/tag capabilities through OAuth, including public profile scope and optional collection/tag/rating scopes.

Planned direction:

- Treat the in-app "profile" as an OpenScrobbler profile assembled from ListenBrainz account/listening data plus optional MusicBrainz identity.
- Add a MusicBrainz connection later via OAuth, not token scraping.
- Once connected, show public MusicBrainz profile metadata and optional collections/ratings/tags only when the user grants scopes.

### Sharing Completion Criteria

Status: partially implemented, not 100%.

- Implemented: portable local vault sharing/import/export, JSPF-compatible export paths, ListenBrainz recommendation sending to selected followers, pins, and playlist creation from recommendations.
- Not yet complete: robust delivery receipts, received recommendation inbox/timeline reads, retry/diagnostic surface for failed recommendation sends, richer recipient discovery, and round-trip tests against more OpenAPI fixtures.

### Icon Direction

Status: first asset pass implemented.

Chosen concept: `open archive ring + listening pulse`.

- One open circular archive mark replaces the busier framed/orbit icon.
- A central pulse makes the scrobbling/listening action legible at small sizes.
- A small node suggests open graph/discovery without cluttering the silhouette.
- The menu bar glyph is a separate monochrome simplification for contrast.

## Definition Of Success

OpenScrobbler will be "aligned with the repo vision" when:

- ListenBrainz is the primary account and archive experience.
- The app's domain language is no longer legacy provider-shaped.
- Queueing, migration, and backend expansion are protected by strong tests.
- Shared and Obsessions remain local-first, portable, and future-compatible.
- The UI and icon feel like a confident product rather than a transplanted prototype.
