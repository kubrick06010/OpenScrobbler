import XCTest
@testable import OpenScrobbler

final class MusicBrainzServiceTests: XCTestCase {
    override func tearDown() {
        MusicBrainzURLProtocol.handler = nil
        MusicBrainzURLProtocol.requests = []
        super.tearDown()
    }

    func testLookupCombinesRecordingArtistAndReleaseMetadata() async throws {
        let service = makeService { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!

            XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
            XCTAssertNotNil(request.value(forHTTPHeaderField: "User-Agent"))

            switch request.url!.path {
            case "/ws/2/recording":
                return (response, Data(Self.recordingPayload.utf8))
            case "/ws/2/artist":
                return (response, Data(Self.artistPayload.utf8))
            case "/ws/2/release":
                return (response, Data(Self.releasePayload.utf8))
            default:
                XCTFail("Unexpected path \(request.url!.path)")
                return (response, Data())
            }
        }

        let details = try await service.lookup(track: "Track", artist: "Artist", release: "Album")

        XCTAssertEqual(details.trackName, "Track")
        XCTAssertEqual(details.artistName, "Artist")
        XCTAssertEqual(details.releaseName, "Album")
        XCTAssertEqual(details.recordingMBID, "recording-id")
        XCTAssertEqual(details.artistMBID, "artist-id")
        XCTAssertEqual(details.releaseMBID, "release-id")
        XCTAssertEqual(details.country, "GB")
        XCTAssertTrue(details.tags.contains("trip hop"))
        XCTAssertTrue(details.links.contains { $0.url.absoluteString == "https://musicbrainz.org/recording/recording-id" })
    }

    private func makeService(
        handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data)
    ) -> MusicBrainzService {
        MusicBrainzURLProtocol.handler = handler
        MusicBrainzURLProtocol.requests = []
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MusicBrainzURLProtocol.self]
        return MusicBrainzService(
            baseURL: URL(string: "https://musicbrainz.org/ws/2")!,
            urlSession: URLSession(configuration: configuration)
        )
    }

    private static let recordingPayload = """
    {
      "recordings": [
        {
          "id": "recording-id",
          "title": "Track",
          "disambiguation": "single edit",
          "artist-credit": [
            { "artist": { "id": "artist-id", "name": "Artist" } }
          ],
          "releases": [
            { "id": "release-id", "title": "Album", "status": "Official" }
          ],
          "tags": [
            { "count": 8, "name": "trip hop" }
          ]
        }
      ]
    }
    """

    private static let artistPayload = """
    {
      "artists": [
        {
          "id": "artist-id",
          "name": "Artist",
          "country": "GB",
          "type": "Group",
          "tags": [
            { "count": 5, "name": "electronic" }
          ]
        }
      ]
    }
    """

    private static let releasePayload = """
    {
      "releases": [
        {
          "id": "release-id",
          "title": "Album",
          "status": "Official",
          "tags": [
            { "count": 3, "name": "downtempo" }
          ]
        }
      ]
    }
    """
}

private final class MusicBrainzURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    static var requests: [URLRequest] = []

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.requests.append(request)
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
