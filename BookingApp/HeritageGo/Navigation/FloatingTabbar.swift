//
//  FloatingTabbar.swift
//  A1
//
//  Created by Amru Hashim on 2/7/24.
//

import SwiftUI

// FloatingTabbar view for switching between tabs
struct FloatingTabbar: View {
    @Binding var selected: Int // Index of the selected tab
    @Binding var expand: Bool // Expand/collapse state of the tab bar

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer(minLength: 0)
                
                HStack {
                    if !self.expand {
                        // Button to expand the tab bar
                        Button(action: {
                            withAnimation {
                                self.expand.toggle()
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.yellow)
                                .padding()
                        }
                    } else {
                        // Button to switch to the home tab
                        Button(action: {
                            withAnimation {
                                self.selected = 0
                            }
                        }) {
                            Image(systemName: "house")
                                .foregroundColor(self.selected == 0 ? .yellow : .gray)
                                .padding(.horizontal)
                        }
        
                        // Button to switch to the bookings tab
                        Button(action: {
                            withAnimation {
                                self.selected = 1
                            }
                        }) {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(self.selected == 1 ? .yellow : .gray)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(self.expand ? 20 : 8)
                .background(RoundedRectangle(cornerRadius: 40).fill(Color.black).shadow(radius: 10))
                .padding(.horizontal, self.expand ? 20 : 8)
                .padding(.bottom, 20)
            }
        }
        // Apply spring animation to tab bar expansion
        .animation(.spring(), value: expand)
    }
}
