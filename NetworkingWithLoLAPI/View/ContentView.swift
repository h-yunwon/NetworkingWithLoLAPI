//
//  ContentView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var summonerVM = SummonerViewModel()
    
    var body: some View {
    
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("소환사 검색", text: $summonerVM.summonerName)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .textFieldStyle(DefaultTextFieldStyle())
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )            .padding()

            Text("소환사 이름: \(summonerVM.summonerName)")
            Text("소환사 레벨: \(summonerVM.summonerLevel)")
            
            Button("검색") {
                summonerVM.fetchSummonerData()
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
