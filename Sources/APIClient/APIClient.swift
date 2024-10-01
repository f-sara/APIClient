// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum APIClientError: Error {
    case failedToCreateURL
}


class APIClient {


    public func decodeAPIResponse<T: Decodable>(_ response: Data) throws -> T {
        let decoder = JSONDecoder()
        let data = try decoder.decode(T.self, from: response)
        return data
    }

    public func createAPIEndpoint(url: String, format: String, queryItems: [String: String]) throws -> URL? {
        let baseURL: URL? = URL(string: url)
        var urlComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)

        for (key, value) in queryItems {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents?.url
    }

}
