//
//  BookingView.swift
//  A1
//
//  Created by Amru Hashim on 2/3/24.
//

import SwiftUI
import CoreData


struct BookingDetailView: View {
    
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var event: String
    @Binding var show: Bool
    @State private var startTime: String = "not available"
    @State private var endTime: String = "not available"
    @State private var subtotal: Double = 0.0
    @State private var discount: Double = 0.0
    @State private var total: Double = 0.0
    @State private var showDiscountAlert = false
    @State private var showAlert = false
    @State private var navigateToSavedBookings = false
    @State private var pricePerVisitor: Double = 0.0
    @State private var selectedDate: Date = Date() {
        didSet {
            calculatePricing()
        }
    }
    
    @State private var numberOfVisitors: Int = 1 {
        didSet {
            calculatePricing()
        }
    }
    
   
    // MARK: - Date Formatter
    var dayOfWeekFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
    
   
    // MARK: - Computed Binding for Number of Visitors
    var numberOfVisitorsString: Binding<String> {
        Binding<String>(
            get: { String(self.numberOfVisitors) },
            set: {
                if let value = Int($0) {
                    self.numberOfVisitors = value
                }
            }
        )
    }
    
  
    // MARK: - Methods
    func updateSelectedTimeSlotForDate(_ date: Date) {
        let newTimeSlots = generateTimeSlots(for: event, on: date)
        DispatchQueue.main.async {
            self.startTime = newTimeSlots.first ?? "not available"
        }
    }
    
    
    private var timeSlots: [String] {
        generateTimeSlots(for: event, on: selectedDate)
    }
    
    
   
