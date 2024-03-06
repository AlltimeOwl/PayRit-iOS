//
//  MyInfoView.swift
//  PayRit
//
//  Created by 임대진 on 3/6/24.
//

import SwiftUI

struct MyInfoView: View {
    @State var name: String = "임대진"
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("이름")
                    .font(.system(size: 16))
                    .bold()
                TextField("", text: $name)
                    .disabled(true)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray)
            }
            Spacer()
        }
        .navigationTitle("계정 정보")
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
    }
}

#Preview {
    NavigationStack {
        MyInfoView()
    }
}
