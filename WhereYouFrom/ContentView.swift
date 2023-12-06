//
//  ContentView.swift
//  WhereYouFrom
//
//  Created by Maks Winters on 06.12.2023.
//

import SwiftUI
import SwiftFlags

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

struct ContentView: View {
    
    static let response = Response(count: 23131, name: "Example", country: [Guess(countryID: "RO", probability: 0.123)])
    
    @State private var guess = response
    
    @State private var name = "Example"
    
    var isDisabled: Bool {
        name.isEmpty || name == "Example"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Output") {
                    Text(guess.name)
                }
                Section("Guesses") {
                    ForEach(0..<guess.country.count, id: \.self) { index in
                        let flag = SwiftFlags.flag(for: guess.country[index].countryID)
                        Text("\(flag ?? "N/A") \(guess.country[index].countryID)")
                        Text("Probability: \(guess.country[index].probability)")
                    }
                }
                Section("Input") {
                    TextField("Enter a name", text: $name)
                }
                HStack {
                    Spacer()
                    Button("Guess!") {
                        Task {
                            await fetchResults()
                        }
                    }
                    .disabled(isDisabled)
                    Spacer()
                }
            }
        }
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

#Preview {
    return ContentView()
}
