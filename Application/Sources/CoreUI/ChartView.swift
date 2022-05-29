//
//  ChartView.swift
//  
//
//  Created by Daniil Shmoylove on 23.05.2022.
//

import SwiftUI
import Resources

public struct ChartView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //MARK: - Properties
    
    private var data: [CGFloat]
    
    private let isShowingPriceLeading: Bool
    
    @State private var percentage: CGFloat = 0
    @State private var currentPlot: String = ""
    @State private var isShowingPlot: Bool = false
    @State private var offset: CGSize = .zero
    @State private var translation: CGFloat = 0
    
    public init(
        for data: [CGFloat],
        isShowingPriceLeading: Bool = true
    ) {
        self.data = data
        self.isShowingPriceLeading = isShowingPriceLeading
    }
    
    //MARK: - Body
    
    public var body: some View {
        VStack {
            GeometryReader { proxy in
                let height = proxy.size.height
                let width = proxy.size.width / CGFloat(self.data.count - 1)
                let maxPoint = (self.data.max() ?? 0) + 100
                let points = data.enumerated().compactMap { item -> CGPoint in
                    let progress = item.element / maxPoint
                    let pathHeight = progress * height
                    let pathWidth = width * CGFloat(item.offset)
                    return CGPoint(x: pathWidth, y: -pathHeight + height)
                }
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                    }
                    .trim(from: 0, to: self.percentage)
                    .stroke(
                        Color.primaryGreen2,
                        style: StrokeStyle(
                            lineWidth: 2.5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .offset(y: -16)
                    
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .primaryGreen2.opacity(0.35),
                            .primaryGreen2.opacity(0.02)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLines(points)
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
                    .opacity(self.percentage)
                    .offset(y: -16)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.linear(duration: 0.6)) {
                            self.percentage = 1.0
                        }
                    }
                }
                .overlay(self.price)
                .background(
                    self.pointer(for: proxy),
                    alignment: .bottomLeading
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation {
                                self.isShowingPlot = true
                            }
                            let translation = value.location.x - 40
                            let index = max(min(Int((translation / width).rounded() + 1), self.data.count - 1), 0)
                            self.currentPlot = "$\(self.data[index])"
                            self.translation = translation
                            self.offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                        }
                        .onEnded { value in
                            withAnimation {
                                self.isShowingPlot = false
                            }
                        }
                )
            }
            .frame(height: 196)
            
            HStack {
                Text("Today")
                    .frame(maxWidth: .infinity)
                Text("Week")
                    .frame(maxWidth: .infinity)
                    .padding(7)
                    .background(Color(uiColor: self.colorScheme == .light ? .white : .secondarySystemFill))
                    .cornerRadius(24)
                    .padding(4)
                    .shadow(color: .black.opacity(0.075), radius: 8)
                Text("Month")
                    .frame(maxWidth: .infinity)
                Text("Year")
                    .frame(maxWidth: .infinity)
                Text("All")
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(.secondary)
            .font(.system(size: 12, weight: .semibold))
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(24)
        }
        .padding(8)
    }
}

private extension ChartView {
    
    //MARK: - Get average of data
    
    private func getAverage() -> CGFloat {
        self.data.reduce(0, +) / CGFloat(self.data.count)
    }
    
    //MARK: - Price stats
    
    @ViewBuilder
    private var price: some View {
        if self.isShowingPriceLeading {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(self.data.max() ?? 0, format: .currency(code: "USD"))
                        .padding(2)
                    Spacer()
                    Text(self.getAverage(), format: .currency(code: "USD"))
                        .padding(2)
                    Spacer()
                    Text(self.data.min() ?? 0, format: .currency(code: "USD"))
                        .padding(2)
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
    
    //MARK: - Gesture pointer
    
    private func pointer(for proxy: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Text(self.currentPlot)
                .font(.system(size: 14, weight: .bold))
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .cornerRadius(8)
                .offset(x: self.translation < 10 ? 30 : 0)
                .offset(x: self.translation > proxy.size.width - 60 ? -30 : 0)
                .padding(.bottom)
            
            Circle()
                .fill(.primary)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle()
                        .fill(Color(uiColor: .systemBackground))
                        .frame(width: 8, height: 8)
                )
            Rectangle()
                .fill(.gray)
                .frame(width: 1.5)
        }
        .frame(width: 80, height: 170)
        .opacity(self.isShowingPlot ? 1 : 0)
        .offset(y: 100)
        .offset(self.offset)
    }
}

#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(
            for: Array((0...45).map { CGFloat($0 * Int.random(in: 0...10)) })
        )
        .preferredColorScheme(.light)
    }
}
#endif
