//
//  MetalView.swift
//  MetalsPlayground
//
//  Created by Scott Recker on 10/26/23.
//

import Foundation
import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {

    func makeCoordinator() -> Renderer {
        Renderer(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MetalView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator

        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true

        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }

        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        mtkView.enableSetNeedsDisplay = true
        mtkView.isPaused = false
        mtkView.colorPixelFormat = .rgba8Unorm

        return mtkView
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MetalView>) {

    }
}
