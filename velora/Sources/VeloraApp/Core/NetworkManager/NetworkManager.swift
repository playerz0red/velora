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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkManagerError.networkError
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkManagerError.serverError(code: httpResponse.statusCode)
            }
            
            return data
        } catch let error as NetworkManagerError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }
    
    func uploadData(endpoint: EndpointProtocol, data: Data, uploadPreset: String) async throws(NetworkManagerError) -> Data {
        guard let url = endpoint.url else { return .init() }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        // Добавляем upload_preset
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        
        // Добавляем файл (КАК БИНАРНЫЕ ДАННЫЕ, а не base64!)
        let mimeType = data.mimeType.isEmpty ? "image/jpeg" : data.mimeType
        let filename = "image.\(mimeType.components(separatedBy: "/").last ?? "jpg")"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data) // <-- отправляем бинарные данные, НЕ base64!
        body.append("\r\n".data(using: .utf8)!)
        
        // Закрываем boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkManagerError.networkError
            }
            
            guard httpResponse.statusCode == 200 else {
                if let serverErrorResponse = String(data: data, encoding: .utf8) {
                    print("❌ Cloudinary Error [\(httpResponse.statusCode)]: \(serverErrorResponse)")
                }
                throw NetworkManagerError.serverError(code: httpResponse.statusCode)
            }
            
            return data
        } catch let error as NetworkManagerError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }
}