    var body: some View {
        VStack {
            Text(event)
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
                .foregroundColor(.black)
                .font(.system(size: 30))
                .padding(.top, -70)
            
            VStack(alignment: .leading, spacing: 10) {
                

                // MARK: - Date Picker
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Date: \(dayOfWeekFormatter.string(from: selectedDate))")
                               .fontWeight(.semibold)
                               .foregroundColor(.black)
                               .font(.system(size: 20))
                               .padding(.bottom, 3)
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .onChange(of: selectedDate) { _ in
                                updateSelectedTimeSlotForDate(selectedDate)
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 40)
                }
                
 
                // MARK: - Time Picker and Ending Time
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Starting time:")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .padding(.bottom, 3)
                        Picker("Select Time", selection: $startTime) {
                            ForEach(timeSlots, id: \.self) { slot in
                                Text(slot).tag(slot)
                            }
                            Text("not available").tag("not available")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0), lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        )
                        .padding(.top, 5)
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Ending time:")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .padding(.bottom, 7)
                        Text(endTime)
                            .padding()
                            .frame(width: 135, height: 32)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0)
                            )
                    }
                    .padding(.horizontal, 0)
                }
                .padding(.top, 10)


                // MARK: - Number of Visitors
                VStack(alignment: .leading, spacing: 10) {
                    Text("Number of visitors:")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.horizontal, 40)
                    
                    HStack {
                        Button(action: {
                            self.decrement()
                        }) {
                            Text("-")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        
                        TextField("Number", text: numberOfVisitorsString)
                            .keyboardType(.numberPad)
                            .frame(width: 60, height: 44)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                        
                        Button(action: {
                            self.increment()
                        }) {
                            Text("+")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.top, 20)
                
 
                // MARK: - INVOICE
                VStack {
                    Button(action: {
                        self.showDiscountAlert = true
                    }) {
                        Text("Add discount").padding()
                    }
                    .alert(isPresented: $showDiscountAlert) {
                        Alert(
                            title: Text("Discount Information"),
                            message: Text("10% discount for 4+ visitors only"),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    HStack {
                        Text("Summary").bold()
                        Spacer()
                        VStack {
                            HStack {
                                Text("$\(String(format: "%.2f", pricePerVisitor)) X (\(numberOfVisitors))")
                                Spacer()
                                Text(String(format: "AU$%.2f", subtotal))
                            }

                            HStack {
                                Text("Discount")
                                Spacer()
                                Text(String(format: "-AU$%.2f", discount))
                            }
                            HStack {
                                Text("Total")
                                Spacer()
                                Text(String(format: "AU$%.2f", total))
                            }
                        }.frame(width: 200)
                    }.padding()
                }.background(Color.white.opacity(1))
                    .padding(.top, 50)

                // NavigationLink for programmatic navigation
                            NavigationLink(destination: savedBookingsView2(), isActive: $navigateToSavedBookings) {
                                EmptyView() 
                            }

                            Spacer()
                            Button(action: {
                                if startTime == "not available" {
                                    showAlert = true
                                } else {
                                    saveBooking()
                                }
                            }) {
                                Text("Confirm")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 40))
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text("Please recheck and choose a relevant date/time"),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            .padding(.horizontal, 30)
                        }
            
            .onAppear {
                let initialTimeSlots = generateTimeSlots(for: event, on: selectedDate)
                self.startTime = initialTimeSlots.first ?? "not available"
            }
            .onChange(of: startTime) { _ in
                updateEndTime()
            }
            .onAppear {
                self.calculatePricing()
            }
            .onChange(of: selectedDate) { _ in
                self.calculatePricing()
            }
            .onChange(of: numberOfVisitors) { _ in
                self.calculatePricing()
            }
            Spacer()
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.yellow.edgesIgnoringSafeArea(.all))
    }

    func saveBooking() {
        // Create a new Booking instance in the managed object context
        let newBooking = Booking(context: viewContext)
        newBooking.event = event
        newBooking.startTime = startTime
        newBooking.endTime = endTime
        newBooking.selectedDate = selectedDate
        newBooking.numberOfVisitors = Int16(numberOfVisitors)
        newBooking.pricePerVisitor = pricePerVisitor
        newBooking.subtotal = subtotal
        newBooking.discount = discount
        newBooking.total = total

        // Print the values for debugging
        print("Saved Booking:")
        print("Event: \(event)")
        print("StartTime: \(startTime)")
        print("EndTime: \(endTime)")
        print("SelectedDate: \(selectedDate)")
        print("NumberOfVisitors: \(numberOfVisitors)")
        print("PricePerVisitor: \(pricePerVisitor)")
        print("Subtotal: \(subtotal)")
        print("Discount: \(discount)")
        print("Total: \(total)")

        // Save the managed object context to persist the data
        do {
                   try viewContext.save()
                   // Trigger navigation to SavedBookingsView
                   self.navigateToSavedBookings = true
               } catch {
                   print("Error saving booking: \(error)")
               }
           }



    
    func increment() {
        numberOfVisitors += 1
    }

    
    
    func decrement() {
        if numberOfVisitors > 1 {
            numberOfVisitors -= 1
        }
    }
    
    
    // MARK: - Update END TIME
    func updateEndTime() {
            if startTime == "not available" {
                endTime = "not available"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                if let startDate = formatter.date(from: startTime) {
                    var duration: TimeInterval = 0
                    if event == "Visual Show" {
                        duration = 2 * 60 * 60 // 2 hours in seconds
                    } else {
                        duration = 1.5 * 60 * 60 // 1.5 hours in seconds
                    }
                    let endDate = startDate.addingTimeInterval(duration)
                    endTime = formatter.string(from: endDate)
                } else {
                    endTime = "not available"
                }
            }
        }

    // MARK: - Calculate Pricing
    func calculatePricing() {
        let prices: [String: (weekday: Double, weekend: Double)] = [
            "Art Gallery": (weekday: 25, weekend: 30),
            "WWI Exhibition": (weekday: 20, weekend: 25),
            "Exploring the Space": (weekday: 30, weekend: 35),
            "Visual Show": (weekday: 40, weekend: 40)
        ]

        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: selectedDate)
        let isWeekend = dayOfWeek == 1 || dayOfWeek == 7

        let eventPricing = prices[event] ?? (weekday: 0, weekend: 0)
        let price = isWeekend ? eventPricing.weekend : eventPricing.weekday
        
        pricePerVisitor = price


        subtotal = price * Double(numberOfVisitors)
        discount = numberOfVisitors >= 4 ? subtotal * 0.1 : 0
        total = subtotal - discount
    }

    
    // MARK: - Generate START Slots
    private func generateTimeSlots(for event: String, on selectedDate: Date) -> [String] {
        let calendar = Calendar.current
        let now = Date()
        let selectedDayStart = calendar.startOfDay(for: selectedDate)
        let todayStart = calendar.startOfDay(for: now)
        
        let isPastDate = selectedDayStart < todayStart
        let isToday = calendar.isDateInToday(selectedDate)
        let currentTime = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now) //
        
        if isPastDate {
           
            return []
        } else {
            var slots: [String] = []
            if event == "Visual Show" {
                let showSlots = ["15:00", "17:00", "19:00"]
                if isToday {
                    slots = showSlots.filter { slot in
                        let slotHour = Int(slot.prefix(2)) ?? 0
                        let slotMinute = Int(slot.suffix(2)) ?? 0
                        let slotTimeInMinutes = slotHour * 60 + slotMinute
                        return slotTimeInMinutes > currentTime
                    }
                } else {
                    slots = showSlots
                }
            } else {
                for hour in 9...19 {
                    let slot1 = "\(hour):00"
                    let slot2 = "\(hour):30"
                    let slot1TimeInMinutes = hour * 60
                    let slot2TimeInMinutes = hour * 60 + 30
                    
                    if !isToday || (isToday && slot1TimeInMinutes > currentTime) {
                        slots.append(slot1)
                    }
                    if !isToday || (isToday && slot2TimeInMinutes > currentTime && hour < 20) {
                        slots.append(slot2)
                    }
                }
            }
            return slots
        }
    }
}


    

    struct BookingDetailView_Previews: PreviewProvider {
        static var previews: some View {
            BookingDetailView(event: .constant("Event Name"), show: .constant(true))
                .previewLayout(.sizeThatFits)
        }
    }




