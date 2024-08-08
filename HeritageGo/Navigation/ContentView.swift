//
//  ContentView.swift
//  A1
//
//  Created by Amru Hashim on 2/2/24.
//

import SwiftUI
import Combine

// ContentView containing the tab bar and corresponding views
struct ContentView: View {
    @State private var selected = 0
    @State private var isTabBarExpanded = false
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 4, on: .main, in: .common)
    @State private var timerCancellable: Cancellable? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                // Display different views based on the selected tab
                switch selected {
                case 0:
                    HomeView()
                case 1:
                    savedBookingsView1()
                default:
                    Text("Selection does not exist.")
                }
            }
            // FloatingTabbar to switch between views
            FloatingTabbar(selected: $selected, expand: $isTabBarExpanded)
        }
        .onAppear {
            restartTimer() // Start the timer when the view appears
        }
        .onChange(of: isTabBarExpanded) { expanded in
            if expanded {
                restartTimer() // Restart the timer if the tab bar is expanded
            }
        }
        .onDisappear {
            timerCancellable?.cancel() // Cancel the timer when the view disappears
        }
    }

    // Function to restart the timer
    private func restartTimer() {
        timerCancellable?.cancel() // Cancel previous timer if any
        timer = Timer.publish(every: 4, on: .main, in: .common) // Create a new timer
        timerCancellable = timer.autoconnect().sink { _ in // Connect timer to sink
            withAnimation {
                self.isTabBarExpanded = false // Collapse the tab bar after timer interval
            }
        }
    }
}
