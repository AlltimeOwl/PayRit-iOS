//
//  CertificateDeductibleView.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//

import SwiftUI

struct CertificateDeductibleView: View {
    @State private var today = ""
    @State private var text: String = ""
    @State var certificate: Certificate = Certificate.samepleDocument[0]
    @Binding var index: Int
    @Binding var homeStore: HomeStore
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("금액")
                    .font(Font.body01)
            }
            .padding(.horizontal, 16)
            List(certificate.memo) { memo in
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
                    homeStore.memoSave(certificate: certificate, today: today, text: text)
                    certificate.memo.append(Memo(today: today, text: text))
                    self.endTextEditing()
                }
                text = ""
//                print(homeStore.memoSave(certificate: certificate, today: today, text: text).memo)
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
            certificate = homeStore.certificates[index]
        }
    }
}

#Preview {
    NavigationStack {
        CertificateDeductibleView(index: .constant(0), homeStore: .constant(HomeStore()))
    }
}
