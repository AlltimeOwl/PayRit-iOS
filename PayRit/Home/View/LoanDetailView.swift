//
//  LoanDetailView.swift
//  PayRit
//
//  Created by 임대진 on 3/4/24.
//

import SwiftUI

struct LoanDetailView: View {
    @Binding var document: Document
    @State var isModalPresented: Bool = false
    @State private var isActionSheetPresented: Bool = false
    var body: some View {
        ScrollView {
            Button {
                isModalPresented.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.boxGrayColor)
                    .frame(width: 200, height: 250)
                    .overlay {
                        LoanDetailImageView(isPresented: .constant(true), isButtonShowing: .constant(false))
                            .overlay {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "arrow.down.backward.and.arrow.up.forward")
                                            .foregroundStyle(Color(hex: "666666"))
                                    }
                                }
                                .padding(20)
                            }
                    }
            }
            // 내보내기 버튼
            HStack {
                Spacer()
//                Capsule(style: .continuous)
//                    .frame(width: 120, height: 30)
//                    .foregroundStyle(Color(hex: "#37D9BC"))
//                    .overlay {
//                        HStack {
//                            Image(systemName: "doc")
//                            Text("문서로 보내기")
//                        }
//                        .font(.system(size: 12))
//                        .foregroundStyle(.white)
//                        .bold()
//                        .padding()
//                    }
//                    .padding(.top, 36)
                Button {
                    isActionSheetPresented.toggle()
                } label: {
                    HStack {
                        Image(systemName: "doc")
                        Text("문서로 보내기")
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color(hex: "#37D9BC"))
                    .clipShape(.rect(cornerRadius: 20))
                }
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 24) {
                // 내용 상세
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("거래 금액")
                        }
                        HStack {
                            Text("거래 날짜")
                        }
                        HStack {
                            Text("상환 마감일")
                        }
                    }
                    .bold()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(document.totalMoney) 원")
                        }
                        HStack {
                            Text("\(document.startDay)")
                        }
                        HStack {
                            Text("\(document.endDay)")
                        }
                    }
                    Spacer()
                }
                .padding(20)
                .background(Color.boxGrayColor)
                .clipShape(.rect(cornerRadius: 12))
                
                VStack(alignment: .leading) {
                    Text("빌려준 사람")
                        .foregroundStyle(Color.sectionTitleColor)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    HStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("이름")
                            }
                            HStack {
                                Text("연락처")
                            }
                            HStack {
                                Text("주소")
                            }
                        }
                        .bold()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(document.sender)")
                            }
                            HStack {
                                Text("\(document.senderPhoneNumber)")
                            }
                            HStack {
                                Text("\(document.senderAdress)")
                            }
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.boxGrayColor)
                    .clipShape(.rect(cornerRadius: 12))
                }
                
                // 빌린 사람 정보
                VStack(alignment: .leading) {
                    Text("빌린 사람")
                        .foregroundStyle(Color.sectionTitleColor)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    HStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("이름")
                            }
                            HStack {
                                Text("연락처")
                            }
                            HStack {
                                Text("주소")
                            }
                        }
                        .bold()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(document.recipient)")
                            }
                            HStack {
                                Text("\(document.recipientPhoneNumber)")
                            }
                            HStack {
                                Text("\(document.recipientAdress)")
                            }
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.semeMintColor)
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
            .padding(.top, 20)
            .font(.system(size: 18))
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
        .scrollIndicators(.hidden)
        .navigationTitle("차용증 상세")
        .navigationBarTitleDisplayMode(.inline)
        .LoanDetailImage(isPresented: $isModalPresented, isButtonShowing: .constant(true))
        .confirmationDialog("", isPresented: $isActionSheetPresented, titleVisibility: .hidden) {
            Button("PDF 다운") {
            }
            Button("이메일 전송") {
            }
            Button("취소", role: .cancel) {
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoanDetailView(document: .constant(Document.samepleDocument[0]))
    }
}
