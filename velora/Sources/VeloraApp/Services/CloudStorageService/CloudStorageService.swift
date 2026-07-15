//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol CloudStorageServiceProtocol: Sendable {
    func uploadData(data: Data) async throws -> String
}

final class CloudStorageService: CloudStorageServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let coder: CodingManagerProtocol
    
    private let uploadPreset: String = "my-bump"
    private let cloudName: String = "dg7no5imh"
    
    init(networkManager: NetworkManagerProtocol, coder: CodingManagerProtocol) {
        self.networkManager = networkManager
        self.coder = coder
    }
    
    func uploadData(data: Data) async throws -> String {
        let endpoint = CloudStorageEndpoints.cloudinary(cloudName: cloudName)
        let data = try await networkManager.uploadData(endpoint: endpoint, data: data, uploadPreset: uploadPreset)
        guard let response: CloudStorageUploadResponse = coder.decode(from: data) else {
            return ""
        }
        return response.secureUrl
    }
}
