//
//  PencilCanvas.swift
//  ming sign
//
//  Created by magicday.a on 03.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import UIKit
import PencilKit

class PencilCanvas: PKCanvasView {
    
    weak var delegatePencilCanvas: ToolsDelegate?
    
    var canvasImage: UIImage!
    var watermarkImage: UIImage!
    var watermarkDrawing: PKDrawing!

    // * * * * * * * * *
    // MARK: - draw(_:)
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // the following doesn't work (disturbs the lasso tool)
 //       self.delegatePencilCanvas?.hideEditTextView()
//        self.delegatePencilCanvas?.onTouchesInPencilCanvas()
//        self.delegatePencilCanvas?.setBackgroundColor()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // update watermarkDrawing
        saveDrawing()
    }
        
    // MARK: - create UIImage
    func createUIImage() -> UIImage {
        let drawing = self.drawing
        self.watermarkDrawing = drawing
        
        let visibleRect = self.bounds
        let image = drawing.image(from: visibleRect, scale: UIScreen.main.scale)
        self.watermarkImage = image
        
        return image
    }

    func saveDrawing() {
        self.watermarkDrawing = self.drawing
    }
}
