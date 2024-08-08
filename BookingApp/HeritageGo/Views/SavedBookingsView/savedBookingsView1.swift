//
//  savedBookingsView1.swift
//  A1
//
//  Created by Amru Hashim on 2/5/24.
//

import SwiftUI
import CoreData

struct savedBookingsView1: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Booking.entity(),
        sortDescriptors: []
    ) private var bookings: FetchedResults<Booking>

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Swipe left on a booking to delete")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                            .padding(.vertical)
                ) {
                    ForEach(bookings) { booking in
                        BookingRow(booking: booking)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }
                    .onDelete(perform: deleteBookings)
                }
            }
            .navigationTitle("Bookings")
            .listStyle(PlainListStyle())
        }
    }

    private func deleteBookings(at offsets: IndexSet) {
        for index in offsets {
            let booking = bookings[index]
            viewContext.delete(booking)
        }
        try? viewContext.save()
    }
}





struct BookingRow: View {
    let booking: Booking

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let event = booking.event {
                Text(event)
                    .fontWeight(.bold)
                    .font(.title3)
            } else {
                Text("No event specified")
                    .fontWeight(.bold)
                    .font(.title3)
            }

            Text(formatDate(booking.selectedDate))
                .fontWeight(.semibold)
                .font(.body)

            HStack(spacing: 10) {
                Text("Start time:")
                Text(booking.startTime ?? "not specified")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("End time:")
                Text(booking.endTime ?? "not specified")
                    .fontWeight(.bold)
            }
            .font(.body)

            Divider().background(Color.black)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("$\(String(format: "%.2f", booking.pricePerVisitor)) X \(booking.numberOfVisitors)")
                    Spacer()
                    Text(String(format: "AU$%.2f", booking.subtotal))
                }

                if booking.discount > 0 {
                    HStack {
                        Text("Discount")
                        Spacer()
                        Text(String(format: "- AU$%.2f", booking.discount))
                    }
                }

                HStack {
                    Text("Total").fontWeight(.bold)
                    Spacer()
                    Text(String(format: "AU$%.2f", booking.total)).fontWeight(.bold)
                }
            }
            .padding(.top, 10)
        }
        .padding()
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No date specified" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}
