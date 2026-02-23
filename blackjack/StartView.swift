//
//  StartView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.02.2026.
//

import Foundation
import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Image("BACKGROUND")
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .ignoresSafeArea()

                VStack(){
                    HStack{
                        Text("Black")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .foregroundStyle(.black)
                        Text("Jack")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .foregroundStyle(.red)
                    }
                    .padding()
                    
                    NavigationLink(destination: ContentView()){
                        Text("Play  ")
                            .font(.system(size: 20, weight: .bold, design: .default))
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(.capsule)
                    
                }
            }
        }
    }
}
#Preview {
    StartView()
}
