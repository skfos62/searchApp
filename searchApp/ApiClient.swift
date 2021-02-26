//
//  ApiClient.swift
//  searchApp
//
//  Created by 정나래 on 2021/02/24.
//

import Foundation
import Combine

// 싱글톤 패턴으로 구현하기 위해서 작성한 urlSesstion코드
struct ApiClient {
    var statusCode = ""
    // value : 객체
    // response : 상태코드를 포함하는 url 응답
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder())  -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                // http status code를 확인하는 곳
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("http status Code: \(httpResponse.statusCode)")
                }

                return Response(value: value, response: result.response)
            }
            // 메인 스레드에 결과 반환
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// api 설정
class ApiConfigs{
    enum Network {
        static let apiClient = ApiClient()
        static let baseUrl = URL(string: "https://dapi.kakao.com/v2/search/image")!
    }
}

