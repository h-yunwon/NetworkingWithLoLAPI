//
//  ContentView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var summonerVM = SummonerViewModel()
    @State private var isFormValid: Bool = false
    
    var body: some View {
    
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("소환사 검색", text: $summonerVM.summonerName, onEditingChanged: { isEditing in
                    isFormValid = !summonerVM.summonerName.isEmpty
                })
                    .font(.headline)
                    .foregroundColor(.gray)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                Spacer()
                
                Button(action: {
                    summonerVM.fetchSummonerData()
                }) {
                    Image(systemName: "chevron.forward")
                        .font(.headline)
                }
                .disabled(!isFormValid)

            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()
            
            SummonerProfileView(summonerName: summonerVM.summonerName, summonerLevel: summonerVM.summonerLevel, summonerProfileIconImage: summonerVM.summonerProfileIconImage)
                        
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
