//
//  ResponseModel.swift
//  WhereYouFrom
//
//  Created by Maks Winters on 31.12.2023.
//

import Foundation

struct Response: Codable {
    let count: Int
    let name: String
    let country: [Guess]
}

struct Guess: Codable {
    let countryID: String
    let probability: Double
    
    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case probability
    }
}
