//
//  SkeletonView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI

import SwiftUI

struct SkeletonShimmer: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(UIColor.systemGray5), location: 0),
                .init(color: Color(UIColor.systemGray4), location: 0.3),
                .init(color: Color(UIColor.systemGray5), location: 0.5),
                .init(color: Color(UIColor.systemGray4), location: 0.7),
                .init(color: Color(UIColor.systemGray5), location: 1)
            ]),
            startPoint: .init(x: phase - 1, y: 0.5),
            endPoint: .init(x: phase, y: 0.5)
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 2
            }
        }
    }
}

struct SkeletonLoading: View {
    let width: CGFloat
    let height: CGFloat
    var cornerRadius: CGFloat = 8
    var isCircle: Bool = false
    var padding: EdgeInsets = EdgeInsets()
    
    var body: some View {
        Group {
            if isCircle {
                SkeletonShimmer()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
            } else if width == .infinity {
                SkeletonShimmer()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else {
                SkeletonShimmer()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }
        .padding(padding)
    }
}

// ---------------------------------------------------------
// CUSTOM TEMPLATES FOR KONGKY APP CARDS
// ---------------------------------------------------------

// Template for the large Dashboard Card
struct DashboardCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonLoading(width: .infinity, height: 160, cornerRadius: 14)
            
            VStack(alignment: .leading, spacing: 6) {
                SkeletonLoading(width: 150, height: 20)
                SkeletonLoading(width: .infinity, height: 14)
                SkeletonLoading(width: 250, height: 14)
            }
            .padding(.horizontal, 8)
            
            HStack {
                SkeletonLoading(width: 60, height: 16)
                SkeletonLoading(width: 80, height: 16)
                Spacer()
                HStack(spacing: -8) {
                    ForEach(0..<3) { _ in
                        SkeletonLoading(width: 24, height: 24, isCircle: true)
                    }
                }
            }
            .padding(.horizontal, 8).padding(.bottom, 12)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Template for the small Event List Row (Date on the left)
struct EventListCellSkeleton: View {
    var body: some View {
        HStack(spacing: 16) {
            SkeletonLoading(width: 60, height: 60, cornerRadius: 8)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonLoading(width: 140, height: 18)
                SkeletonLoading(width: 200, height: 14)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            DashboardCardSkeleton()
            EventListCellSkeleton()
            HStack(spacing: 12) {
                SkeletonLoading(width: 48, height: 48, isCircle: true)

                VStack(alignment: .leading, spacing: 8) {
                    SkeletonLoading(width: 120, height: 16)
                    SkeletonLoading(width: 220, height: 12)
                }

                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
        }
        .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
}
