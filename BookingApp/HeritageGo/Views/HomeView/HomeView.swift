//
//  HomeView.swift
//  A1
//
//  Created by Amru Hashim on 2/3/24.
//

import SwiftUI

// Model to  represent each  Exhibition
struct Category: Identifiable {
    var id = UUID()
    var title: String // Exhibition title
    var size: CGFloat // Font size for the title
    var gridItem: [GridItem] // Grid items for layout
    var cardHeight: CGFloat // Height of the cards within the Exhibition
}

// Sample Exhibition data
let category = [
    Category(title: "Exhibitions", size: 25, gridItem: Array(repeating: GridItem(.fixed(230), spacing: 7), count: 2), cardHeight: 210)
]

// HomeView displaying exhibitions and content
struct HomeView: View {
    // Filter exhibition Category
    var exhibitionCategory: [Category] {
        category.filter { $0.title.lowercased() == "exhibitions" }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Header logo
                Image("HeaderLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 10)
                
                Spacer(minLength: 50)

                // Display  exhibitions
                ForEach(exhibitionCategory) { categoryItem in
                    VStack(spacing: 10) {
                        // exhibition title
                        HStack {
                            Text(categoryItem.title)
                                .font(.custom("Helvetica Neue", size: categoryItem.size))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 25)
                        }
                        // View for displaying exhibitions
                        ExhibitionsView(cardHeight: categoryItem.cardHeight)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, -20)
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.bottom, 20)
        }
    }
}
