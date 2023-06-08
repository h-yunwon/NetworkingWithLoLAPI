//
//  ContentView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/02.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTY
    @StateObject private var summonerVM = SummonerViewModel()
    @State private var searchSummonerName: String = ""
    @State private var isFormValid: Bool = false
    @State private var favoriteIsExpanded: Bool = false

    // MARK: - FUNCTION
    func searchSummoner() {
        summonerVM.summonerName = searchSummonerName
        summonerVM.fetchSummonerData()
    }
    
    func buttonActionToAddFavorite() {
        summonerVM.saveFavorites(profileInfo: ProfileInfo(
        summonerName: summonerVM.summonerName,
        summonerLevel: summonerVM.summonerLevel,
        soloTier: summonerVM.summonerSoloTier,
        soloRank: summonerVM.summonerSoloRank,
        soloLeaguePoints: summonerVM.summonerSoloLeaguePoints,
        flexTier: summonerVM.summonerFlexTier,
        flexRank: summonerVM.summonerFlexRank,
        flexLeaguePoints: summonerVM.summonerFlexLeaguePoints
        ))
    }
    
    // MARK: - BODY
    
    var body: some View {
    
        VStack(spacing: 5) {
            
            // 소환사 검색 창
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("소환사 검색", text: $searchSummonerName, onEditingChanged: { isEditing in
                    isFormValid = !searchSummonerName.isEmpty
                })
                    .font(.headline)
                    .foregroundColor(.gray)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                Spacer()
                
                Button(action: {
                    searchSummoner()
                }) {
                    Image(systemName: "chevron.forward")
                        .font(.headline)
                }
                .disabled(!isFormValid)

            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()
            
            VStack {
                
                // 소환사 등록 탭
                DisclosureGroup(isExpanded: $favoriteIsExpanded, content: {
                    MyProfileInfoView(
                        name: summonerVM.defaultName,
                        soloTier: summonerVM.defaultSoloTier,
                        soloRank: summonerVM.defaultSoloRank,
                        flexTier: summonerVM.defaultFlexTier,
                        flexRank: summonerVM.defaultFlexRank
                    )
                }, label: {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("내 소환사 정보")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .opacity(0.7)
                })
                .onAppear(perform: {
                    summonerVM.loadFavorites()
                })
                // 소환사 검색 정보
                SummonerProfileView(
                    name : summonerVM.summonerName,
                    level : summonerVM.summonerLevel,
                    soloTier : summonerVM.summonerSoloTier,
                    soloRank : summonerVM.summonerSoloRank,
                    soloLeaguePoints : summonerVM.summonerSoloLeaguePoints,
                    flexTier : summonerVM.summonerFlexTier,
                    flexRank : summonerVM.summonerFlexRank,
                    flexLeaguePoints : summonerVM.summonerFlexLeaguePoints,
                    profileIconImage : summonerVM.summonerProfileIconImage
                )
                    .background(
                        Color(.systemGray)
                            .opacity(0.2)
                    )
                    .cornerRadius(12)
                
                // 즐겨찾기 추가 버튼
                Button(action: buttonActionToAddFavorite) {
                    Text("나의 소환사 정보 추가")
                        .font(.headline)
                        .foregroundColor(.black)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color(.systemGray)
                        .opacity(0.1)
                )
                .cornerRadius(5)
                
            }//: VStack
        } //: VStack
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
