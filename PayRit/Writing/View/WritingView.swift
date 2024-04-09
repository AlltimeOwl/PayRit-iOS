//
//  WritingView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

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
                    .padding(.bottom, 30)
                    
                    Button {
                        if mypageStore.impAuth {
                            path.append("payritWrite")
                        } else {
                            isShowingAuthAlert.toggle()
                        }
                    } label: {
                        Rectangle()
                            .frame(height: 160)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
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
                                        Text("차용증과 동일한 효력을 가지고 있어요")
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
                    .shadow(color: .gray.opacity(0.2), radius: 8)
                    .navigationDestination(for: String.self) { _ in
                        SelectCertificateTypeView(path: $path)
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Rectangle()
                            .frame(height: 160)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("약속 작성하기")
                                                .font(Font.title02)
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("곧 출시돼요!")
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
                    .disabled(true)
                    .shadow(color: .gray.opacity(0.2), radius: 8)
                    
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
            }
            .onAppear {
                tabStore.tabBarHide = false
            }
            .onChange(of: path) {
                if path.isEmpty {
                    tabStore.tabBarHide = false
                }
            }
            if iamportStore.isCert {
                IMPCertificationView()
                    .onAppear {
                        iamportStore.updateMerchantUid()
                    }
                    .onDisappear {
                        iamportStore.clearButton()
                    }
                    .onChange(of: iamportStore.isCert) {
                        if  !iamportStore.isCert && iamportStore.authResult {
                            mypageStore.checkIMPAuth()
                            path.append("payritWrite")
                        }
                    }
            }
            if iamportStore.isPayment {
                PaymentView()
                    .onAppear {
                        iamportStore.updateMerchantUid()
                    }
                    .onDisappear {
                        iamportStore.clearButton()
                    }
            }
        }
        .primaryAlert(isPresented: $isShowingAuthAlert, title: "본인인증 미완료", content: "페이릿 작성을 위해 \n본인인증을 1회 진행합니다.", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            iamportStore.isCert = true
//            iamportStore.isPayment = true
        } cancleAction: {
        }
        .primaryAlert(isPresented: $iamportStore.isShowingDuplicateAlert, title: "인증 에러", content: "이미 인증된 계정이 존재합니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
    }
}

#Preview {
    WritingView()
        .environment(TabBarStore())
        .environmentObject(IamportStore())
}
