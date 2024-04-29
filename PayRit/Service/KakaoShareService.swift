//
//  KakaoShareService.swift
//  PayRit
//
//  Created by 임대진 on 4/17/24.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate
import SwiftUI

enum KakaoLinkType {
    case app(url: URL)
    case web(url: URL)
    case err
}

final class KakaoShareService {
    
    func payritKakaoShare(sender: String, completion: @escaping (KakaoLinkType) -> ()) {
        let link = Link(webUrl: URL(string: "https://itunes.apple.com/app/id6480038044"))
        let appLink = Link(androidExecutionParams: ["key1": "value1", "key2": "value2"],
                           iosExecutionParams: ["key1": "value1", "key2": "value2"])
        
        let appButton = Button(title: "앱으로 보기", link: appLink)
        
        guard let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/payrit-33410.appspot.com/o/kakaoShareImage%2FkakaoShareImage.png?alt=media&token=8ca33cc1-1abb-4acc-9186-331664d8e60c") else { return }
        let content = Content(title: sender.isEmpty ? "페이릿 차용증이 작성되었습니다.\n앱에서 확인해주세요." : "\(sender)님이 작성하신\n페이릿 차용증이 작성되었습니다.\n앱에서 확인해주세요.",
                              imageUrl: imageUrl,
                              imageHeight: 200,
                              link: link)
        
        let template = FeedTemplate(content: content, buttons: [appButton])
        
        if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
            if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                if ShareApi.isKakaoTalkSharingAvailable() {
                    ShareApi.shared.shareDefault(templateObject: templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                            completion(.err)
                        } else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            completion(.app(url: linkResult.url))
                        }
                    }
                    
                } else {
                    print("카카오톡 미설치")
                    if let url = ShareApi.shared.makeDefaultUrl(templateObject: templateJsonObject) {
                        completion(.web(url: url))
                    }
                }
            }
        }
    }
    
    func promiseKakaoShare(id: Int, sender: String, completion: @escaping (KakaoLinkType) -> ()) {
        let link = Link(webUrl: URL(string: "https://itunes.apple.com/app/id6480038044"))
        let appLink = Link(androidExecutionParams: ["promiseId": "\(id)"],
                           iosExecutionParams: ["promiseId": "\(id)"])
        
        let appButton = Button(title: "앱으로 보기", link: appLink)
        
        guard let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/payrit-33410.appspot.com/o/kakaoShareImage%2FkakaoShareImage.png?alt=media&token=8ca33cc1-1abb-4acc-9186-331664d8e60c") else { return }
        let content = Content(title: sender.isEmpty ? "페이릿 약속이 작성되었습니다.\n앱에서 확인해주세요." : "\(sender)님이 작성하신\n페이릿 약속이 작성되었습니다.\n앱에서 확인해주세요.",
                              imageUrl: imageUrl,
                              imageHeight: 200,
                              link: link)
        
        let template = FeedTemplate(content: content, buttons: [appButton])
        
        if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
            if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                if ShareApi.isKakaoTalkSharingAvailable() {
                    ShareApi.shared.shareDefault(templateObject: templateJsonObject) {(linkResult, error) in
                        if let error = error {
                            print("error : \(error)")
                            completion(.err)
                        } else {
                            print("defaultLink(templateObject:templateJsonObject) success.")
                            guard let linkResult = linkResult else { return }
                            completion(.app(url: linkResult.url))
                        }
                    }
                    
                } else {
                    print("카카오톡 미설치")
                    if let url = ShareApi.shared.makeDefaultUrl(templateObject: templateJsonObject) {
                        completion(.web(url: url))
                    }
                }
            }
        }
    }
    
    func openKakaoLink(kakaoLinkType: KakaoLinkType, completion: @escaping () -> Void) {
        switch kakaoLinkType {
        case .app(let url):
            print("앱으로 열기")
            print("url : \(url)")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case .web(let url):
            print("웹으로 열기")
            print("url : \(url)")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .err:
            print("에러")
            completion()
        }
    }
}
