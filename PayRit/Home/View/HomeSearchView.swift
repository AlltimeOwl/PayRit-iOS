//
//  HomeSearchView.swift
//  PayRit
//
//  Created by 임대진 on 3/10/24.
//

import SwiftUI

struct HomeSearchView: View {
    @Binding var homeStore: HomeStore
    var body: some View {
        VStack {
            Text("a")
        }
        .navigationTitle("검색")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeSearchView(homeStore: .constant(HomeStore()))
    }
}
