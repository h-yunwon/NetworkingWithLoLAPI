//
//  SummonerProfileView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct SummonerProfileView: View {
    var summonerVM: SummonerViewModel
    var profileInfo: ProfileInfo
    
    @State private var favoriteTier = "unranked"
    @State private var favoriteRank = ""
    @State private var favoriteLeaguePoints = 0
    
    @Binding var isFavorite: Bool

    func setFavorites() -> Favorite {
        var favorites: Favorite {
            get {
                let summonerName = profileInfo.summonerName
                let summonerLevel = profileInfo.summonerLevel
                let soloTier = profileInfo.soloTier
                let soloRank = profileInfo.soloRank
                let soloLeaguePoints = profileInfo.soloLeaguePoints
                let flexTier = profileInfo.flexTier
                let flexRank = profileInfo.flexRank
                let flexLeaguePoints = profileInfo.flexLeaguePoints
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


    var body: some View {
        VStack {
            HStack(spacing: 10) {
                profileInfo.summonerProfileIconImage // 소환사 아이콘
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Text(String(profileInfo.summonerLevel)) // 소환사 레벨
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 7)
                            .background(Color(.gray))
                            .cornerRadius(7)
                        , alignment: .bottom
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text(profileInfo.summonerName) // 소환사 이름
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            summonerVM.saveFavorites(favorites: setFavorites())
                        }) {
                            Text("save")
    //                        Image(profileInfo.isFavorite ? "star.fill" : "star")
    //                            .font(.title2)
    //                            .tint(.yellow)
                        }
                    }
                    
                    HStack {
                        // 솔로랭크
                        SummonerRankView(
                            tier:profileInfo.soloTier,
                            rank:profileInfo.soloRank,
                            leaguePoints: profileInfo.soloLeaguePoints
                        )
                        
                        Divider()
                        
                        // 자유랭크
                        SummonerRankView(
                            tier: profileInfo.flexTier,
                            rank: profileInfo.flexRank,
                            leaguePoints: profileInfo.flexLeaguePoints
                        )
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
            }
            
            Button(action: {
                if let myFavorites = summonerVM.loadProfileInfo() {
                    favoriteTier = myFavorites.soloTier
                    favoriteRank = myFavorites.soloRank
                    favoriteLeaguePoints = myFavorites.soloLeaguePoints
                }
            }, label: {
                Text("불러오기")
            })
            .padding(.top, 20)
            
            SummonerRankView(
                tier:favoriteTier,
                rank:favoriteRank,
                leaguePoints: favoriteLeaguePoints
            )
        }
        .padding()
    }
}


struct SummonerProfileView_Previews: PreviewProvider {
    static var summonerVM: SummonerViewModel = SummonerViewModel()
    @State static var isFavorite: Bool = false
    static var profileInfo = ProfileInfo(summonerName: "name", summonerLevel: 0, soloTier: "unranked", soloRank: "", soloLeaguePoints: 0, flexTier: "unranked", flexRank: "", flexLeaguePoints: 0, summonerProfileIconImage: Image(systemName: "circle"), isFavorite: isFavorite)
    static var previews: some View {
        SummonerProfileView(summonerVM: summonerVM, profileInfo: profileInfo, isFavorite: $isFavorite)
    }
}
