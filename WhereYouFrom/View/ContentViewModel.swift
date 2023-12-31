//
//  ContentViewModel.swift
//  WhereYouFrom
//
//  Created by Maks Winters on 31.12.2023.
//

import Foundation
import SwiftUI

@Observable
final class ContentViewModel {
    
    static let response = Response(count: 23131, name: "Example", country: [Guess(countryID: "RO", probability: 0.123)])
    
    var guess = response
    
    var name = "Example"
    
    var isDisabled: Bool {
        name.isEmpty || name == "Example"
    }
    
    func fetchResults() async {
        print("Guessing...")
        guard let url = URL(string: "https://api.nationalize.io/?name=\(name)") else {
            print("Invalid url")
            return
        }
        print("Starting to fetch...")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Data we got: \(data)")
            if let result = try? JSONDecoder().decode(Response.self, from: data) {
                print(result)
                guess = result
            } else {
                print("Something failed at decode...")
            }
        } catch {
            print("Could't parse the data")
        }
    }
}
