# OpenScrobbler

OpenScrobbler is a macOS scrobbler and listening companion built around ListenBrainz, MusicBrainz, and open music data.

The project starts from lessons learned while building a Last.fm-focused desktop app: player monitoring, reliable scrobble thresholds, offline queueing, now-playing updates, charts, social graph exploration, menu bar controls, diagnostics, and local-first music memory features. The new goal is not to regress from that work. The goal is to rebuild it as a stronger, open-first app where ListenBrainz is the primary account, API, archive, and social substrate.

## Product Idea

OpenScrobbler should feel like a native desktop home for open listening history:

- Submit now-playing and completed listens to ListenBrainz.
- Keep a resilient local queue when the network or API is unavailable.
- Show charts for artists, recordings, releases, and listening periods.
- Preserve social discovery through ListenBrainz-compatible follows, public listens, similar users, playlists, pins, and local graph analysis.
- Use MusicBrainz identifiers whenever possible so data stays portable.
- Keep local-first shared music and obsession-style memory features, but express them as open archives rather than legacy service rituals.
- Provide a polished macOS menu bar and main-window experience.

## Migration Plan

1. Establish the standalone app identity.
   - Use `OpenScrobbler` as the product, module, bundle, storage, and keychain identity.
   - Remove Last.fm labels from onboarding, settings, diagnostics, menu bar copy, docs, and exported bundle schemas.
   - Rework the account section into a ListenBrainz account panel with token validation, username discovery, connection status, and submission toggles.

2. Make ListenBrainz the primary backend.
   - Route now-playing and completed-listen submission through the native ListenBrainz API.
   - Make the queue backend-neutral internally, but default to ListenBrainz-only.
   - Keep Last.fm-era logic only as temporary reference code until it is replaced by provider-neutral models.

3. Preserve and upgrade existing features.
   - Port player monitoring, threshold rules, deduplication, retry backoff, proxy settings, launch-at-login, diagnostics, and menu bar controls.
   - Keep charts and social graph views, but rebuild their data sources around ListenBrainz stats, listens, follows, similar users, playlists, and MusicBrainz metadata.
   - Replace Last.fm profile, friend, neighbour, subscriber, and badge concepts with ListenBrainz-native identity and social concepts.

4. Model the app around open music entities.
   - Prefer `Listen`, `Recording`, `Release`, `Artist`, `Playlist`, `User`, and `Connection` over legacy scrobble/profile terms where practical.
   - Store MBIDs alongside display names when available.
   - Keep UI forgiving when metadata is partial.

5. Build the first functional baseline.
   - Launch the app with a ListenBrainz account panel.
   - Validate a user token.
   - Submit now-playing and completed listens.
   - Queue and retry failed submissions.
   - Show recent listens and at least one chart view from ListenBrainz.

6. Expand into open social discovery.
   - Add social graph exploration using ListenBrainz relationships and public listening overlap.
   - Add shared playlists or portable bundles as the open replacement for legacy share flows.
   - Keep local memory features as user-owned data with import/export.

## Status

This repository is being created as the clean home for the OpenScrobbler effort. Full source migration will follow after the ListenBrainz-first architecture is rewired and the old Last.fm-centered labels and assumptions are retired.
