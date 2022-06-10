//
//  SegmentPickerView.swift
//  
//
//  Created by Daniil Shmoylove on 10.06.2022.
//

import SwiftUI
import Resources

//MARK: - CustomSegmentedPickerStyle

public struct CustomSegmentedPickerView: View {
    public init(
        content: [String],
        selection: Binding<Int>
    ) {
        self.content = content
        self._selection = selection
    }
    
    @Namespace private var namespace
    
    @Binding private var selection: Int
    
    private let content: [String]
    
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
                    tab: index
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 36)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(24)
    }
}

//MARK: - Typealias

public typealias SegmentPicker = CustomSegmentedPickerView

//MARK: - CustomSegmentedPickerItemView

fileprivate struct CustomSegmentedPickerItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var currentItem: Int
    
    let namespace: Namespace.ID
    let itemName: String
    let tab: Int
    
    var body: some View {
        Button {
            
            //MARK: - Move to current tab
            
            self.currentItem = tab
        } label: {
            
            //MARK: - Button label
            
            Text(LocalizedStringKey(self.itemName))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(self.currentItem == tab ? .primaryBlue : .secondary)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        if currentItem == tab {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(uiColor: self.colorScheme == .light ? .white : .secondarySystemFill))
                                .frame(height: 36)
                                .shadow(color: .black.opacity(0.075), radius: 8)
                            
                                .matchedGeometryEffect(
                                    id: "underline",
                                    in: self.namespace,
                                    properties: .frame
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.clear)
                                .frame(height: 36)
                                .shadow(color: .black.opacity(0.075), radius: 8)
                        }
                    }
                )
                .animation(.spring(), value: self.currentItem)
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
