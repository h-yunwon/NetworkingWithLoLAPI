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
    
//    @State private var favoriteTier = "unranked"
//    @State private var favoriteRank = ""
//    @State private var favoriteLeaguePoints = 0
//
    @Binding var isFavorite: Bool

    var body: some View {
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
                
                Text(profileInfo.summonerName) // 소환사 이름
                        .font(.title2)
                        .fontWeight(.bold)

                
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
