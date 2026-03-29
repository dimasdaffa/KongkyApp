//
//  MyActivitiesView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 15/03/26.
//

import SwiftUI
import FirebaseAuth

struct MyActivitiesView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedTab = "Joined"
    let tabs = ["Joined", "Hosted"]
    
    // Modal States
    @State private var eventToEdit: Event?
    @State private var showCreateForm = false
    
    // Leave States
    @State private var showCancelSheet = false
    @State private var eventToLeave: Event? = nil
    
    // NEW: Delete States
    @State private var showDeleteAlert = false
    @State private var eventToDelete: Event? = nil
    
    // Toast States
    @State private var showToast = false
    @State private var toastMessage = "" // Made dynamic so it can handle both actions!
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.themeSurface.ignoresSafeArea()
            
            VStack(spacing: 0) {
                customTabSwitcher
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        let currentUserEmail = Auth.auth().currentUser?.email ?? ""
                        
                        let filteredEvents = selectedTab == "Hosted"
                        ? viewModel.events.filter { $0.organizerEmail == currentUserEmail }
                        : viewModel.events.filter { $0.organizerEmail != currentUserEmail }
                        
                        if filteredEvents.isEmpty {
                            emptyState
                        } else {
                            ForEach(filteredEvents) { event in
                                ActivityRowCard(
                                    event: event,
                                    isHosted: selectedTab == "Hosted",
                                    onEdit: { eventToEdit = event },
                                    onDelete: {
                                        // Trigger the Delete Alert!
                                        eventToDelete = event
                                        showDeleteAlert = true
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    },
                                    onLeave: {
                                        // Trigger the Leave Alert!
                                        eventToLeave = event
                                        showCancelSheet = true
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                )
                            }
                        }
                        ctaSection
                        
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            if showToast {
                toastNotification
            }
        }
        .navigationTitle("My Activities")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.hidden, for: .tabBar)
        .sheet(item: $eventToEdit) { selectedEvent in
            EditEventView(viewModel: viewModel, event: selectedEvent)
        }
        .sheet(isPresented: $showCreateForm) {
            CreateEventView(viewModel: viewModel)
        }
        // ALERT 1: LEAVING AN ACTIVITY
        .alert(
            "Leave Activity?",
            isPresented: $showCancelSheet,
            presenting: eventToLeave
        ) { event in
            Button("Cancel", role: .cancel) {
                eventToLeave = nil
            }
            Button("Leave", role: .destructive) {
                confirmLeave(event: event)
            }
        } message: { event in
            Text("Give up your spot for \(event.title)?")
        }
        // ALERT 2: DELETING AN ACTIVITY (NEW!)
        .alert(
            "Delete Activity?",
            isPresented: $showDeleteAlert,
            presenting: eventToDelete
        ) { event in
            Button("Cancel", role: .cancel) {
                eventToDelete = nil
            }
            Button("Delete", role: .destructive) {
                confirmDelete(event: event)
            }
        } message: { event in
            Text("Are you sure you want to permanently delete \(event.title)? This cannot be undone.")
        }
    }
    
    // MARK: - Subviews
    
    private var customTabSwitcher: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                let isSelected = selectedTab == tab
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    Text(tab)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .bold : .medium)
                        .foregroundColor(isSelected ? .themeText : .themeTextVariant)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                                }
                            }
                        )
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.themePrimary.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: selectedTab == "Hosted" ? "calendar.badge.plus" : "ticket")
                    .font(.system(size: 32))
                    .foregroundColor(.themePrimary)
            }
            .padding(.top, 40)
            
            Text(selectedTab == "Hosted" ? "No hosted events yet." : "Your itinerary is empty.")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.themeText)
            
            Text(selectedTab == "Hosted"
                 ? "Create your first gathering and invite friends to split the cost."
                 : "Explore the dashboard to find your next favorite hangout.")
            .font(.subheadline)
            .foregroundColor(.themeTextVariant)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
        }
        .padding(.bottom, 32)
    }
    
    private var ctaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Curate your next experience")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Text("Bring people together, split the costs effortlessly, and make memories.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
            
            Button(action: {
                showCreateForm = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }) {
                Text("Host an Activity")
                    .font(.headline)
                    .foregroundColor(.themePrimary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(24)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.themePrimary, Color(red: 0, green: 112/255, blue: 235/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(30)
        .padding(.top, 24)
    }
    
    private var toastNotification: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.themePrimary)
                
                // Using the dynamic message variable!
                Text(toastMessage)
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
    
    // MARK: - Actions
    
    func confirmLeave(event: Event) {
        // FIREBASE FIX: Rather than deleting the event, we reduce the participant count
        // and tell Firebase to update it.
        var updatedEvent = event
        if updatedEvent.joinedParticipants > 0 {
            updatedEvent.joinedParticipants -= 1
        }
        viewModel.updateEvent(event: updatedEvent)
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        toastMessage = "You have left the activity."
        showToastSequence()
        eventToLeave = nil
    }
    
    func confirmDelete(event: Event) {
        // FIREBASE FIX: Ask the viewModel to delete this document from Firestore!
        // The SnapshotListener will automatically remove it from the screen.
        viewModel.deleteEvent(event: event)
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        toastMessage = "Activity permanently deleted."
        showToastSequence()
        eventToDelete = nil
    }
    
    // Helper to fire the toast animation cleanly
    private func showToastSequence() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
        }
    }
}

// MARK: - Custom Activity Card
struct ActivityRowCard: View {
    let event: Event
    let isHosted: Bool
    
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onLeave: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Date Block
            VStack(spacing: 4) {
                let parts = event.date.replacingOccurrences(of: "\n", with: " ").components(separatedBy: " ")
                Text(parts.first?.prefix(3).uppercased() ?? "MTH")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.themePrimary)
                
                Text(parts.count > 1 ? parts[1] : "00")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(.themeText)
            }
            .frame(width: 60, height: 60)
            .background(Color(.systemGray6).opacity(0.6))
            .cornerRadius(16)
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.themeText)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption2)
                    Text(event.location)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundColor(.themeTextVariant)
            }
            
            Spacer()
            
            // The Context Menu ("...")
            Menu {
                if isHosted {
                    Button(action: onEdit) {
                        Label("Edit Activity", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete Activity", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive, action: onLeave) {
                        Label("Leave Activity", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(.systemGray4))
                    .frame(width: 44, height: 44)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.themeText.opacity(0.04), radius: 20, x: 0, y: 4)
    }
}

#Preview {
    NavigationView {
        MyActivitiesView()
    }
}
