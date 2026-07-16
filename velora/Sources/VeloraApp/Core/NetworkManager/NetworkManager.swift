//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol EndpointProtocol {
    var url: URL? { get }
    var httpMethod: HttpMethod { get }
}

enum HttpMethod {
    case get
    case post
    case delete
    
    var stringValue: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        case .delete:
            "DELETE"
        }
    }
}

protocol NetworkManagerProtocol: Sendable {
    @discardableResult
    func sendRequest(endpoint: EndpointProtocol, body: Data?) async throws(NetworkManagerError) -> Data
    func uploadData(endpoint: EndpointProtocol, data: Data, uploadPreset: String) async throws(NetworkManagerError) -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    
    func sendRequest(endpoint: EndpointProtocol, body: Data?) async throws(NetworkManagerError) -> Data {
        guard let url = endpoint.url else { throw .urlError }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.stringValue
        request.httpBody = body
        request.setValue("VeloraApp/1.0", forHTTPHeaderField: "User-Agent")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            return try handleResponse(response, data: data)
        } catch let error as NetworkManagerError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }
    
    func uploadData(endpoint: EndpointProtocol, data: Data, uploadPreset: String) async throws(NetworkManagerError) -> Data {
        guard let url = endpoint.url else { throw .urlError }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let body = createMultipartBody(data: data, uploadPreset: uploadPreset, boundary: boundary)
        let request = createUploadRequest(to: url, with: body, boundary: boundary)
        
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            return try handleResponse(response, data: responseData)
        } catch let error as NetworkManagerError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }

    private func createMultipartBody(data: Data, uploadPreset: String, boundary: String) -> Data {
        var body = Data()
        
        func append(_ string: String) {
            if let stringData = string.data(using: .utf8) {
                body.append(stringData)
            }
        }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n")
        append("\(uploadPreset)\r\n")
        
        let mimeType = data.mimeType.isEmpty ? "image/jpeg" : data.mimeType
        let filename = "image.\(mimeType.components(separatedBy: "/").last ?? "jpg")"
        
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: \(mimeType)\r\n\r\n")
        
        body.append(data)
        
        append("\r\n")
        append("--\(boundary)--\r\n")
        
        return body
    }

    private func createUploadRequest(to url: URL, with body: Data, boundary: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    private func handleResponse(_ response: URLResponse, data: Data) throws(NetworkManagerError) -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkManagerError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkManagerError.serverError(code: httpResponse.statusCode)
        }
        
        return data
    }
}
