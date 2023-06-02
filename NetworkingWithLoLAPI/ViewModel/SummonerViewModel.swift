//
//  SummonerViewModel.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import Foundation

class SummonerViewModel: ObservableObject {
    @Published var summonerName: String = ""
    @Published var summonerLevel: Int = 0

    private var apiKey = Bundle.main.apiKey
    private let baseURL = Bundle.main.baseUrl
    
    func fetchSummonerData() {
        guard let encodedPath = summonerName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
                let summoner = try decoder.decode(Summoner.self, from: data)
                
                DispatchQueue.main.async {
                    self.summonerName = summoner.name
                    self.summonerLevel = summoner.summonerLevel
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension Bundle {
    
    var apiKey: String {
        // forResource에다 plist 파일 이름을 입력해주세요.
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        
        // plist 안쪽에 사용할 Key값을 입력해주세요.
        guard let value = plistDict.object(forKey: "LEAGUE_OF_LEGEND_API_KEY") as? String else {
            fatalError("Couldn't find key 'LEAGUE_OF_LEGEND_API_KEY' in 'Info.plist'.")
        }
        
        return value
    }
    
    var baseUrl: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        
        guard let value = plistDict["SUMMONER_V4_BASE_URL"] as? String else {
            fatalError("Couldn't find key 'SUMMONER_V4_BASE_URL' in 'Info.plist'.")
        }
        
        return "https://" + value
    }
}
