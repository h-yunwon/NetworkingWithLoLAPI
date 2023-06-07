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
    @State private var isFormValid: Bool = false
    
//    @State private var defaultName : String
//    @State private var defaultLevel : Int
//    @State private var defaultSoloTier : String
//    @State private var defaultSoloRank : String
//    @State private var defaultSoloLeaguePoints : Int
//    @State private var defaultFlexTier : String
//    @State private var defaultFlexRank : String
//    @State private var defaultFlexLeaguePoints : Int
//    @State private var defaultProfileIconImage : Image
//
    // MARK: - FUNCTION
    
    func imageToData(image: Image) -> Data? {
        guard let uiImage = image.toUIImage() else {
            return nil
        }
        
        return uiImage.pngData()
    }

    func dataToImage(data: Data) -> Image? {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }

    func searchSummoner() {
        summonerVM.fetchSummonerData()
    }
    
    // MARK: - BODY
    
    var body: some View {
    
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("소환사 검색", text: $summonerVM.summonerName, onEditingChanged: { isEditing in
                    isFormValid = !summonerVM.summonerName.isEmpty
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
                
                Button(action: {
                    summonerVM.saveFavorites(profileInfo: ProfileInfo(
                        summonerName: summonerVM.summonerName,
                        summonerLevel: summonerVM.summonerLevel,
                        soloTier: summonerVM.summonerSoloTier,
                        soloRank: summonerVM.summonerSoloRank,
                        soloLeaguePoints: summonerVM.summonerSoloLeaguePoints,
                        flexTier: summonerVM.summonerFlexTier,
                        flexRank: summonerVM.summonerFlexRank,
                        flexLeaguePoints: summonerVM.summonerFlexLeaguePoints,
                        iconImageData: imageToData(image: summonerVM.summonerProfileIconImage) ?? Data()
                    ))
                    
                }) {
                    Text("즐겨찾기")
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
                
                SummonerProfileView(
//                    name : defaultName,
//                    level : defaultLevel,
//                    soloTier : defaultSoloTier,
//                    soloRank : defaultSoloRank,
//                    soloLeaguePoints : defaultSoloLeaguePoints,
//                    flexTier : defaultFlexTier,
//                    flexRank : defaultFlexRank,
//                    flexLeaguePoints : defaultFlexLeaguePoints,
//                    profileIconImage : defaultProfileIconImage
                )
                .background(
                        Color(.systemYellow)
                            .opacity(0.2)
                    )
                    .cornerRadius(12)
                    .padding(.top)
                
                Button(action: {
//                    if let favorites = summonerVM.loadFavorites() {
//                        defaultName = favorites.summonerName,
//                        defaultLevel = favorites.summonerLevel,
//                        defaultSoloTier = favorites.summonerSoloTier,
//                        defaultSoloRank = favorites.summonerSoloRank,
//                        defaultSoloLeaguePoints = favorites.summonerSoloLeaguePoints,
//                        defaultFlexTier = favorites.summonerFlexTier,
//                        defaultFlexRank = favorites.summonerFlexRank,
//                        defaultFlexLeaguePoints = favorites.summonerFlexLeaguePoints,
//                        defaultProfileIconImage = imageToData(image: favorites.summonerProfileIconImage) ?? Data()
//                        }
                }) {
                    Text("불러오기")
                        .font(.headline)
                        .foregroundColor(.black)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color(.systemYellow)
                        .opacity(0.1)
                )
                .cornerRadius(5)

            }
        }
        .padding()
    }
}

// MARK: - EXTENSION

extension Image {
    func toUIImage() -> UIImage? {
        guard let data = self.asUIImage().pngData() else {
            return nil
        }
        return UIImage(data: data)
    }
    
    private func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view?.bounds.size ?? .zero)
        let image = renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
        
        return image
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
