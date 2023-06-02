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
    
    var body: some View {
        HStack {
            Image(systemName: "circle") // 소환사 아이콘
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .overlay(
                    Text(String(summonerLevel)) // 소환사 레벨
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .background(Color(.gray))
                        .cornerRadius(7)
                    , alignment: .bottom
            )
            
            VStack {
                Text(summonerName) // 소환사 이름
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Tier") // 티어
                    
                    Image(systemName: "circle") // 티어 이미지
                    
                    Divider()
                        .frame(height: 20)
                    
                    Text("점수 LP") // 티어 점수
                }
            }
        }
    }
}

struct SummonerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SummonerProfileView()
    }
}
