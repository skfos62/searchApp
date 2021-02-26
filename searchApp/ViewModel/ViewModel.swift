//
//  ViewModel.swift
//  searchApp
//
//  Created by 정나래 on 2021/02/25.
//

import Foundation
import Combine

class ViewModel:ObservableObject {
    @Published var searchWord:String = ""
    // 서버에서 받아오는 respone datas
    @Published var responeData:ResponseData = ResponseData()
    @Published var document:[Documents] = []
    @Published var data:Documents = Documents()
    @Published var pageNum:Int = 1
    // 어플의 상태에 따라서 바뀌는 글씨
    @Published var searchState:String = "검색어를 입력해주세요."
    @Published var isDone:Bool = false

    // 서버에 데이터 요청
    var cancellable: AnyCancellable?
    func fetchData(page:Int) {
        cancellable = SearchAPI.request(httpMethod: "GET", searchWord: searchWord, size: 30, page: page)// 4
                   .mapError({ (error) -> Error in // 5
                       print("에러로그입니다 : \(error)" )
                       return error
                   })
                   .sink(receiveCompletion: { _ in }, // 6
                         receiveValue: {
                            // 서버 요청 후 데이터 받아오는곳
                            let count = $0.documents?.count ?? 0
                            // 서버에서 받아온 데이터의 갯수가 0개 이상일경우
                            if count != 0 {
                                for i in 0...count-1 {
                                    let appendData = $0.documents?[i]
                                    self.document.append(appendData ?? Documents())
                                }
                                print("로그2: \(self.document.count)")
                                self.pageNum = self.pageNum+1
                                // 최초 데이터 불러올때만 progressbar
                                if self.pageNum < 3 {                                    self.isDone.toggle()
                                }
                            } else {
                                // 서버에서 받아온 데이터의 갯수가 0개 이하일경우 (없는경우)
                                self.searchState = "검색결과가 없습니다"
                                self.isDone.toggle()
                            }

                    })
    }
}

