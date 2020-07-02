//
//  ModelClassifier.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 01/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ModelClassifier {
    private var classificationRequest: VNCoreMLRequest!
    
    weak var delegate: MLDelegate?
    
    init() {
        setUpRequest()
    }
    
    private func setUpRequest() {
        let model = try! VNCoreMLModel(for: GeometryClassifier().model)
        classificationRequest = VNCoreMLRequest(model: model, completionHandler: {
            [weak self] request, error in
            self?.processClassifications(for: request, error: error)
        })
        
        classificationRequest.imageCropAndScaleOption = .centerCrop
    }
    
    func updateClassifications(for image: UIImage) {
        guard
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)),
            let ciImage = CIImage(image: image)
            else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            try! handler.perform([self.classificationRequest!])
        }
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        var identifier: String = "unnamed"
        var confidence: Float = 0
        
        defer {
            print("Classification:\n" + String(format: "  (%.2f) %@", confidence, identifier))
            self.delegate?.result(identifier: identifier, confidence: confidence)
        }
        
        guard let classification = request.results?.first as? VNClassificationObservation else { return }
        
        identifier = classification.identifier
        confidence = classification.confidence
    }
}
