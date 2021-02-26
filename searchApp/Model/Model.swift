//
//  Model.swift
//  searchApp
//
//  Created by 정나래 on 2021/02/24.
//

import Foundation
import Combine


// MARK: 카카오 이미지 검색 리스폰값 모델
class ResponseData :Codable{
    var mata: [Meta]?
    var documents: [Documents]?

    enum CodingKeys: String, CodingKey {
        case mata = "mata"
        case documents = "documents"
    }
}

class Meta :Codable {
    var totalCount: Int?
    var pageableCount: Int?
    var isEnd: Bool?
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

class Documents:Codable{
    var collection: String?
    var thumbnailUrl: String?
    var imageUrl: String?
    var width: Int?
    var height: Int?
    var displaySitename: String?
    var docUrl: String?
    var datetime: String?
    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailUrl = "thumbnail_url"
        case imageUrl = "image_url"
        case width
        case height
        case displaySitename = "display_sitename"
        case docUrl = "doc_url"
        case datetime
    }
}
