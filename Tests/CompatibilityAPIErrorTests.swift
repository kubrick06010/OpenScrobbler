import XCTest
@testable import OpenScrobbler

final class CompatibilityAPIErrorTests: XCTestCase {
    func testInvalidSessionHasReauthHint() {
        let error = CompatibilityAPIError.invalidSession
        XCTAssertEqual(error.recoverySuggestion, "Sign in again to refresh your compatibility session.")
    }

    func testNetworkUnavailableMentionsAutoRetry() {
        let error = CompatibilityAPIError.networkUnavailable
        XCTAssertTrue(error.recoverySuggestion.contains("retry automatically"))
    }
}
