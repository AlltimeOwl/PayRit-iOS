//
// Created by BingBong on 2021/06/30.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import Then
import SwiftUI
import iamport_ios

public enum ItemType: Int, CaseIterable {
    case UserCode, PG, PayMethod, Carrier
    
    public var name: String {
        switch self {
        case .UserCode:
            return "가맹점 식별코드"
        case .PG:
            return "PG"
        case .PayMethod:
            return "결제수단"
        case .Carrier:
            return "(선택)통신사"
        }
    }
}

public class IamportStore: ObservableObject, Then {
    
//    var pgList = PG.allCases // PG 리스트
//    var payMethodList: Array<PayMethod> = [] // PayMethod 리스트
//    
    @Published var order: Order // 옵저빙할 결제 데이터 객체
    @Published var cert: Cert // 옵저빙할 본인인증 데이터 객체
    @Published var isShowingDuplicateAlert = false
//
//    //    @Published var iamportInfos: Array<(ItemType, PubData)> = []
//    @Published var orderInfos: Array<(String, PubData)> = []
//    @Published var certInfos: Array<(String, PubData)> = []
    
    @Published var isPayment: Bool = false
    @Published var isCert: Bool = false
    @Published var showResult: Bool = false
    @Published var authResult: Bool = false
    var iamportResponse: IamportResponse?
    
    init() {
        order = Order().then { order in
            order.userCode.value = "imp28882037"
            order.price.value = "1000"
            order.orderName.value = "주문할건데요?"
            order.name.value = "박포트"
            order.pg.value = PG.html5_inicis.rawValue
            order.appScheme.value = "iamport"
        }
        
        cert = Cert().then { cert in
            cert.userCode.value = "imp28882037"
        }
        
        //        // pub data init
        //        iamportInfos = [
        //            (.UserCode, order.userCode),
        //            (.PG, order.pg),
        //            (.PayMethod, order.payMethod),
        //            (.Carrier, cert.carrier)
        //        ]
        
//        orderInfos = [
//            ("주문명", order.orderName),
//            ("가격", order.price),
//            ("이름", order.name),
//            ("주문번호", order.merchantUid),
//        ]
//        
//        certInfos = [
//            ("주문번호", cert.merchantUid),
//            //            ("(선택)통신사", cert.carrier),
//            ("(선택)이름", cert.name),
//            ("(선택)휴대폰번호", cert.phone),
//            ("(선택)최소나이", cert.minAge),
//        ]
        
//        updatePayMethodList(pg: order.pg.value)
        updateMerchantUid()
    }
    
    func createPaymentData(completion: @escaping (IamportPayment?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/transaction/paymentInfo"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        print(data)
                        let paymentData = try JSONDecoder().decode(PaymentData.self, from: data)
                        print(paymentData)
                        let req = IamportPayment(pg: paymentData.PGCode ?? "kcp.IP05D", merchant_uid: paymentData.merchantUID, amount: String(paymentData.amount)).then {
                            $0.name = paymentData.name
                            $0.buyer_name = paymentData.buyerName
                            $0.buyer_email = paymentData.buyerEmai
                            $0.buyer_tel = paymentData.buyerTel
                        }
                        completion(req, nil)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil, error)
                    }
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    // 결제 완료 후 콜백 함수 (예시)
    func iamportCallback(_ response: IamportResponse?) {
        print("------------------------------------------")
        print("결과 왔습니다~~")
        if let res = response {
            print("Iamport response: \(res)")
        }
        print("------------------------------------------")
        
        iamportResponse = response
        if let response, let uid = response.imp_uid {
            sendCertificateResult(uid: uid)
            authResult = response.success ?? false
        }
        showResult = true
        clearButton()
    }
    
    func clearButton() {
        isPayment = false
        isCert = false
    }
    
    // 아임포트 본인인증 데이터 생성
    func createCertificationData() -> IamportCertification {
        IamportCertification(merchant_uid: cert.merchantUid.value).then {
            $0.min_age = Int(cert.minAge.value)
            $0.name = cert.name.value
            $0.phone = cert.phone.value
            $0.carrier = cert.carrier.value
        }
    }
    
    
    func updateMerchantUid() {
        order.merchantUid.value = UUID().uuidString
        cert.merchantUid.value = UUID().uuidString
    }
    
    
    //    func getItemList(type: ItemType) -> Array<(String, String)> {
    //        switch type {
    //        case .UserCode:
    //            return userCodeList.map {
    //                ($0.rawValue, $0.name)
    //            }
    //        case .PG:
    //            return pgList.map {
    //                ($0.rawValue, $0.name)
    //            }
    //        case .PayMethod:
    //            return payMethodList.map {
    //                ($0.rawValue, $0.name)
    //            }
    //
    //        case .Carrier:
    //            return carrierList.map {
    //                ($0, "")
    //            }
    //        }
    //    }
    
    func sendCertificateResult(uid: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/oauth/certification/init"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "impUid": uid
            ] as [String: Any]
            print(body)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("impUid : \(uid)")
                        print("impUid 전송 완료")
                    } else if response.statusCode == 409 {
                        self.isShowingDuplicateAlert.toggle()
                        if let data = data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("data: \(responseData ?? "No data")")
                        }
                    } else {
                        print("Unexpected status code: \(response.statusCode)")
                        if let data = data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("data: \(responseData ?? "No data")")
                        }
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }
    
}
