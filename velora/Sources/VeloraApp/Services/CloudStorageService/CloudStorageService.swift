//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation

protocol CloudStorageServiceProtocol: Sendable {
    func uploadData(data: Data) async throws(CloudStorageServiceError) -> String
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
    
    func uploadData(data: Data) async throws(CloudStorageServiceError) -> String {
        let endpoint = CloudStorageEndpoints.cloudinary(cloudName: cloudName)
        do {
            let data = try await networkManager.uploadData(endpoint: endpoint, data: data, uploadPreset: uploadPreset)
            
            guard let response: CloudStorageUploadResponse = coder.decode(from: data) else {
                throw CloudStorageServiceError.providerError
            }
            return response.secureUrl
        } catch let error as NetworkManagerError {
            throw .networkError(error)
        } catch let error as CloudStorageServiceError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }
}
