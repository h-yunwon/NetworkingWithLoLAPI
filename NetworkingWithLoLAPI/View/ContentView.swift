//
//  ContentView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var summonerVM = SummonerViewModel()
    @State private var isFormValid: Bool = false
    @State private var isFavorite: Bool = false
    
    func addToProfileInfo() -> ProfileInfo {
        let profileInfo = ProfileInfo(
            summonerName: summonerVM.summonerName,
            summonerLevel: summonerVM.summonerLevel,
            soloTier: summonerVM.summonerSoloTier,
            soloRank: summonerVM.summonerSoloRank,
            soloLeaguePoints: summonerVM.summonerSoloLeaguePoints,
            flexTier: summonerVM.summonerFlexTier,
            flexRank: summonerVM.summonerFlexRank,
            flexLeaguePoints: summonerVM.summonerFlexLeaguePoints,
            summonerProfileIconImage: summonerVM.summonerProfileIconImage,
            isFavorite: isFavorite
        )

        return profileInfo
    }
    
    func searchSummoner() {
        summonerVM.fetchSummonerData()
    }
    
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
                    searchSummoner()
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
            
            SummonerProfileView(summonerVM: summonerVM, profileInfo: addToProfileInfo(), isFavorite: $isFavorite)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
