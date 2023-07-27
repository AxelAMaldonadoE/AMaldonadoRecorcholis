//
//  Root.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 25/07/23.
//

import Foundation

struct Root<T: Codable> : Codable {
    
    var correct: Bool = false
    var results: [T]?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case correct
        case results
        case statusMessage = "status_message"
    }
}
