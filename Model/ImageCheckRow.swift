//
//  ImageCheckRow.swift
//  ming sign
//
//  Created by magicday.a on 20.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import SwiftUI

struct ImageCheckRow: View {
    @Binding var isChecked: [Bool]
    
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
                                
                                Spacer()
                            }
                            
                            Spacer()

                            HStack {
                                Image(systemName: self.isChecked[i] ? "largecircle.fill.circle" : "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(width: 22, height: 22)
                                
                                Text(ImageStorage.findImagesInFileSystem()[i])
                                    .foregroundColor(Color.gray)
                                    .font(.body)
                            }
                        }
                        .onTapGesture {
                            self.toggle(i)
                        }
                    }
                }
            }
        }
    }
    
    func toggle(_ i : Int) {
      //  print("i: \(i)")
        isChecked[i] = !isChecked[i]
    }
}
