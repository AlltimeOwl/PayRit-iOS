//
//  MembershipWithdrawal.swift
//  PayRit
//
//  Created by 임대진 on 3/8/24.
//

import SwiftUI

struct MembershipWithdrawalView: View {
    @State var seletedReason: String = ""
    @State var isShowingMenu: Bool = false
    @State var isShowingWithdrawalButton: Bool = false
    @State var isShowingWithdrawalCompleteButton: Bool = false
    @Binding var signInState: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("페이릿을")
                HStack(spacing: 0) {
                    Text("떠나시는 이유")
                        .foregroundStyle(Color.payritMint)
                    Text("가 있을까요?")
                }
            }
            .font(.custom("Pretendard-Bold", size: 27))
            .font(.system(size: 28))
            
            Text("떠나시는 이유를 알려주세요.")
            
            Group {
                Button {
                    withAnimation {
                        isShowingMenu.toggle()
                    }
                } label: {
                    if isShowingMenu == false {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                            .frame(height: isShowingMenu ? 88 : 56)
                            .background(Color.gray09)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(seletedReason.isEmpty ? "선택해주세요" : seletedReason)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                            .frame(height: isShowingMenu ? 214 : 56)
                            .background(Color.gray09)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                VStack(alignment: .leading, spacing: 20) {
                                    Button {
                                        seletedReason = ""
                                        isShowingMenu.toggle()
                                    } label: {
                                        HStack {
                                            Text("선택해주세요")
                                            Spacer()
                                            Image(systemName: "chevron.up")
                                        }
                                    }
                                    Button {
                                        seletedReason = "사용을 잘 안하게 돼요"
                                        isShowingMenu.toggle()
                                    } label: {
                                        Text("사용을 잘 안하게 돼요")
                                    }
                                    Button {
                                        seletedReason = "다른 계정이 있어요"
                                        isShowingMenu.toggle()
                                    } label: {
                                        Text("다른 계정이 있어요")
                                    }
                                    Button {
                                        seletedReason = "개인정보 보호를 위해 삭제하고 싶어요"
                                        isShowingMenu.toggle()
                                    } label: {
                                        Text("개인정보 보호를 위해 삭제하고 싶어요")
                                    }
                                    Button {
                                        seletedReason = "기타"
                                        isShowingMenu.toggle()
                                    } label: {
                                        Text("기타")
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                    }
                }
                .font(.system(size: 16))
//                .foregroundStyle(Color.semiGrayColor2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("잠깐!")
                        .foregroundStyle(Color(hex: "E75555"))
                    Text("이렇게 해보시면 어때요?")
                        .foregroundStyle(Color(hex: "666666"))
                }
                .font(.custom("Pretendard-Bold", size: 16))
                Text("""
                페이릿에서는 금전 거래 약속 관련 법률 정책에 대한 정보를
                쉽게 알 수 있어요! 더 이용해보시겠어요?
                """)
                .kerning(0.5)
                .lineSpacing(2)
                .font(.custom("Pretendard-Regular", size: 14))
                .foregroundStyle(Color(hex: "999999"))
            }
            
            Spacer()
            Button {
                isShowingWithdrawalButton.toggle()
            } label: {
                Text("탈퇴하기")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(seletedReason.isEmpty ? .gray : .white)
            }
            .disabled(seletedReason.isEmpty)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(seletedReason.isEmpty ? Color(hex: "DBDBDB") : Color.payritMint)
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(16)
        .navigationTitle("회원탈퇴")
        .navigationBarTitleDisplayMode(.inline)
        .PrimaryAlert(isPresented: $isShowingWithdrawalButton, title: "회원탈퇴", content: "정말 탈퇴하시겠습니까?", primaryButtonTitle: "아니오", cancleButtonTitle: "네", primaryAction: nil) {
            isShowingWithdrawalCompleteButton.toggle()
        }
        .PrimaryAlert(isPresented: $isShowingWithdrawalCompleteButton, title: "회원탈퇴 완료",
                      content: """
                                회원탈퇴가
                                완료되었습니다.
                                """
                      , primaryButtonTitle: nil, cancleButtonTitle: "확인", primaryAction: nil) {
            signInState.toggle()
        }
    }
}

#Preview {
    NavigationStack {
        MembershipWithdrawalView(signInState: .constant(true))
    }
}
