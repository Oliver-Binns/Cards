import CardsModel
import CardsStyle
import RealityKit
import Sevens
import SwiftUI

extension MeshResource {
    static var playingCard: MeshResource {
        .generateBox(width: 0.0635, height: 0.0017, depth: 0.089,
                     cornerRadius: 0.003, splitFaces: true)
    }
}

struct ImmersiveView: View {
    let tableAnchor = AnchorEntity(.plane([.horizontal],
                                          classification: [.table],
                                          minimumBounds: [1.0, 1.0]))
    
    let cardWidth: Float = 0.0635
    let cardHeight: Float = 0.0017
    
    let cardVisibleArea: Float = 0.02
    
    @MainActor
    func material(forCard card: PlayingCard) -> SimpleMaterial {
        let style = DefaultStyle().front.image(forCard: card)
        let renderer = ImageRenderer(content: style)
        
        let texture = try! TextureResource.generate(from: renderer.cgImage!,
                                                     options: .init(semantic: .normal))
        var material = SimpleMaterial()
        material.color = .init(texture: .init(texture)) // Set the material color using the texture
        material.roughness = .float(1)
        material.metallic = .float(0)

        return material
    }
    
    @MainActor
    func backMaterial() -> SimpleMaterial {
        let style = DefaultStyle().back.image
        let renderer = ImageRenderer(content: style)
        
        let texture = try! TextureResource.generate(from: renderer.cgImage!,
                                                     options: .init(semantic: .normal))
        var material = SimpleMaterial()
        material.color = .init(texture: .init(texture)) // Set the material color using the texture
        material.roughness = .float(0.5)
        material.metallic = .float(0)
        return material
    }
    
    @MainActor
    func plain() -> SimpleMaterial {
        SimpleMaterial(color: .white, isMetallic: false)
    }
    
    @EnvironmentObject private var model: ViewModel
    
    var body: some View {
        RealityView { content in
            if let game = model.game as? Sevens {
                for (index, run) in game.table.enumerated() {
                    let offsetX = Float(index) * cardWidth * 1.5
                    
                    for (index, cardValue) in SuitedCard.allCases.enumerated() {
                        let card = PlayingCard.suited(cardValue, run.key)
                        let entity = ModelEntity(mesh: .playingCard,
                                                 materials: [plain(), material(forCard: card), plain(), backMaterial(), plain(), plain()])
                        
                        let offsetY = Float(index) * cardHeight
                        let offsetZ = Float(index) * cardVisibleArea
                        
                        entity.transform.translation = .init(offsetX, 0, offsetZ)
                        
                        if index > 0 {
                            let angle = sin(cardHeight / cardVisibleArea)
                            entity.transform.rotation = .init(angle: angle, axis: .init(1, 0, 0))
                        }
                        
                        tableAnchor.addChild(entity)
                    }
                }
            }
            
            let entity = ModelEntity(mesh: .generateBox(size: 4, cornerRadius: 0.1),
                                     materials: [SimpleMaterial(color: .green, isMetallic: true)])
            tableAnchor.addChild(entity)
            
            content.add(tableAnchor)
        }
    }
}
