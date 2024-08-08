//
//  LaunchScreenView.swift
//  A1
//
//  Created by Amru Hashim on 2/7/24.
//

import SwiftUI


// SwiftUI view for the launch screen
struct LaunchScreenView: View {
    var horizontalPadding: CGFloat // Horizontal padding value
    
    var body: some View {
        VStack {
            Spacer() // Spacer at the top
            Image("LaunchScreen") // Launch screen image
                .resizable() // Make image resizable
                .scaledToFit() // Scale image to fit
                .padding(.horizontal, horizontalPadding) // Apply horizontal padding
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand image to fill available space
                .background(Color.clear) // Set background color to clear
            Spacer() // Spacer at the bottom
        }
        .background(Color.white) // Set background color to white
        .edgesIgnoringSafeArea(.all) // Ignore safe area insets
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView(horizontalPadding: 50) // Preview with horizontal padding
    }
}
