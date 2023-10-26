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
            Text("Hello Shaders!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
