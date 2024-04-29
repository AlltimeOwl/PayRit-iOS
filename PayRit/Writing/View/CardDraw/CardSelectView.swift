//
//  CardSelectView.swift
//  PayRit
//
//  Created by 임대진 on 4/23/24.
//

import SwiftUI

enum CardName: String {
    case blueCard
    case whiteCard
    case grayCard
    case pickCard
    case passCardReverse
    case pickCardReverse
}

enum CardResult {
    case ready
    case pass
    case pick
}

struct Card: Hashable, Identifiable {
    let id = UUID().uuidString
    let index: Int
    let cardName: CardName
    var backCard: CardName = .passCardReverse
    var frame: CGFloat = 0.0
    var isFlipped: Bool = false
    var used: Bool = false
}

struct CardSelectView: View {
    let number: Int
    @State var seletedCard: Int = 0
    @State var cards: [Card] = []
    @State var result: CardResult = .ready
    @State var whileAnimate: Bool = false
    @State var isShowingCard: Bool = false
    var body: some View {
        VStack {
            Spacer()
                switch result {
                case .ready:
                    Text("총 \(number)개의 랜덤 카드 중에서\n차례대로 선택해주세요!")
                        .font(Font.title03)
                        .multilineTextAlignment(.center)
                        .frame(height: 100)
                case .pass:
                    Text("축하드려요!\n\(seletedCard)번째 카드의\n결과는 '통과'입니다.")
                        .font(Font.title03)
                        .multilineTextAlignment(.center)
                        .frame(height: 100)
                case .pick:
                    Text("축하드려요!\n\(seletedCard)번째 카드의\n결과는 '당첨'입니다.")
                        .font(Font.title03)
                        .multilineTextAlignment(.center)
                        .frame(height: 100)
                }
            Spacer()
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: -60) {
                        Spacer().frame(width: 160).foregroundStyle(.clear)
                        ForEach($cards) { $item in
                            VStack {
                                Spacer()
                                Button {
                                    whileAnimate = true
                                    
                                    withAnimation(.smooth) {
                                        proxy.scrollTo(item.index, anchor: .center)
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.smooth) {
                                            item.frame = 150.0
                                            item.isFlipped.toggle()
                                        }
                                    }
                                } label: {
                                    if item.used {
                                        Image(item.backCard == .pickCardReverse ? "pickCardReverse" : "grayCard")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 250)
                                            .scaleEffect(x: item.backCard == .pickCardReverse ? -1 : 1)
                                            .shadow(color: Color(hex: "329794").opacity(0.5), radius: 3, x: 1, y: 4.8)
                                    } else {
                                        Image(!item.isFlipped ? item.cardName.rawValue : item.backCard.rawValue)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 250)
                                            .rotation3DEffect(.degrees(item.isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                            .shadow(color: Color(hex: "329794").opacity(0.5), radius: 3, x: 1, y: 4.8)
                                    }
                                }
                                .disabled(whileAnimate || item.used)
                                .onChange(of: item.frame) {
                                    if item.frame == 150.0 {
                                        seletedCard = item.index
                                        if item.backCard == .pickCardReverse {
                                            result = .pick
                                        } else {
                                            result = .pass
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation {
                                                item.used = true
                                                item.frame = 0
                                                whileAnimate = false
                                            }
                                        }
                                    }
                                }
                                Spacer().frame(height: item.frame)
                            }
                            .zIndex(Double(item.frame > 0 ? 1 : 0))
                            .id(item.index)
                        }
                        Spacer().frame(width: 160).foregroundStyle(.clear)
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                    .frame(height: 400)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("랜덤 결제하기")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            for i in stride(from: number, through: 1, by: -1) {
                if i % 2 == 1 {
                    self.cards.append(Card(index: i, cardName: .blueCard))
                } else {
                    self.cards.append(Card(index: i, cardName: .whiteCard))
                }
            }
            let randomIndex = Int.random(in: 0..<cards.count)
            cards[randomIndex].backCard = .pickCardReverse
        }
    }
}

#Preview {
    NavigationStack {
        CardSelectView(number: 5)
    }
}
