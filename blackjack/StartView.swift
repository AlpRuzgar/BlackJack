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
                Color.green.ignoresSafeArea()
                    .brightness(-0.2)

                VStack(){
                    HStack{
                        Text("Black")
                            .font(.system(size: 50, weight: .bold, design: .default))
                            .foregroundStyle(.black)
                        Text("Jack")
                            .font(.system(size: 50, weight: .bold, design: .default))
                            .foregroundStyle(.red)
                    }
                    .padding()
                    
                    NavigationLink(destination: ContentView()){
                        Text("Play")
                            .font(.title)
                            .bold()
                            .frame(width: 250, height: 50)
                            .foregroundStyle(.white)
                            .background(LinearGradient(colors: [.red,.black], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(.capsule)
                        
                    }
                }
            }
        }
    }
}
#Preview {
    StartView()
}
