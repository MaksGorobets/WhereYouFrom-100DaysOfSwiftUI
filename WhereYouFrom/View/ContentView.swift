//
//  ContentView.swift
//  WhereYouFrom
//
//  Created by Maks Winters on 06.12.2023.
//

import SwiftUI
import SwiftFlags

struct ContentView: View {
    
    @State var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Output") {
                    Text(contentViewModel.guess.name)
                }
                Section("Guesses") {
                    ForEach(0..<contentViewModel.guess.country.count, id: \.self) { index in
                        let flag = SwiftFlags.flag(for: contentViewModel.guess.country[index].countryID)
                        Text("\(flag ?? "N/A") \(contentViewModel.guess.country[index].countryID)")
                        Text("Probability: \(contentViewModel.guess.country[index].probability)")
                    }
                }
                Section("Input") {
                    TextField("Enter a name", text: $contentViewModel.name)
                }
                HStack {
                    Spacer()
                    Button("Guess!") {
                        Task {
                            await contentViewModel.fetchResults()
                        }
                    }
                    .disabled(contentViewModel.isDisabled)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    return ContentView()
}
