//
//  SummonerViewModel.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import Foundation
import SwiftUI

class SummonerViewModel: ObservableObject {
    
    // MARK: - PROPERTY
    @Published var summonerName: String = ""
    @Published var summonerLevel: Int = 0
    
    @Published var summonerProfileIconImage: Image = Image(systemName: "circle")
    
    @Published var summonerSoloTier: String = ""
    @Published var summonerSoloRank: String = ""
    @Published var summonerSoloLeaguePoints: Int = 0
    @Published var summonerFlexTier: String = ""
    @Published var summonerFlexRank: String = ""
    @Published var summonerFlexLeaguePoints: Int = 0
    
    private let apiKey = Bundle.main.apiKey
    private let baseURL = Bundle.main.baseUrl
    
    // MARK: - FUNCTION
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
                    
                    switch league.count {
                    case 0:
                        self.summonerSoloTier = "unranked"
                        self.summonerSoloRank = "0"
                        self.summonerSoloLeaguePoints = 0
                        
                        self.summonerFlexTier = "unranked"
                        self.summonerFlexRank = "0"
                        self.summonerFlexLeaguePoints = 0
                    case 1:
                        if league[0].queueType == "RANKED_SOLO_5x5" {
                            self.summonerSoloTier = league[0].tier
                            self.summonerSoloRank = league[0].rank
                            self.summonerSoloLeaguePoints = league[0].leaguePoints
                            
                            self.summonerFlexTier = "unranked"
                            self.summonerFlexRank = "0"
                            self.summonerFlexLeaguePoints = 0
                            
                        } else {
                            
                            self.summonerSoloTier = "unranked"
                            self.summonerSoloRank = "0"
                            self.summonerSoloLeaguePoints = 0
                            
                            self.summonerFlexTier = league[0].tier
                            self.summonerFlexRank = league[0].rank
                            self.summonerFlexLeaguePoints = league[0].leaguePoints
                        }
                    case 2:
                        self.summonerSoloTier = league[0].tier
                        self.summonerSoloRank = league[0].rank
                        self.summonerSoloLeaguePoints = league[0].leaguePoints
                        
                        self.summonerFlexTier = league[1].tier
                        self.summonerFlexRank = league[1].rank
                        self.summonerFlexLeaguePoints = league[1].leaguePoints
                        
                    default : print("Error Switch case ")
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
