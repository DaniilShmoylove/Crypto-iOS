//
//  CircleFieldsView.swift
//  
//
//  Created by Daniil Shmoylove on 14.06.2022.
//

import SwiftUI

struct CircleFieldsView: View {
    init(
        for value: String
    ) {
        self.value = value
    }
    
    @State private var isAppear: Bool = false
    private var value: String
    
    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible()),
                count: 4
            )
        ) {
            ForEach(0..<4) { item in
                Circle()
                    .fill(item < self.value.count ? Color.primaryBlue : Color(UIColor.secondarySystemFill)
                    )
                    .frame(
                        width: item < self.value.count ? 22 : 14,
                        height: item < self.value.count ? 22 : 14
                    )
                    .scaleEffect(self.isAppear ? 1 : 0)
                    .animation(.spring(), value: self.value.count)
            }
        }
        .frame(width: 156, height: 48)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) {
                    self.isAppear = true
                }
            }
        }
    }
}

#if DEBUG
struct CircleFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CircleFieldsView(for: "123")
    }
}
#endif 
