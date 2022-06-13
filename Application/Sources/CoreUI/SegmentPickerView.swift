//
//  SegmentPickerView.swift
//  
//
//  Created by Daniil Shmoylove on 10.06.2022.
//

import SwiftUI
import Resources
import Services

//MARK: - CustomSegmentedPickerStyle

public struct CustomSegmentedPickerView: View {
    public init(
        content: [String],
        selection: Binding<Int>,
        segmentColor: Color = Color(uiColor: .systemGray6),
        backgroundColor: Color = Color.clear
    ) {
        self.content = content
        self._selection = selection
        self.segmentColor = segmentColor
        self.backgroundColor = backgroundColor
    }
    
    @Namespace private var namespace
    
    @Binding private var selection: Int
    
    private let content: [String]
    private let segmentColor: Color
    private let backgroundColor: Color
    
    public var body: some View {
        HStack(alignment: .center) {
            ForEach(
                Array(
                    zip(
                        self.content.indices,
                        self.content
                    )
                ),
                id: \.0
            ) { index, item in
                CustomSegmentedPickerItemView(
                    currentItem: self.$selection,
                    namespace: self.namespace,
                    itemName: item,
                    tab: index,
                    segmentColor: self.segmentColor
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 36)
        .background(self.backgroundColor)
        .cornerRadius(24)
    }
}

//MARK: - Typealias

public typealias SegmentPicker = CustomSegmentedPickerView

//MARK: - CustomSegmentedPickerItemView

fileprivate struct CustomSegmentedPickerItemView: View {
    @Binding var currentItem: Int
    
    let namespace: Namespace.ID
    let itemName: String
    let tab: Int
    let segmentColor: Color
    
    var body: some View {
        
        //MARK: - Button label
        
        Text(LocalizedStringKey(self.itemName))
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.primary)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(self.segmentShape)
            .animation(
                .spring(
                    response: 0.7,
                    dampingFraction: 0.7,
                    blendDuration: 0
                ),
                value: self.currentItem
            )
            .onTapGesture {
                
                //MARK: - Move to current tab
                
                self.currentItem = tab
                
                //MARK: - Haptic engine
                
                HapticService.impact(style: .medium)
            }
    }
    
    @ViewBuilder
    private var segmentShape: some View {
        if currentItem == tab {
            RoundedRectangle(cornerRadius: 24)
                .fill(self.segmentColor)
                .matchedGeometryEffect(
                    id: "underline",
                    in: self.namespace,
                    properties: .frame
                )
        } else {
            Rectangle()
                .fill(Color(uiColor: .systemBackground))
                .opacity(0.001)
        }
    }
}

#if DEBUG
struct CustomSegmentedPickerView_Previews: PreviewProvider {
    private struct Test: View {
        @State private var selection = 0
        var body: some View {
            SegmentPicker(
                content: [
                    "1d", "1w", "1m", "1y", "5y"
                ],
                selection: self.$selection
            )
        }
    }
    static var previews: some View {
        Test()
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
    }
}
#endif
