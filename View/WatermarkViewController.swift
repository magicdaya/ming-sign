//
//  WatermarkViewController.swift
//  ming sign
//
//  Created by magicday.a on 22.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import SwiftUI
import UIKit
import PencilKit

struct WatermarkViewController: UIViewControllerRepresentable {
       
    func makeUIViewController(context: UIViewControllerRepresentableContext<WatermarkViewController>) -> UIViewController {

        let controller = WatermarkView()
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    // selected image
    class Coordinator: NSObject {
        
        let parent: WatermarkViewController
        
        init(_ parent: WatermarkViewController) {
            self.parent = parent
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WatermarkViewController>) {
    }
}
