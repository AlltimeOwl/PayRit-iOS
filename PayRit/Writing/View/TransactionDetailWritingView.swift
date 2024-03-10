//
//  TransactionDetailWritingView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct TransactionDetailWritingView: View {
    @State private var money: String = ""
    @State private var moneyOverlay: String = ""
    @State private var tradeDay: String = ""
    @State private var endDay: String = ""
    @State private var etc: String = ""
    @State private var interest: String = ""
    @State private var interestOverlay: String = ""
    @State private var calToggle: Bool = true
    @State private var isShowingStopAlert: Bool = false
    @FocusState private var interestFocused: Bool
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading) {
                        Text("금액")
                        HStack {
                            TextField("0 원", text: $money)
                                .foregroundStyle(.clear)
                                .keyboardType(.numberPad)
                                .onChange(of: money) { oldValue, newValue in
                                    _ = oldValue
                                    moneyOverlay = newValue
                                }
                                .overlay {
                                    HStack {
                                        if moneyOverlay.count >= 1 {
                                            Text(moneyOverlay + " 원")
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }
                                    }
                                }
                            Spacer()
                            Image(systemName: "xmark.circle")
                        }
                        Divider()
                    }
                    VStack(alignment: .leading) {
                        Text("거래 날짜")
                        HStack {
                            TextField("YY.MM.DD", text: $tradeDay)
                                .keyboardType(.numberPad)
//                                .onChange(of: tradeDay) { oldvalue, newValue in
//                                    if tradeDay.count > 8 {
//                                        
//                                    } else {
//                                        tradeDay = oldvalue
//                                    }
//                                }
                            
                            Spacer()
                            Image(systemName: "xmark.circle")
                        }
                        Divider()
                    }
                    VStack(alignment: .leading) {
                        Text("상환 마감일")
                        HStack {
                            TextField("YY.MM.DD", text: $endDay)
                                .keyboardType(.numberPad)
                            Spacer()
                            Image(systemName: "xmark.circle")
                        }
                        Divider()
                    }
                    VStack(alignment: .leading) {
                        Text("특약사항이 있나요? (선택)")
                        TextEditor(text: $etc)
                            .clipShape(.rect(cornerRadius: 16))
                            .frame(height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.clear)
                                    .stroke(.gray, lineWidth: 2)
                            )
                        
                    }
                    
                    HStack {
                        Text("이자 계산기")
                        Spacer()
                        Toggle(isOn: $calToggle, label: {
                            Text("Label")
                                .hidden()
                        })
                    }
                    if calToggle {
                        VStack(alignment: .leading) {
                            Text("연 이자율")
                            HStack {
                                TextField("0 %", text: $interest)
                                    .foregroundStyle(.clear)
                                    .keyboardType(.decimalPad)
                                    .lineLimit(5)
                                    .onChange(of: interest) { oldValue, newValue in
                                        if newValue.count < 6 {
                                            if newValue.filter({ $0 == "." }).count >= 2 {
                                                interest = oldValue
                                                interestOverlay = interest
                                            } else {
                                                if Float(newValue) ?? 20.0 > 20.0 {
                                                    interest = "20"
                                                    interestOverlay = interest
                                                } else {
                                                    interestOverlay = interest
                                                }
                                            }
                                        } else {
                                            interest = oldValue
                                        }
                                    }
                                    .overlay {
                                        HStack {
                                            if interestOverlay.count >= 1 {
                                                Text(interestOverlay + " %")
                                                Spacer()
                                            }
                                        }
                                        // 최종 데이터에 interest 넣을때 마지막에 .이 있으면 지우고 넣기 만들어야함
                                    }

                                Spacer()
//                                Image(systemName: "calendar")
                            }
                            Divider()
                            Text("이자는 최대 20%까지 입력할 수 있어요.")
                        }
                    }
                    Text("총 12,000원을 상환해야해요!")
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            NavigationLink {
                MyInfoWritingView(path: $path)
                    .customBackbutton()
            } label: {
                Text("다음")
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.mintColor)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .padding(.top, 30)
        .scrollIndicators(.hidden)
        .navigationTitle("거래 내역 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { self.endTextEditing() }
        .toolbar {
            ToolbarItem {
                Button {
                    isShowingStopAlert.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
        .PrimaryAlert(isPresented: $isShowingStopAlert,
                      title: "작성 중단",
                      content: """
                        지금 작성을 중단하시면
                        처음부터 다시 작성해야해요.
                        작성 전 페이지로 돌아갈까요?
                        """,
                      primaryButtonTitle: "아니오",
                      cancleButtonTitle: "네") {
        } cancleAction: {
            path = .init()
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            TransactionDetailWritingView(path: .constant(NavigationPath()))
        }
    }
}
