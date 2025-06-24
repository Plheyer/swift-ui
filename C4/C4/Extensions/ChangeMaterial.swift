import RealityKit

extension ModelEntity {
    func apply(material: Material) {
        self.model?.materials[0] = material
    }
}
