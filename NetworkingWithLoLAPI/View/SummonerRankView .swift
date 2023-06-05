//
//  SummonerRankView .swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/05.
//

import SwiftUI

struct SummonerRankView: View {
    
    var tier: String = "unranked"
    var rank: String = ""
    var leaguePoints: Int = 0
    
    var body: some View {
        VStack {
            Image("emblem-\(tier.lowercased())") // 티어 이미지
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            HStack(alignment: .center) {
                Text(tier + " " + rank) // 티어
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text("\(leaguePoints) LP") // 티어 점수
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        }
    }
}

struct SummonerRankView_Previews: PreviewProvider {
    static var previews: some View {
        SummonerRankView()
    }
}
