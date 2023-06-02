//
//  SummonerData.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import Foundation

struct Summoner: Codable {
    let id: String
    let accountId: String
    let puuid: String
    let name: String
    let profileIconId: Int
    let revisionDate: Int
    let summonerLevel: Int
}

// 소환사 아이콘
// 소환사 레벨
// 소환사 이름
// 티어
// 티어 이미지
// 티어 점수 
