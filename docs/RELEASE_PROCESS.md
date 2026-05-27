# Release Process

OpenScrobbler releases are published by GitHub Actions from version tags.

## Normal Flow

1. Update `MARKETING_VERSION` in `project.yml`.
2. Update `CURRENT_PROJECT_VERSION` in `project.yml` if the build number should advance.
3. Regenerate the Xcode project if `project.yml` changed:

   ```bash
   xcodegen generate
   ```

4. Add a new section to `CHANGELOG.md` using the version number without `v`:

   ```markdown
   ## 0.1.1 - YYYY-MM-DD
   ```

5. Run tests locally:

   ```bash
   xcodebuild test \
     -project OpenScrobbler.xcodeproj \
     -scheme OpenScrobbler \
     -destination 'platform=macOS'
   ```

6. Commit and push `main`.
7. Create and push the release tag:

   ```bash
   git tag -a v0.1.1 -m "OpenScrobbler 0.1.1"
   git push origin v0.1.1
   ```

GitHub Actions will then test, build, package, and publish the release.

## Manual Re-run

If the tag exists but publishing failed, run the `Release` workflow manually in GitHub and provide the existing tag, such as `v0.1.1`.

## Release Asset

The workflow uploads:

- `OpenScrobbler-<version>-macOS.zip`

The app is locally signed by the workflow. Notarization is not automated yet.

## Future Automation

- Add notarization once Apple Developer credentials are available in GitHub secrets.
- Add a version-bump workflow once the project has a stable branching/review policy.
