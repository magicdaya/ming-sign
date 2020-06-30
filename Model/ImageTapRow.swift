//
//  ImageTapView.swift
//  ming sign
//
//  Created by magicday.a on 27.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import SwiftUI

// image choice from ming sign folder by single tap
struct ImageTapRow: View {
    @Binding var isImageSelected: Bool
    @Binding var imageKey: String
    
//    var title: [String]
    
    var body: some View {
        var images: [[Int]] = []
        
        _ = (0..<ImageStorage.getFileSystemImagesCount()).publisher
            .collect(3) // number of  columns
            .collect()
            .sink(receiveValue: { images = $0 })
        
        return ForEach(0..<images.count, id: \.self) { array in
        
            VStack {
                HStack {
                    ForEach(images[array], id: \.self) { i in
                        VStack {
                            HStack {
                                Image(uiImage: ImageStorage.retrieveImagePNGFromFileSystem(forKey: ImageStorage.findImagesInFileSystem()[i]) ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture(count: 1, perform: {
                                        // select image
                                        self.isImageSelected = true
                                        self.imageKey = ImageStorage.findImagesInFileSystem()[i]
                                    })
                                
                             //   Spacer()
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text(ImageStorage.findImagesInFileSystem()[i])
                                    .foregroundColor(Color.gray)
                                    .font(.body)
                                
                             //   Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

