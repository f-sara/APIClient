//
//  CreateAPIEndpointTests.swift
//  APIClient
//
//  Created by 藤井紗良 on 2024/10/03.
//

import Testing
import Foundation
@testable import APIClient

@Suite final class CreateAPIEndpointTests{

    let apiClient = APIClient()
    let testUrl = "https://example.com"
    let testQueryItems = ["id": "1", "name": "john_doe"]

    @Test func failCreateBaseURLTest() {
        let invalidURL = "https://example .com"
        #expect(throws: APIClientError.failedCreateBaseURL) {
            try apiClient.createAPIEndpoint(url: invalidURL, queryItems: testQueryItems)
        }
    }

    @Test func createAPIEndpointTest() {
        let endpoint = URL(string: "https://example.com?name=john_doe&id=1")
        do {
            let url =
            try apiClient.createAPIEndpoint(url: testUrl, queryItems: testQueryItems)
            #expect(endpoint == url)
        } catch {
            Issue.record("Test Failed: createAPIEndpointTest throws error: \(error)")
        }
    }
}
