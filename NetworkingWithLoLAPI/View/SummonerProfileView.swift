//
//  SummonerProfileView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct SummonerProfileView: View {
    
    var name: String = ""
    var level: Int = 0
    var soloTier: String = "unranked"
    var soloRank: String = ""
    var soloLeaguePoints: Int = 0
    var flexTier: String = "unranked"
    var flexRank: String = ""
    var flexLeaguePoints: Int = 0
    var profileIconImage: Image = Image(systemName: "circle")

    var body: some View {
        HStack(spacing: 10) {
            profileIconImage // 소환사 아이콘
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80, alignment: .center)
                .clipShape(Circle())
                .overlay(
                    Text(String(level)) // 소환사 레벨
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .background(Color(.gray))
                        .cornerRadius(7)
                    , alignment: .bottom
                )
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(name) // 소환사 이름
                    .font(.title3)
                    .fontWeight(.bold)

                HStack {
                    // 솔로랭크
                    SummonerRankView(
                        tier: soloTier,
                        rank: soloRank,
                        leaguePoints: soloLeaguePoints
                    )
                    
                    Divider()
                    
                    // 자유랭크
                    SummonerRankView(
                        tier: flexTier,
                        rank: flexRank,
                        leaguePoints: flexLeaguePoints
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
    static var name: String = ""
    static var level: Int = 0
    static var profileIconImage: Image = Image(systemName: "circle")
    static var soloTier: String = "unranked"
    static var soloRank: String = ""
    static var soloLeaguePoints: Int = 0
    static var flexTier: String = "unranked"
    static var flexRank: String = ""
    static var flexLeaguePoints: Int = 0

    static var previews: some View {
        SummonerProfileView()
    }
}
