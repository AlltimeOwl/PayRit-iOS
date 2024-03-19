//
//  AlarmSettingView.swift
//  PayRit
//
//  Created by 임대진 on 3/12/24.
//

import SwiftUI

struct AlarmSettingView: View {
    @State var appAlramToggle: Bool = true
    @State var marketingAlramToggle: Bool = false
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                HStack {
                    Text("앱 푸시 알림 설정")
                        .font(.system(size: 18))
                    Toggle("", isOn: $appAlramToggle)
                        .tint(Color.payritMint)
                }
                .frame(height: 88)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.2), radius: 5)
                
                HStack {
                    Text("마케팅 수신 동의")
                        .font(.system(size: 18))
                    Toggle("", isOn: $marketingAlramToggle)
                        .tint(Color.payritMint)
                }
                .frame(height: 88)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.2), radius: 5)
                
                Spacer()
            }
        }
        .dismissOnDrag()
        .navigationTitle("알림 설정")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 28)
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        AlarmSettingView()
    }
}
