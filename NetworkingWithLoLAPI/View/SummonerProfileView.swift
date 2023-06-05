//
//  SummonerProfileView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct SummonerProfileView: View {
    
    var summonerName: String = "name"
    var summonerLevel: Int = 0
    
    var summonerProfileIconImage: Image = Image(systemName: "circle")
    
    var soloTier: String = "unranked"
    var soloRank: String = "0"
    var soloLeaguePoints: Int = 0
    
    var flexTier: String = "unranked"
    var flexRank: String = "0"
    var flexLeaguePoints: Int = 0
    
    var body: some View {
        HStack(spacing: 10) {
            summonerProfileIconImage // 소환사 아이콘
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80, alignment: .center)
                .clipShape(Circle())
                .overlay(
                    Text(String(summonerLevel)) // 소환사 레벨
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .background(Color(.gray))
                        .cornerRadius(7)
                    , alignment: .bottom
                )
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(summonerName) // 소환사 이름
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    // 솔로랭크
                    SummonerRankView(tier:soloTier, rank:soloRank, leaguePoints: soloLeaguePoints)
                    
                    Divider()
                    
                    // 자유랭크
                    SummonerRankView(tier: flexTier, rank: flexRank, leaguePoints: flexLeaguePoints)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
        }
        .padding()
    }
}


struct SummonerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SummonerProfileView()
    }
}
