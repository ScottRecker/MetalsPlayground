//
//  Renderer.swift
//  MetalsPlayground
//
//  Created by Scott Recker on 10/26/23.
//

import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var parent: MetalView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState
    var vertextBuffer: MTLBuffer

    init(_ parent: MetalView) {
        self.parent = parent

        // Setup our GPU -> Let Metal pick GPU to use
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
            self.metalCommandQueue = self.metalDevice.makeCommandQueue()
        }
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = self.metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader") // Binds the vertext shader
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader") // Binds the fragment shader
        pipelineDescriptor.colorAttachments[0].pixelFormat = .rgba8Unorm

        // Use our pipeline descriptor for our renderPipeline
        do {
            try self.pipelineState = self.metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Cannot create render pipeline")
        }
        
//        let vertices = [
//            vector_float3(0, 1, 0), // Middle top of screen
//            vector_float3(-1, -1, 0), // bottom left of screen
//            vector_float3(1, -1, 0), // bottom right. of screen
//        ]
        
        let vertices = [
            Vertex(position: vector_float3(1, 1, 0), color: vector_float4(1.0, 0.0, 0.0, 1.0)),   // Middle top of screen
            Vertex(position: vector_float3(-1, -1, 0), color: vector_float4(0.0, 1.0, 0.0, 1.0)),   // bottom left of screen
            Vertex(position: vector_float3(1, -1, 0), color: vector_float4(0.0, 0.0, 1.0, 1.0)),    // bottom right. of screen

            Vertex(position: vector_float3(-1, 1, 0), color: vector_float4(1.0, 0.0, 0.0, 1.0)),   // Middle top of screen
            Vertex(position: vector_float3(-1, -1, 0), color: vector_float4(0.0, 1.0, 0.0, 1.0)),   // bottom left of screen
            Vertex(position: vector_float3(1, 1, 0), color: vector_float4(0.0, 0.0, 1.0, 1.0))    // bottom right. of screen
        ]
        
        vertextBuffer = self.metalDevice.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])!

        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        // A buffer for storing all out commands in ...
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        // Describes the view sources that we will be making use of, for
        // example colorAttachments[0] for the color
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store

        // Simply just to encode our commands that are stored on the command buffer ...
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setViewport(.init(originX: 0, originY: 0, width: view.drawableSize.width, height: view.drawableSize.height, znear: 0, zfar: 1))

        // Binds our renderPipeline
        renderEncoder?.setRenderPipelineState(pipelineState)

        // Send data to shader
        renderEncoder?.setVertexBuffer(vertextBuffer, offset: 0, index: 0)
//        renderEncoder?.setTriangleFillMode(.lines)

        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)

        renderEncoder?.endEncoding()


        // At the bottom of everything
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
