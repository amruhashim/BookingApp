//
//  ExhibitionDetailView.swift
//  A1
//
//  Created by Amru Hashim on 2/5/24.
//

import SwiftUI

struct Details: Identifiable {
    var id = UUID()
    var title: String
    var price: String
    var description: String
}


var details = [
    "Art Gallery": Details(title: "Modern Art Collection", price: "Starting from: AU$25", description: "Explore contemporary art forms from the 20th and 21st centuries, featuring works from leading modern artists."),
    "WWI Exhibition": Details(title: "The Great War", price: "Starting from: AU$20", description: "A deep dive into the events of World War I, showcasing artifacts, letters, and stories from the front lines."),
    "Exploring the Space": Details(title: "Cosmic Journeys", price: "Starting from: AU$30", description: "An interactive exhibition exploring the vastness of space, from the solar system to distant galaxies."),
    "Visual Show": Details(title: "Lights and Illusions", price: "Starting from: AU$40", description: "An immersive experience into the world of light and illusion, featuring installations that challenge your perception.")
]



struct ExhibitionDetailView: View {
    
    @Binding var event: String
    @Binding var show: Bool
    
    @State private var isBookingDetailVisible = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    withAnimation(.spring()){
                        show.toggle()
                    }
                }){
                    Image(systemName: "xmark")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(event)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.yellow)
                    .font(.system(size: 60))
                    .padding(.horizontal, 30)

                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(details[event]?.title ?? "")
                            .foregroundColor(.yellow)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        Text(details[event]?.price ?? "")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .padding(.horizontal, 30)
                    }
                    
                    Text(details[event]?.description ?? "")
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 70)
                    
                    Button(action: {
                        isBookingDetailVisible.toggle()
                    }) {
                        Text("BOOK NOW")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("primary"))
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .padding(.horizontal, 120)
                }
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(
                Image(event)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("back")
            .navigationBarHidden(true)
            .background(
                
                NavigationLink(
                    destination: BookingDetailView(event: $event, show: $isBookingDetailVisible),
                    isActive: $isBookingDetailVisible,
                    label: {
                        EmptyView()
                    }
                )
                .opacity(0)
            )
        }
    }
}


