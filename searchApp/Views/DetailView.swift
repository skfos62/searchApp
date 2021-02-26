//
//  DetailView.swift
//  searchApp
//
//  Created by 정나래 on 2021/02/25.
//

import SwiftUI

struct DetailView: View {
    @State var Index:Int
    @State var displaySiteNanme:String
    @State var datetime:String
    @State var ImageUrl:String
    var body: some View {
        // 이미지 클릭 후 상세보기 페이지
        ScrollView{
            VStack(alignment:.leading){
                Image(uiImage: ImageUrl.load())
                    .resizable()
                    .frame(width: .infinity)
                    .scaledToFit()
                HStack{
                    Text("출처")
                        .foregroundColor(.gray)
                    Text("\(displaySiteNanme)")
                }
                .padding([.leading,.trailing])
                HStack{
                    Text("작성시간")
                        .foregroundColor(.gray)
                    Text("\(datetime)")
                }
                .padding([.leading,.trailing])
            }

        }
        .navigationTitle("상세보기")
    }
}
//
//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(Index: 0, ImageUrl: <#Int#>)
//    }
//}


// 서버에서 받아오는 imageurl을 사용할수있게 만들어주는 extention
extension String {
    func load() -> UIImage {
        do {
            // string을 url객체로 변환하는곳
            guard let url = URL(string: self) else {
                // 빈 이미지일 경우 url
                return UIImage()
            }
            // url을 데이터로 변환
            let data:Data = try Data(contentsOf: url)
            // uiimage 오브젝트 생성
            // 옵셔널 value일경우는 그냥 이미지 사용
            return UIImage(data: data) ?? UIImage()
        } catch {

        }
        return UIImage()
    }
}
