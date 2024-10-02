// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum APIClientError: Error {
    case failedToCreateURL
    case invalidURL
    case sessionError
    case requestError(Error)
    case decodeError(Error)
}

final public class APIClient: Sendable {

    public func fetchData<T: Decodable>(url: URL,dataType: T.Type, completion: @Sendable @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error {
                completion(.failure(APIClientError.requestError(error)))
                return
            }

            guard let data else {
                completion(.failure(APIClientError.sessionError))
                return
            }

            do {
                let responseData: T = try self.decodeAPIResponse(data)
                completion(.success(responseData))
            } catch {
                completion(.failure(APIClientError.decodeError(error)))
            }

        }.resume()
    }

    public func decodeAPIResponse<T: Decodable>(_ response: Data) throws -> T {
        let decoder = JSONDecoder()
        let data = try decoder.decode(T.self, from: response)
        return data
    }

    public func encodeAPIRequest<T: Encodable>(_ request: T) throws -> Data {
        let encoded = JSONEncoder()
        let data = try encoded.encode(request)
        return data
    }

    public func createAPIEndpoint(url: String, format: String, queryItems: [String: String]) throws -> URL? {
        let baseURL: URL? = URL(string: url)

        guard let baseURL else {
            throw APIClientError.sessionError
        }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        if urlComponents == nil {
            throw APIClientError.invalidURL
        }

        for (key, value) in queryItems {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents?.url
    }

}
