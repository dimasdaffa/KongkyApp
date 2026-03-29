//
//  EventFormFields.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 29/03/26.
//

import SwiftUI

// OOP CONCEPT: "@Binding"
// These subviews don't OWN the data — the parent View does.
// @Binding creates a two-way connection: the subview can
// READ and WRITE the parent's @State variable.

// MARK: - Styled Text Field
// ---------------------------------------------------------
// A reusable text field with our app's consistent styling.
// Used for: Title, Location, Cost, Capacity, etc.
// ---------------------------------------------------------
struct StyledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    var numbersOnly: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.themeTextVariant)
                .tracking(1)
            
            if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .lineLimit(4...8)
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .onChange(of: text) { _, newValue in
                        // If numbersOnly is true, strip out any non-digit characters
                        if numbersOnly {
                            text = newValue.filter { "0123456789".contains($0) }
                        }
                    }
                    .padding(16)
                    .background(Color.themePrimary.opacity(0.05))
                    .cornerRadius(16)
            }
        }
    }
}

// MARK: - Category Picker
// ---------------------------------------------------------
// The horizontal scrolling category buttons.
// Shared between Create and Edit event screens.
// ---------------------------------------------------------
struct CategoryPicker: View {
    @Binding var selectedCategory: String
    let categories: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CATEGORY")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.themeTextVariant)
                .tracking(1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { cat in
                        let isSelected = selectedCategory == cat
                        Button(action: {
                            selectedCategory = cat
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Text(cat)
                                .font(.subheadline)
                                .fontWeight(isSelected ? .semibold : .regular)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(isSelected ? Color.themePrimary : Color(.systemGray6))
                                .foregroundColor(isSelected ? .white : .themeText)
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Toast Notification
// ---------------------------------------------------------
// The floating success message that slides in from the top.
// Used by Create, Edit, and Detail screens.
// ---------------------------------------------------------
struct ToastView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                Text(message)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.themeText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
            .padding(.top, 16)
            
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(2)
    }
}
