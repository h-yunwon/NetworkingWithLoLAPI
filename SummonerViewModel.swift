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
    
    @Published var summonerSoloTier: String = "unranked"
    @Published var summonerSoloRank: String = ""
    @Published var summonerSoloLeaguePoints: Int = 0
    @Published var summonerFlexTier: String = "unranked"
    @Published var summonerFlexRank: String = ""
    @Published var summonerFlexLeaguePoints: Int = 0
    
    private let apiKey = Bundle.main.apiKey

    // MARK: - FUNCTION
    
    // USER DEFAULT 저장하기
    func saveFavorites(favorites: Favorite) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encodedData, forKey: "Favorite")
            print("저장 성공: \(encodedData)")
        }
        
    }
    // USER DEFAULT 불러오기
    func loadProfileInfo() -> Favorite? {
        if let encodedData = UserDefaults.standard.data(forKey: "Favorite") {
            let decoder = JSONDecoder()
            if let favorites = try? decoder.decode(Favorite.self, from: encodedData) {
                print("불러오기 성공: \(favorites)")
                return favorites
            }
        }
        return nil
    }

    
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
                
                var leagueData = [String: League]() // 딕셔너리 생성
                
                // league 배열을 순회하면서 딕셔너리에 값을 저장
                for leagueInfo in league {
                    leagueData[leagueInfo.queueType] = leagueInfo
                }
                
                DispatchQueue.main.async {
                    
                    if let soloLeague = leagueData["RANKED_SOLO_5x5"] {
                        self.summonerSoloTier = soloLeague.tier
                        self.summonerSoloRank = soloLeague.rank
                        self.summonerSoloLeaguePoints = soloLeague.leaguePoints
                    } else {
                        self.summonerSoloTier = "unranked"
                        self.summonerSoloRank = ""
                        self.summonerSoloLeaguePoints = 0
                    }
                    
                    if let flexLeague = leagueData["RANKED_FLEX_SR"] {
                        self.summonerFlexTier = flexLeague.tier
                        self.summonerFlexRank = flexLeague.rank
                        self.summonerFlexLeaguePoints = flexLeague.leaguePoints
                    } else {
                        self.summonerFlexTier = "unranked"
                        self.summonerFlexRank = ""
                        self.summonerFlexLeaguePoints = 0
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
              let url = URL(string: "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/\(encodedPath)?api_key=\(apiKey)") else {
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
}
