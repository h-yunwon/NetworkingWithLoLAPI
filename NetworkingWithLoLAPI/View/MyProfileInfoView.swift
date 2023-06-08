//
//  FavoriteSummonerView.swift
//  NetworkingWithLoLAPI
//
//  Created by Yunwon Han on 2023/06/08.
//

import SwiftUI

struct MyProfileInfoView: View {
    
    // MARK: - PROPERTY
    var name: String = ""
    var soloTier: String = "unranked"
    var soloRank: String = ""
    var flexTier: String = "unranked"
    var flexRank: String = ""

    // MARK: - BODY
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .fontWeight(.bold)
            
            Image("emblem-\(soloTier.lowercased())")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            Text(soloTier)
                .font(.footnote)
                .fontWeight(.bold)
            Text(soloRank)
                .font(.footnote)
                .fontWeight(.bold)
            
            Divider()
            
            Image("emblem-\(flexTier.lowercased())")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            Text(flexTier)
                .font(.footnote)
                .fontWeight(.bold)
            Text(flexRank)
                .font(.footnote)
                .fontWeight(.bold)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .opacity(0.8)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            Color(.systemGray)
                .opacity(0.3)
        )
        .cornerRadius(7)
        
    }
}

struct MyProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileInfoView()
    }
}
