//
//  ContentView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct ContentView: View {
    @State private var summonerName: String = ""
    @State private var summonerLevel: Int = 0
    @State private var summonerRevisionDate: Int = 0
    
    var body: some View {
    
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("소환사 검색", text: $summonerName)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .textFieldStyle(DefaultTextFieldStyle())
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )            .padding()

            Text("소환사 이름: \(summonerName)")
            Text("소환사 레벨: \(summonerLevel)")
            
            Button("검색") {
                fetchSummonerData(summonerName: summonerName)
                }
            
        }
        .padding()
    }
    
    func fetchSummonerData(summonerName: String) {
        let apiKey = "RGAPI-563fc8d2-c6a9-40ff-a0c1-06fe568399cd"
        let baseURL = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/"
        let path = summonerName
        
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: baseURL + encodedPath + "?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
  
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let summoner = try decoder.decode(Summoner.self, from: data) // Summoner 모델로 디코딩
                
                DispatchQueue.main.async {
                    self.summonerName = summoner.name
                    self.summonerLevel = summoner.summonerLevel
                    self.summonerRevisionDate = summoner.revisionDate
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
