//
//  CameraViewPresenter.swift
//  ColerApp
//
//  Created by Nikita Nikandrov on 07.07.2024.
//

import UIKit

protocol CameraViewPresenterProtocol: AnyObject {
    func getRGBValuesInCircle() -> [(r: CGFloat, g: CGFloat, b: CGFloat)]?
}

import UIKit

class CameraViewPresenter: CameraViewPresenterProtocol {
    
    weak var view: CameraViewProtocol?
    
    init(view: CameraViewProtocol) {
        self.view = view
    }
    
    func getRGBValuesInCircle() -> [(r: CGFloat, g: CGFloat, b: CGFloat)]? {
        guard let image = view?.getCircleViewImage(), let cgImage = image.cgImage, let data = cgImage.dataProvider?.data else {
            return []
        }
        
        let ptr = CFDataGetBytePtr(data)
        let bytesPerPixel = 4
        let width = cgImage.width
        let height = cgImage.height
        var result: [(r: CGFloat, g: CGFloat, b: CGFloat)] = []
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let r = CGFloat(ptr![pixelIndex]) / 255.0
                let g = CGFloat(ptr![pixelIndex + 1]) / 255.0
                let b = CGFloat(ptr![pixelIndex + 2]) / 255.0
                
                let pixelCenter = CGPoint(x: CGFloat(x), y: CGFloat(y))
                let circleCenter = CGPoint(x: CGFloat(width) / 2, y: CGFloat(height) / 2)
                if pixelCenter.distance(to: circleCenter) <= CGFloat(width) / 2 {
                    result.append((r, g, b))
                }
            }
        }
        return result
    }
    
    func calculateAverageRGB(from rgbValues: [(r: CGFloat, g: CGFloat, b: CGFloat)]) ->
                                                                    (averageR: CGFloat, averageG: CGFloat, averageB: CGFloat)? {
        guard !rgbValues.isEmpty else {
            return nil
        }
        
        var totalR: CGFloat = 0.0
        var totalG: CGFloat = 0.0
        var totalB: CGFloat = 0.0
        
        for value in rgbValues {
            totalR += value.r
            totalG += value.g
            totalB += value.b
        }
        
        let count = CGFloat(rgbValues.count)
        let averageR = totalR / count
        let averageG = totalG / count
        let averageB = totalB / count
        
        return (averageR, averageG, averageB)
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}
