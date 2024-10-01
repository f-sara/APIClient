// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class APIClient {


    public func decodeAPIResponse<T: Decodable>(_ response: Data) throws -> T {
        let decoder = JSONDecoder()
        let data = try decoder.decode(T.self, from: response)
        return data
    }


}
