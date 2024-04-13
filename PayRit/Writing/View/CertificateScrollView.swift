//
//  CertificateScrollView.swift
//  PayRit
//
//  Created by 임대진 on 4/14/24.
//

import SwiftUI

struct CertificateScrollView: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            ScrollView {
                    Rectangle()
                        .foregroundStyle(.red)
                        .frame(height: UIScreen.screenHeight)
                    Rectangle()
                        .foregroundStyle(.blue)
                        .frame(height: UIScreen.screenHeight)
                    Rectangle()
                        .foregroundStyle(.green)
                        .frame(height: UIScreen.screenHeight)
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            Button {
                withAnimation {
                    currentPage += 1
                    if currentPage == 3 {
                        currentPage = 0
                    }
                }
            } label: {
                Text("aa")
            }
        }
    }
}

#Preview {
    CertificateScrollView()
}
