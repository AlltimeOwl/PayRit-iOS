//
//  CardSelectionView.swift
//  PayRit
//
//  Created by 임대진 on 4/22/24.
//

import SwiftUI

struct ColorValue: Identifiable {
    var id: UUID = .init()
    var color: Color
}
struct ImageIdentifier: Hashable {
    var id: UUID = .init()
    let name: String
}

struct CardSelectionViewTests: View {
    @State var colors: [ColorValue] = [.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint].compactMap { color -> ColorValue? in return .init(color: color)
    }
    
    let imageIdentifiers = ["blueCard", "blueCard"].map { ImageIdentifier(name: $0) }
    
    @State var activeIndex: Int = 0
    var body: some View {
        GeometryReader { geometryReader in
            VStack {
//                Spacer(minLength: 0)
                CircleLayOut(items: imageIdentifiers, id: \.self, spacing: 80) { image, index, _ in
                    Image(image.name)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 16))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                } onIndexChange: { index in
                    activeIndex = index
                }
                .padding(.horizontal, -100)
                .frame(width: geometryReader.size.width, height: geometryReader.size.width / 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(15)
    }
}

#Preview {
    CardSelectionViewTests()
}

struct CircleLayOut<Content: View, Item: RandomAccessCollection>: View where Item.Element == ImageIdentifier { // 변경된 부분
    var content: (Item.Element, Int, CGFloat) -> Content
    var KeyPathID: KeyPath<Item.Element, ImageIdentifier>
    var items: Item
    var spacing: CGFloat?
    var onIndexChange: (Int) -> ()
    init(items: Item, id: KeyPath<Item.Element, ImageIdentifier>, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Item.Element, Int, CGFloat) -> Content, onIndexChange: @escaping (Int) -> ()) {
        self.content = content
        self.onIndexChange = onIndexChange
        self.spacing = spacing
        self.KeyPathID = id
        self.items = items
    }
    
    @State var dragRotation: Angle = .zero
    @State var lastDragRotation: Angle = .zero
    var body: some View {
        GeometryReader { geometryProxy in
            let size = geometryProxy.size
            let width = size.width
            let count = CGFloat(items.count)
            let spacing: CGFloat = spacing ?? 0
            let viewSize = (width - spacing) / (count / 2)
            
            ZStack {
                ForEach(items.reversed(), id: \.self) { item in
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index - Int(count) / 2) / count) * 240.0
                    content(item, index, viewSize)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(.init(degrees: -rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        .offset(x: (width - viewSize) / 2)
                        .rotationEffect(.init(degrees: -90))
                        .rotationEffect(.init(degrees: rotation))
                }
            }
            .frame(width: width, height: width)
            .contentShape(.rect)
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationX = value.translation.width
                        
                        let progress = translationX / (viewSize * 2)
                        let rotationFraction = 360.0 / count
                        
                        dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        calculateIndex(count)
                    }).onEnded({ value in
                        let velocityX = value.velocity.width / 15
                        let translationX = value.translation.width + velocityX
                        
                        let progress = (translationX / (viewSize * 2)).rounded()
                        let rotationFraction = 360.0 / count
                        withAnimation(.smooth) {
                            dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        }
                        lastDragRotation = dragRotation
                        calculateIndex(count)
                    })
            )
        }
    }
    
    func calculateIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded().truncatingRemainder(dividingBy: count)
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : count - activeIndex)
        print(activeIndex)
    }
    
    func fetchIndex(_ item: Item.Element) -> Int {
        if let index = items.firstIndex(where: {
            $0.id == item.id
        }) as? Int {
            return index
        }
        return 0
    }
}
