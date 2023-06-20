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
    
    @Published var defaultName : String = ""
    @Published var defaultSoloTier : String = "unranked"
    @Published var defaultSoloRank : String = ""
    @Published var defaultFlexTier : String = "unranked"
    @Published var defaultFlexRank : String = ""
    
    private let apiKey = Bundle.main.apiKey
    
    // MARK: - FUNCTION
    
    // USER DEFAULT 저장하기
    func saveFavorites(profileInfo: ProfileInfo) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(profileInfo) {
            UserDefaults.standard.set(encodedData, forKey: "ProfileInfo")
        }
    }
    // USER DEFAULT 불러오기
    func loadFavorites() {
        let decoder = JSONDecoder()
        if let encodedData = UserDefaults.standard.data(forKey: "ProfileInfo"), let favorites = try? decoder.decode(ProfileInfo.self, from: encodedData) {
            defaultName = favorites.summonerName
            defaultSoloTier = favorites.soloTier
            defaultSoloRank = favorites.soloRank
            defaultFlexTier = favorites.flexTier
            defaultFlexRank = favorites.flexRank
        }
    }
    
    
    // 소환사 리그정보 가져오기
    func fetchSummonerLeagueData(summonerId: String) {
        // API 요청 URL 생성
        guard let url = URL(string: "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/\(summonerId)?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        // URLSession을 사용하여 API 요청 및 데이터 처리
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
                // JSON 데이터를 디코딩하기 위해 JSONDecoder 생성
                let decoder = JSONDecoder()
                
                // JSON 데이터를 League 타입의 배열로 디코딩
                let league = try decoder.decode([League].self, from: data)
                
                // 리그 정보를 저장할 딕셔너리 생성
                var leagueData = [String: League]()
                
                // league 배열을 순회하면서 딕셔너리에 값을 저장
                for leagueInfo in league {
                    leagueData[leagueInfo.queueType] = leagueInfo
                }
                
                // 메인 스레드에서 UI 업데이트
                DispatchQueue.main.async {
                    // 솔로 랭크 정보 가져오기
                    if let soloLeague = leagueData["RANKED_SOLO_5x5"] {
                        self.summonerSoloTier = soloLeague.tier
                        self.summonerSoloRank = soloLeague.rank
                        self.summonerSoloLeaguePoints = soloLeague.leaguePoints
                    } else {
                        self.summonerSoloTier = "unranked"
                        self.summonerSoloRank = ""
                        self.summonerSoloLeaguePoints = 0
                    }
                    
                    // 자유 랭크 정보 가져오기
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
        // 아이콘 이미지 URL 생성
        guard let imageUrl = URL(string: "http://ddragon.leagueoflegends.com/cdn/13.11.1/img/profileicon/\(summonerProfileIconId).png") else {
            print("Invalid URL")
            return
        }
        
        // URLSession을 사용하여 이미지 데이터를 다운로드
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
                // 다운로드한 이미지 데이터를 사용하여 SwiftUI의 Image로 변환하여 소환사 프로필 아이콘 변수에 할당
                self.summonerProfileIconImage = Image(uiImage: UIImage(data: data) ?? UIImage())
            }
        }.resume()
    }
    
    // 소환사 정보 가져오기
    func fetchSummonerData() {
        // 소환사 이름을 URL 인코딩하여 API 요청 URL 생성
        guard let encodedPath = summonerName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/\(encodedPath)?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        // URLSession을 사용하여 API 요청 및 데이터 처리
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
                // JSON 데이터를 디코딩하기 위해 JSONDecoder 생성
                let decoder = JSONDecoder()
                
                // JSON 데이터를 Summoner 타입으로 디코딩
                let summoner = try decoder.decode(Summoner.self, from: data)
                
                DispatchQueue.main.async {
                    // 소환사 이름과 레벨을 UI에 업데이트
                    self.summonerName = summoner.name
                    self.summonerLevel = summoner.summonerLevel
                }
                
                // 소환사 아이콘 이미지 가져오기
                self.fetchIconImageData(summonerProfileIconId: summoner.profileIconId)
                
                // 소환사 리그 정보 가져오기
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
