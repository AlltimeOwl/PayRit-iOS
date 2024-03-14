//
//  CertificateDocumentView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateDocumentView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack {
            Text("차   용   증")
                .font(.title)
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("채 권 자")
                    Text("성 명 : ")
                    Text("")
                }
                HStack {
                    Spacer().frame(width: 61)
                    Text("전화번호 : ")
                    Text("")
                }
                HStack {
                    Spacer().frame(width: 61)
                    Text("주 소 : ")
                    Text("")
                }
                HStack {
                    Text("채 무 자")
                    Text("성 명 : ")
                    Text("")
                }
                HStack {
                    Spacer().frame(width: 61)
                    Text("전화번호 : ")
                    Text("")
                }
                HStack {
                    Spacer().frame(width: 61)
                    Text("주 소 : ")
                    Text("")
                }
                HStack { Spacer() }
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading) {
                Text("차용금액 및 변제조건")
                    .bold()
                VStack(spacing: 0) {
                    HStack {
                        CellView(text: "Row 1, Column 1")
                        CellView(text: "Row 1, Column 2")
                        CellView(text: "Row 1, Column 3")
                    }
                    
                    HStack {
                        CellView(text: "Row 2, Column 1")
                        CellView(text: "Row 2, Column 2")
                        CellView(text: "Row 2, Column 3")
                    }
                }
                .border(Color.black)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    CertificateDocumentView()
}

struct CellView: View {
    var text: String

    var body: some View {
        Text(text)
            .padding(10)
//            .border(Color.black)
    }
}
