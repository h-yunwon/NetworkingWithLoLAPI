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
    
    func setFavorites() -> Favorite {
        var favorites: Favorite {
            get {
                let summonerName = summonerVM.summonerName
                let summonerLevel = summonerVM.summonerLevel
                let soloTier = summonerVM.summonerSoloTier
                let soloRank = summonerVM.summonerSoloRank
                let soloLeaguePoints = summonerVM.summonerSoloLeaguePoints
                let flexTier = summonerVM.summonerFlexTier
                let flexRank = summonerVM.summonerFlexRank
                let flexLeaguePoints = summonerVM.summonerFlexLeaguePoints
            //    let summonerProfileIconImageData: Data?
                let isFavorite = $isFavorite
                
                return Favorite(
                    summonerName: summonerName,
                    summonerLevel: summonerLevel,
                    soloTier: soloTier,
                    soloRank: soloRank,
                    soloLeaguePoints: soloLeaguePoints,
                    flexTier: flexTier,
                    flexRank: flexRank,
                    flexLeaguePoints: flexLeaguePoints,
                    isFavorite: false
                )
            }
        }
        
        return favorites
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
            
            VStack {
                SummonerProfileView(summonerVM: summonerVM, profileInfo: addToProfileInfo(), isFavorite: $isFavorite)
                    .background(
                        Color(.systemGray)
                            .opacity(0.2)
                    )
                    .cornerRadius(12)
                
                Button(action: {
                    isFavorite.toggle()
                    summonerVM.saveFavorites(favorites: setFavorites())
                }) {
                    Text("즐겨찾기")
                        .font(.headline)
                        .foregroundColor(.black)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color(.systemGray)
                        .opacity(0.1)
                )
                .cornerRadius(5)
                
                SummonerProfileView(summonerVM: summonerVM, profileInfo: addToProfileInfo(), isFavorite: $isFavorite)
                    .background(
                        Color(.systemYellow)
                            .opacity(0.2)
                    )
                    .cornerRadius(12)
                    .padding(.top)
                Button(action: {
                    // data 불러오기 
                }) {
                    Text("불러오기")
                        .font(.headline)
                        .foregroundColor(.black)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color(.systemYellow)
                        .opacity(0.1)
                )
                .cornerRadius(5)

            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
