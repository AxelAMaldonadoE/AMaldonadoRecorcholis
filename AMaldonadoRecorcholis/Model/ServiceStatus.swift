//
//  ServiceStatus.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 27/07/23.
//

import Foundation

struct ServiceStatus: Codable {
    
    var correct: Bool = false
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case correct
        case statusMessage = "status_message"
    }
}
