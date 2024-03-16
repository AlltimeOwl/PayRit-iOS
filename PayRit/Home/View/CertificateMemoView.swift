//
//  CertificateMemoView.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//

import SwiftUI

struct CertificateMemoView: View {
    @State private var today = ""
    @State private var text: String = ""
    @Environment(HomeStore.self) var homeStore
    let index: Int
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(today)
                    .font(Font.body01)
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray07, lineWidth: 1.0)
                    .frame(height: 110)
                    .overlay {
                        TextEditor(text: $text)
                            .padding(10)
                    }
            }
            .padding(.horizontal, 16)
            List(homeStore.certificates[index].memo) { memo in
                if !memo.text.isEmpty {
                    VStack(alignment: .leading) {
                        Text(memo.today)
                            .font(Font.body01)
                        HStack {
                            Text(memo.text)
                                .font(Font.body04)
                            Spacer()
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 6))
                        .shadow(color: Color.gray05.opacity(0.3), radius: 5)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .padding(.top, 20)
            Spacer()
            Button {
                if !text.isEmpty {
                    homeStore.memoSave(certificate: homeStore.certificates[index], today: today, text: text)
                    self.endTextEditing()
                }
                text = ""
            } label: {
                Text("입력하기")
                    .font(Font.title04)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.payritMint)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
        .onTapGesture { self.endTextEditing() }
        .navigationTitle("메모")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            today = homeStore.todayString()
        }
    }
}

#Preview {
    NavigationStack {
        CertificateMemoView(index: 0)
            .environment(HomeStore())
    }
}
