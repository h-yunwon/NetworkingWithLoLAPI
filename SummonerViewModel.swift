//
//  SummonerViewModel.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import Foundation
import SwiftUI

class SummonerViewModel: ObservableObject {
    @Published var summonerName: String = ""
    @Published var summonerLevel: Int = 0
    
    @Published var summonerProfileIconImage: Image = Image(systemName: "circle")
    
    @Published var summonerTier: String = ""
    @Published var summonerRank: String = ""
    @Published var summonerLeaguePoints: Int = 0
    
    private let apiKey = Bundle.main.apiKey
    private let baseURL = Bundle.main.baseUrl
    
    // 소환사 리그정보 가져오기
    func fetchSummonerLeagueData(summonerId: String) {
        guard let url = URL(string: "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/\(summonerId)?api_key=\(apiKey)") else {
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
            
            // 가져온 데이터 구조 확인
//            if let dataString = String(data: data, encoding: .utf8) {
//                print(dataString)
//            } else {
//                print("Unable to convert data to string")
//
            
            do {
                let decoder = JSONDecoder()
                let league = try decoder.decode([League].self, from: data)
                
                DispatchQueue.main.async {
                    if league.count == 2 {
                        self.summonerTier = league[1].tier
                        self.summonerRank = league[1].rank
                        self.summonerLeaguePoints = league[1].leaguePoints
                    } else {
                        self.summonerTier = league[0].tier
                        self.summonerRank = league[0].rank
                        self.summonerLeaguePoints = league[0].leaguePoints
                    }
                }
            } catch {
                print("fetchSummonerLeagueData - Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // 소환사 아이콘 이미지 가져오기
    func fetchIconImageData(summonerProfileIconId: Int) {
        guard let imageUrl = URL(string: "http://ddragon.leagueoflegends.com/cdn/13.11.1/img/profileicon/\(summonerProfileIconId).png") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            DispatchQueue.main.async {
                self.summonerProfileIconImage = Image(uiImage: UIImage(data: data) ?? UIImage())
            }
        }.resume()
    }
    
    // 소환사 정보 가져오기
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
                
                self.fetchIconImageData(summonerProfileIconId: summoner.profileIconId)
                self.fetchSummonerLeagueData(summonerId: summoner.id)
                
            } catch {
                print("fetchSummonerData - Error decoding JSON: \(error.localizedDescription)")
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
