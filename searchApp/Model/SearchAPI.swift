//
//  SearchAPI.swift
//  searchApp
//
//  Created by 정나래 on 2021/02/24.
//

import Foundation
import Combine

class SearchAPI{

}
extension SearchAPI {
    static func request(httpMethod: String, searchWord:String, size:Int, page:Int?) -> AnyPublisher<ResponseData, Error> {

        // 통신 진행할 http Url 구성
        guard var components = URLComponents(url: ApiConfigs.Network.baseUrl, resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't create URLComponents") }

        // url 요청 쿼리 구성하는 부분
        if page != nil {
            // 다음페이지가 있는 경우
            components.queryItems = [URLQueryItem(name: "query", value: searchWord),URLQueryItem(name: "size", value: "\(size)"),URLQueryItem(name: "page", value: "\(page ?? 1)")]
        } else {
            // 다음페이지가 없는 경우
            components.queryItems = [URLQueryItem(name: "query", value: searchWord),URLQueryItem(name: "size", value: "\(size)")]
        }
        var request = URLRequest(url: components.url!)

        // GET방식
        request.httpMethod = httpMethod
        // header정의하는 코드
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        // kakao rest api key 설정
        request.addValue("KakaoAK "+"ff57a658c9de9540cbf89a3d35f32436", forHTTPHeaderField: "Authorization")

        return ApiConfigs.Network.apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}






