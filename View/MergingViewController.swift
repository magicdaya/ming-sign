//
//  MergingViewController.swift
//  ming sign
//
//  Created by magicday.a on 19.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import SwiftUI
import UIKit

struct MergingViewController: UIViewControllerRepresentable {
        
//     @Binding var imageNumber: Int
    @Binding var watermarkKey: String
    @Binding var isImageSelected: Bool
    @Binding var imageKeys: [String]
   
    func makeUIViewController(context: UIViewControllerRepresentableContext<MergingViewController>) -> UIViewController {

        let controller = MergingView()
      //  controller.number = self.imageNumber
        controller.watermarkKey = self.watermarkKey
        controller.isImageSelected = self.isImageSelected
        controller.imageKeys = self.imageKeys

        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, self.watermarkKey, self.isImageSelected, self.imageKeys)
    }
    
    // selected image
    class Coordinator: NSObject {
        
        let parent: MergingViewController
 //       var imageNumber: Int
        var watermarkKey: String
        var isImageSelected: Bool
        var imageKeys: [String]
        
        init(_ parent: MergingViewController, _ watermarkKey: String, _ isImageSelected: Bool, _ imageKeys: [String]) {
            self.parent = parent
        //    self.imageNumber = imageNumber
            self.watermarkKey = watermarkKey
            self.isImageSelected = isImageSelected
            self.imageKeys = imageKeys
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MergingViewController>) {
    }
}
