//
//  ContentView.swift
//  searchApp
//
//  Created by 정나래 on 2021/02/24.
//

import SwiftUI
import UIKit.UICollectionViewCell

struct ContentView: View {

    @ObservedObject var viewModel:ViewModel = ViewModel()
    @State var selection: Bool? = false
    @State var itemIndex: Int?
    @State var page: Int = 1

    @State private var showCancelButton: Bool = false
    var body: some View {
        NavigationView {
            if viewModel.isDone {
                ZStack{
                    VStack{
                        ProgressView()
                        Text("데이터를 불러오는 중 입니다...")
                    }
                }

            } else {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("search", text: $viewModel.searchWord, onEditingChanged: { isEditing in
                                self.showCancelButton = true
                            }, onCommit: {
                                viewModel.isDone.toggle()
                                viewModel.document.removeAll()
                                viewModel.fetchData(page: page)
                            }).foregroundColor(.primary)

                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)

                        // 취소하기 버튼 설정
                        if showCancelButton  {
                            Button("Cancel") {
                                UIApplication.shared.endEditing(true)
                                viewModel.searchWord = ""
                                viewModel.searchState = "검색어를 입력해주세요."
                                self.showCancelButton = false
                                viewModel.document.removeAll()
                            }
                            .foregroundColor(Color(.systemBlue))
                        }

                    }
                    .padding(.horizontal)
                    .navigationBarTitle(Text("SearchApp"))
                    .navigationBarHidden(showCancelButton)
                    .resignKeyboardOnDragGesture()
                    .animation(.spring())

                    // collectionview 보여주는 곳
                    if viewModel.document.count != 0 {
                        CollectionView(data: $viewModel.document, selection: $selection, itemIndex: $itemIndex, page: $page, viewModel: viewModel)
                        // 뷰모델에 있는 document에 데이터가 있는경우
                        NavigationLink(destination: DetailView(Index: itemIndex ?? 0, displaySiteNanme: viewModel.document[itemIndex ?? 0].displaySitename ?? "", datetime: viewModel.document[itemIndex ?? 0].datetime ?? "",ImageUrl: viewModel.document[itemIndex ?? 0].imageUrl ?? ""), tag: true, selection: $selection,
                                       label: {
                                       })
                    } else {
                        // 뷰모델에 있는 document에 데이터가 없는경우
                        VStack{
                            Spacer()
                            Text(viewModel.searchState)
                            Spacer()
                        }
                    }

                }
            }



        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: -- 구조체 선언부

// MARK: uisearchbar 구조체
struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    @ObservedObject var viewModel:ViewModel
    var placeholder: String
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        //        viewModel.fetchData(searchWord: text, page: 1)
    }
}

// MARK: collectionview 구조체
struct CollectionView: UIViewRepresentable {
    @Binding var data:[Documents]
    @Binding var selection: Bool?
    @Binding var itemIndex: Int?
    @Binding var page: Int
    @ObservedObject var viewModel:ViewModel
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width/3)-3, height: (UIScreen.main.bounds.size.width/3)-3)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 1

        // collectionview 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        // 검색어를 입력한뒤 uiview 업데이트
        uiView.reloadData()

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 래핑한 uicollectionview
    private let parent: CollectionView

    init(_ collectionView: CollectionView) {
        self.parent = collectionView
    }
    // 몇개의 cell을 띄울것인지?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.parent.data.count
    }
    // cell ui 설정하는 곳
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        // image url을 uiImageview로 바꿔줌
        var foregroundImage = UIImage(systemName: "paperplane.fill")
        let url = URL(string: parent.data[indexPath.item].thumbnailUrl ?? "")
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            foregroundImage = UIImage(data: imageData)
        }
        // cell에 이미지뷰 추가
        let foregroundImageView = UIImageView(image: foregroundImage)
        foregroundImageView.sizeToFit()
        foregroundImageView.layer.masksToBounds = true
        cell.addSubview(foregroundImageView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width/3)-3
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parent.itemIndex = indexPath.item
        parent.selection = true

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == parent.data.count - 1 ) {
            // collectionview의 스크롤이 하단에 닿을때 다음 페이지 요청
            parent.viewModel.fetchData(page: parent.viewModel.pageNum)
        }
    }
}

// MARK: -- 키보드 & 뷰 & UIimageView 설정
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

