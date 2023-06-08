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

struct League: Codable {
    let leagueId: String
    let queueType: String
    let tier: String
    let rank: String
    let summonerId: String
    let summonerName: String
    let leaguePoints: Int
    let wins: Int
    let losses: Int
    let veteran: Bool
    let inactive: Bool
    let freshBlood: Bool
    let hotStreak: Bool
}

struct ProfileInfo: Codable {
    let summonerName: String
    let summonerLevel: Int
    let soloTier: String
    let soloRank: String
    let soloLeaguePoints: Int
    let flexTier: String
    let flexRank: String
    let flexLeaguePoints: Int
}

