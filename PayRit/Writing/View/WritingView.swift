//
//  WritingView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

enum WritingType {
    case payrit
    case promise
}

struct WritingView: View {
    @State var path = NavigationPath()
    @State private var isShowingAuthAlert: Bool = false
    @Environment(TabBarStore.self) var tabStore
    @Environment(MyPageStore.self) var mypageStore
    @EnvironmentObject var iamportStore: IamportStore
    var body: some View {
        ZStack {
            Color.gray09.ignoresSafeArea()
            NavigationStack(path: $path) {
                VStack(spacing: 20) {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("오늘은")
                            HStack(spacing: 0) {
                                ZStack {
                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .frame(width: 100, height: 8)
                                            .foregroundStyle(Color.payritLightMint)
                                    }
                                    Text("어떤 약속")
                                }
                                Text("을 진행할까요?")
                            }
                            .frame(height: 20)
                        }
                        .font(Font.title01)
                        Spacer()
                    }
                    .padding(.top, 45)
                    .padding(.bottom, 30)
                    
                    Button {
                        if iamportStore.impAuth {
                            path.append(WritingType.payrit)
                        } else {
                            isShowingAuthAlert.toggle()
                        }
                    } label: {
                        Rectangle()
                            .frame(height: 160)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .customShadow()
                            .overlay {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("페이릿 작성하기")
                                                .font(Font.title02)
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("차용증과 동일한 효력으로\n문서로 출력할 수 있어요")
                                            .font(Font.body04)
                                            .foregroundStyle(Color.gray05)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Image("phone")
                                }
                                .frame(height: 92)
                                .padding(22)
                            }
                    }
                    
                    Button {
                        path.append(WritingType.promise)
                    } label: {
                        Rectangle()
                            .frame(height: 160)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .customShadow()
                            .overlay {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("약속 카드 만들기")
                                                .font(Font.title02)
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("간단한 돈 약속 카드를\n제작해서 간직할 수 있어요")
                                            .font(Font.body04)
                                            .foregroundStyle(Color.gray05)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Image("calender")
                                }
                                .frame(height: 92)
                                .padding(22)
                            }
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
                .navigationDestination(for: WritingType.self) { type in
                    switch type {
                    case .payrit:
                        SelectCertificateTypeView(path: $path)
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    case .promise:
                        SelectPromiseTypeView(path: $path)
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    }
                }
                if iamportStore.isCert {
                    IMPCertificationView(certType: .constant(.account))
                        .onDisappear {
                            iamportStore.clearButton()
                        }
                }
            }
            .onAppear {
                tabStore.tabBarHide = false
            }
            .onChange(of: path) {
                if path.isEmpty {
                    tabStore.tabBarHide = false
                }
            }
            .onChange(of: iamportStore.authResult) {
                if  iamportStore.authResult {
                    path.append("payritWrite")
                }
            }
        }
        .primaryAlert(isPresented: $isShowingAuthAlert, title: "본인인증 미완료", content: "페이릿 작성을 위해 \n본인인증을 1회 진행합니다.", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            iamportStore.isCert = true
        } cancleAction: {
        }
        .primaryAlert(isPresented: $iamportStore.isShowingDuplicateAlert, title: "본인인증 실패", content: "이미 인증된 계정이 존재합니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
    }
}

#Preview {
    WritingView()
        .environment(TabBarStore())
        .environment(MyPageStore())
        .environmentObject(IamportStore())
}
