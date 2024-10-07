# APIClient

## Use Case

### Create API Endpoint
``` 
let baseURL = "https://example.com"
let queryItems = ["key": "value", "key2": "value2"]

do {
    let url = createAPIEndpoint(baseUrl: baseURL, queryItems: queryItems)
} catch {
    // Error Handring
}
```


## Reference

### Methods
```
func decodeAPIResponse<T: Decodable>(_ response: Data) throws -> T

func encodeAPIRequest<T: Encodable>(_ request: T) throws -> Data

func createAPIEndpoint(baseUrl: String, queryItems: [String: String]) throws -> URL

func fetchData<T: Decodable>(url: URL,dataType: T.Type, completion: @Sendable @escaping (Result<T, Error>) -> Void)
```

### APIClientError
```
enum APIClientError: Error, Equatable{
    case failedCreateBaseURL
    case failedCreateAPIEndpoint
    case invalidBaseURL
    case sessionError
    case requestError(Error)
    case decodeError(Error)
}
```
