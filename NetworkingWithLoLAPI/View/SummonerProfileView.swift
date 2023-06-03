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
    
    var summonerTier: String = "Silver"
    var summonerRank: String = "4"
    var summonerLeaguePoints: Int = 10
    
    var body: some View {
        HStack {
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
            
            VStack(alignment: .leading, spacing: 0) {
                Image("emblem-\(summonerTier.lowercased())") // 티어 이미지
                    .resizable()
                    .scaledToFit()

                Text(summonerName) // 소환사 이름
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    Text(summonerTier + " " + summonerRank) // 티어
                    Text("\(summonerLeaguePoints) LP") // 티어 점수
                }
                

            }
        }
        .frame(width: 300, height: 90)
    }
}

struct SummonerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SummonerProfileView()
    }
}
