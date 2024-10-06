// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum APIClientError: Error, Equatable{
    case failedCreateBaseURL
    case failedCreateAPIEndpoint
    case invalidBaseURL
    case sessionError
    case requestError(Error)
    case decodeError(Error)

    static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        switch (lhs, rhs) {
        case (.failedCreateBaseURL, .failedCreateBaseURL):
            return true
        case (.failedCreateAPIEndpoint, .failedCreateAPIEndpoint):
            return true
        case (.invalidBaseURL, .invalidBaseURL):
            return true
        case (.sessionError, .sessionError):
            return true
        case (let .requestError(error1), let .requestError(error2)):
            return (error1 as NSError).domain == (error2 as NSError).domain &&
                   (error1 as NSError).code == (error2 as NSError).code
        case (let .decodeError(error1), let .decodeError(error2)):
            return (error1 as NSError).domain == (error2 as NSError).domain &&
                   (error1 as NSError).code == (error2 as NSError).code
        default:
            return false
        }
    }
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

    public func createAPIEndpoint(url: String, queryItems: [String: String]) throws -> URL {
        let baseURL: URL? = URL(string: url)

        guard let baseURL else {
            throw APIClientError.failedCreateBaseURL
        }

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        if urlComponents == nil {
            throw APIClientError.invalidBaseURL
        }

        if urlComponents?.queryItems == nil {
            urlComponents?.queryItems = []
        }

        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: value)
            urlComponents?.queryItems?.append(queryItem)
        }

        guard let url = urlComponents?.url else {
            throw APIClientError.failedCreateAPIEndpoint
        }

        return url
    }

}
