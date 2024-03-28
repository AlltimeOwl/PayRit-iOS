//
//  CertificateMemoView.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//

import SwiftUI

struct CertificateMemoView: View {
    @State var paperId: Int
    @State private var memoId: Int?
    @State private var memoArray: [Memo] = [Memo]()
    @State private var text: String = ""
    @State private var keyBoardFocused: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
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
                
                List($memoArray, id: \.self) { $memo in
                    VStack(alignment: .leading) {
                        Text(memo.createdAt.prefix(10).replacingOccurrences(of: "-", with: "."))
                            .font(Font.body01)
                        HStack {
                            Text(memo.content)
                                .font(Font.body04)
                            Spacer()
                            Button {
                                isShowingDeleteAlert.toggle()
                                self.memoId = memo.id
                            } label: {
                                Image("trashIcon")
                            }
                            .frame(width: 24, height: 24)
                            .buttonStyle(BorderlessButtonStyle())
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
                        homeStore.memoSave(paperId: paperId, content: text) { (memoArray, error) in
                            if let error = error {
                                print("Error occurred: \(error)")
                            } else if let memoArray = memoArray {
                                self.memoArray = memoArray
                            }
                        }
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
        .onAppear {
            Task {
                homeStore.loadMemo(id: paperId) { (memoArray, error) in
                    if let error = error {
                        print("Error occurred: \(error)")
                    } else if let memoArray = memoArray {
                        self.memoArray = memoArray
                    }
                }
            }
        }
        .primaryAlert(isPresented: $isShowingDeleteAlert, title: "삭제", content: "메모를 삭제하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            if let memoId = memoId {
                homeStore.memoDelete(paperId: paperId, memoId: memoId) { (memoArray, error) in
                    if let error = error {
                        print("Error occurred: \(error)")
                    } else if let memoArray = memoArray {
                        self.memoArray = memoArray
                    }
                }
            }
        } cancleAction: {
            
        }
    }
}

#Preview {
    NavigationStack {
        CertificateMemoView(paperId: 0)
            .environment(HomeStore())
    }
}
