//
//  PeopleCountView.swift
//  PayRit
//
//  Created by 임대진 on 4/22/24.
//

import SwiftUI

struct PeopleCountView: View {
    @State var number = 1
    var body: some View {
        ZStack {
            VStack {
                Text("인원 수를 정해주세요")
                    .font(Font.title03)
                    .padding(.top, 150)
                Spacer()
                NavigationLink {
                    CardSelectView(number: number)
                        .customBackbutton()
                } label: {
                    Text("다음")
                        .font(Font.title04)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.payritMint)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
            HStack {
                Spacer()
                Button {
                    if number > 1 {
                        number -= 1
                    }
                } label: {
                    Image(systemName: "minus.square")
                        .font(.system(size: 40))
                }
                .frame(width: 50)
                .tint(.black)
                .opacity(number == 1 ? 0.2 : 1)
                
                Text("\(number)")
                    .font(.custom("SUIT-Bold", size: 64))
                    .frame(width: 200)
                
                Button {
                    number += 1
                } label: {
                    Image(systemName: "plus.app")
                        .font(.system(size: 40))
                }
                .frame(width: 50)
                .tint(.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("랜덤 결제하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PeopleCountView()
}
