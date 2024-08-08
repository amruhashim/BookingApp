//
//  savedBookingsView2.swift
//  A1
//
//  Created by Amru Hashim on 2/5/24.
//

import SwiftUI
import CoreData

struct savedBookingsView2: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Booking.entity(),
        sortDescriptors: []
    ) private var bookings: FetchedResults<Booking>
    
    @State private var showingSaveConfirmation = false

    var body: some View {
        VStack {
            
            Image(systemName: "arrow.down")
                .foregroundColor(.blue)
                .font(.title)
                .padding(.top)
            
            Text("Swipe down to close")
                .foregroundColor(.blue)
                .font(.footnote)
                .padding(.bottom)

          
            NavigationView {
                List {
                    Section {
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
                    } footer: {
                        Text("Swipe left on a booking to delete")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                            .padding(.vertical)
                    }
                }
                .navigationTitle("Bookings")
                .listStyle(PlainListStyle())
            }
            .onAppear {
                showingSaveConfirmation = true
            }
            .alert(isPresented: $showingSaveConfirmation) {
                Alert(
                    title: Text("Booking Saved"),
                    message: Text("Hope to see you soon!"),
                    dismissButton: .default(Text("OK"))
                )
            }
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


