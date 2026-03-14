//
//  ActivityDetailView.swift
//  KongkyApp
//
//  Created by DIMAS DAFFA ERNANDA on 14/03/26.
//

import SwiftUI

struct ActivityDetailView: View {
    let event: Event
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 250)
                    .cornerRadius(14)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Image(systemName: event.iconName)
                            .font(.title2)
                        Text(event.title)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                HStack(spacing: 12){
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                    
                    VStack(alignment: .leading){
                        Text("Event by")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(event.organizerName)
                            .font(.headline)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Details")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    DetailRow(title: "Cost", value: "Rp \(event.cost) / pax")
                    Divider()
                    DetailRow(title: "Date", value: event.date.replacingOccurrences(of: "\n", with: " "))
                    Divider()
                    DetailRow(title: "Time", value: event.time)
                    Divider()
                    DetailRow(title: "Place", value: event.location)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle("Activity Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationView {
            ActivityDetailView(event: Event(
                title: "Bukber Bersama",
                description: "Lunch together at the famous local spot. Don't forget to bring your appetite!",
                location: "Sederhana Sudirman",
                date: "Jun 20",
                time: "12:00 - 13:00",
                cost: 35000,
                organizerName: "Dimas Daffa",
                availableSeats: 4,
                category: "Makan Bersama"
            ))
        }
}
