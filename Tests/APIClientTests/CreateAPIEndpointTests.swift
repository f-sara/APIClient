//
//  CreateAPIEndpointTests.swift
//  APIClient
//
//  Created by 藤井紗良 on 2024/10/03.
//

import Testing
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

}
