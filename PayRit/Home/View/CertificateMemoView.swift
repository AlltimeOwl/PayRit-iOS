//
//  CertificateMemoView.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//

import SwiftUI

struct CertificateMemoView: View {
    @State private var text: String = ""
    @State private var memoId: Int = 0
    @State private var keyBoardFocused: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    @State var certificateDetail: CertificateDetail
    @Environment(HomeStore.self) var homeStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(alignment: .leading) {
                Group {
                    Text(Date().dateToString().replacingOccurrences(of: "-", with: "."))
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
                List(certificateDetail.memoListResponses, id: \.self) { memo in
                    VStack(alignment: .leading) {
                        Text(memo.createdAt.prefix(10).replacingOccurrences(of: "-", with: "."))
                            .font(Font.body01)
                        HStack {
                            Text(memo.content)
                                .font(Font.body04)
                            Spacer()
//                            Button {
//                                memoId = memo.id
//                                isShowingDeleteAlert.toggle()
//                            } label: {
//                                Image("trashIcon")
//                            }
//                            .frame(width: 24, height: 24)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 6))
                        .shadow(color: Color.gray05.opacity(0.3), radius: 5)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.top, 20)
                Spacer()
                Button {
                    if !text.isEmpty {
                        homeStore.memoSave(paperId: certificateDetail.paperId, content: text)
                        certificateDetail.memoListResponses.append(Memo(id: 0, content: text, createdAt: Date().dateToString().replacingOccurrences(of: "-", with: ".")))
                        homeStore.certificateDetail.memoListResponses.append(Memo(id: 0, content: text, createdAt: Date().dateToString().replacingOccurrences(of: "-", with: ".")))
                        self.endTextEditing()
                        text = ""
                    }
                } label: {
                    Text("입력하기")
                        .font(Font.title04)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.payritMint)
                        .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
                }
                .padding(.bottom, keyBoardFocused ? 0 : 16)
                .padding(.horizontal, keyBoardFocused ? 0 : 16)
            }
        }
        .dismissOnDrag()
        .onTapGesture { self.endTextEditing() }
        .navigationTitle("메모")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
        }
//        .primaryAlert(isPresented: $isShowingDeleteAlert, title: "삭제", content: "메모를 삭제하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
//            homeStore.memoDelete(paperId: memoId)
//            certificateDetail.memoListResponses.removeAll(where: {$0.id == memoId})
//        } cancleAction: {
//            
//        }
    }
}

#Preview {
    NavigationStack {
        CertificateMemoView(certificateDetail: CertificateDetail.EmptyCertificate)
            .environment(HomeStore())
    }
}
