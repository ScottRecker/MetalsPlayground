//
//  ContentView.swift
//  MetalsPlayground
//
//  Created by Scott Recker on 10/25/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
                .frame(height: 300)
            Text("Hello Shaders!")
        }
//        .padding()
    }
}

#Preview {
    ContentView()
}
