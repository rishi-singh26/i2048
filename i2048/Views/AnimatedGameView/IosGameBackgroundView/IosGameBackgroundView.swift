//
//  CarouselWithPagerView.swift
//  CarouselSetup
//
//  Created by Rishi Singh on 19/12/24.
//

#if os(iOS)
import SwiftUI

struct IosGameBackgroundView<Content: View, TitleContent: View, PagingSliderItem: RandomAccessCollection>: View where PagingSliderItem: MutableCollection, PagingSliderItem.Element: Identifiable {
    @Binding var data: PagingSliderItem
    @ViewBuilder var content: (Binding<PagingSliderItem.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<PagingSliderItem.Element>) -> TitleContent
    
    ///View properties
    @State private var activeId: UUID?
    
    init(data: Binding<PagingSliderItem>, content: @escaping (Binding<PagingSliderItem.Element>) -> Content, titleContent: @escaping (Binding<PagingSliderItem.Element>) -> TitleContent, activeId: UUID? = nil) {
        self._data = data
        self.content = content
        self.titleContent = titleContent
        self.activeId = activeId
    }
    
    var body: some View {
        VStack(spacing: 2.0) {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach($data) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    /// ios 17 API
                                    content
                                        .offset(x: -(geometryProxy.bounds(of: .scrollView)?.minX ?? 0) * 1.0)
                                }
                            
                            content(item)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                /// Adding Paging
                .scrollTargetLayout()
            }
            /// iOS 17 APIs
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeId)
            
//            PagingSlider(numberOfPages: data.count, activePage: activePage) { value in
//                /// Update to current page
//                if let index = value as? PagingSliderItem.Index, data.indices.contains(index) {
//                    if let id = data[index].id as? UUID {
//                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
//                            activeId = id
//                        }
//                    }
//                }
//            }
        }
    }
    
    var activePage: Int {
        if let index = data.firstIndex(where: { $0.id as? UUID == activeId }) as? Int {
            return index
        }
        
        return 0
    }
}
#endif
