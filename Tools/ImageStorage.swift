//
//  ImageFromData.swift
//  ming sign
//
//  Created by magicday.a on 18.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import SwiftUI
import UIKit

struct ImageStorage {

    // retrieve image from file system - without extension
    static func retrieveImageFromFileSystem(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    // retrieve image from file system - extension included
    static func retrieveImagePNGFromFileSystem(forKey key: String) -> UIImage? {
        if let filePath = self.filePathComplete(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }

    // (re)stores (modified) imageArray to user defaults
    static func storeImageArray(array: [Data]?, forKey key: String) {
        if let dataArray = array {
            UserDefaults.standard.set(dataArray, forKey: key)
          //  print("saved array to user defaults")
        }
    }
    
    // MARK: - store image in file system
    static func storeImage(image: UIImage, forKey key: String) {
        var isSaved = false
        var i = 1
        
        if let pngRepresentation = image.pngData() {
            while isSaved == false {
                var imageKey = key
                imageKey.append("\(i)")
                
                if let filePath = filePath(forKey: imageKey) {
                    if !FileManager.default.fileExists(atPath: filePath.path) {
                        do {
                            try pngRepresentation.write(to: filePath, options: .atomic)
                            isSaved = true
                            
                        } catch let err {
                            print("saving file resulted in error: ", err)
                            isSaved = true
                        }
                        
                    } else {
                        isSaved = false
                        i = i + 1
                    }
                }
            }
        }
    }
    
    // returns an array of all images names (with extension) in ming sign folder
    static func findImagesInFileSystem() -> [String] {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return [] }
        
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
            let pngFiles = directoryContents.filter { $0.pathExtension == "png" }
            let PNGFiles = directoryContents.filter { $0.pathExtension == "PNG" }
       //     print("\(pngFiles.count) .png and \(PNGFiles.count) .PNG images")
            let jpgFiles = directoryContents.filter { $0.pathExtension == "jpg" }
            let JPGFiles = directoryContents.filter { $0.pathExtension == "JPG" }
            
            let jpegFiles = directoryContents.filter { $0.pathExtension == "jpeg" }
            let JPEGFiles = directoryContents.filter { $0.pathExtension == "JPEG" }
       //     print("\(jpgFiles.count) .jpg and \(JPGFiles.count) .JPG images")
            let tiffFiles = directoryContents.filter { $0.pathExtension == "tiff" }
            let TIFFFiles = directoryContents.filter { $0.pathExtension == "TIFF" }
            
            let gifFiles = directoryContents.filter { $0.pathExtension == "gif" }
            let GIFFiles = directoryContents.filter { $0.pathExtension == "GIF" }
            
            var imagesArray = [String]()
            
            for i in 0..<pngFiles.count {
                imagesArray.append(pngFiles[i].lastPathComponent)
            }
            
            for i in 0..<jpgFiles.count {
                imagesArray.append(jpgFiles[i].lastPathComponent)
            }
            
            for i in 0..<jpegFiles.count {
                imagesArray.append(jpegFiles[i].lastPathComponent)
            }
            
            for i in 0..<tiffFiles.count {
                imagesArray.append(tiffFiles[i].lastPathComponent)
            }
            
            for i in 0..<gifFiles.count {
                imagesArray.append(gifFiles[i].lastPathComponent)
            }
            
            for i in 0..<PNGFiles.count {
                imagesArray.append(PNGFiles[i].lastPathComponent)
            }
            
            for i in 0..<JPGFiles.count {
                imagesArray.append(JPGFiles[i].lastPathComponent)
            }
            
            for i in 0..<JPEGFiles.count {
                imagesArray.append(JPEGFiles[i].lastPathComponent)
            }
            
            for i in 0..<TIFFFiles.count {
                imagesArray.append(TIFFFiles[i].lastPathComponent)
            }
            
            for i in 0..<GIFFiles.count {
                imagesArray.append(GIFFiles[i].lastPathComponent)
            }
            
            return imagesArray
            
        } catch let err {
            print("error with contentsOfDirectory", err)
        }

        return []
    }
    
    static func getFileSystemImagesCount() -> Int {
        let count = findImagesInFileSystem().count
        return count
    }
    
    // returns array with false values for all files in folder
    static func getIsCheckedArray() -> [Bool] {
        if getFileSystemImagesCount() != 0 {
            var isCheckedArray = [Bool]()
            for _ in 0..<getFileSystemImagesCount() {
                isCheckedArray.append(false)
            }
            
            return isCheckedArray
        }
        
        return []
    }
    
    // returns true or false for isChecked
    static func getIsCheckedValue(isCheckedArray: [Bool]) -> Bool {
        var isChecked = false
        if isCheckedArray.count != 0 {
            for i in 0..<isCheckedArray.count {
                if isCheckedArray[i] == true {
                    isChecked = true
                    
                    return isChecked
                }
            }
        }
        
        return isChecked
    }
    
    // filePath (for saving in file system)
    static func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    // filePath with given extension (for saving in file system)
    static func filePathComplete(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key)
    }
    
    // remove from file system - not used
    static func removeImage(forKey key: String) {
        if let filePath = filePath(forKey: key) {
            if FileManager.default.fileExists(atPath: filePath.path) {
                do {
                    try FileManager.default.removeItem(atPath: filePath.path)
                    print("removed old image: \(key)")
                    
                } catch let removeError {
                    print("couldn't remove image \(key)", removeError)
                }
            } else {
                print("\(key) doesn't exit ")
            }
        }
    }
    
    static func retrieveSettings() -> [Bool] {
        if let settings = UserDefaults.standard.array(forKey: "settings") as? [Bool] {
       //     print("settings count: \(settings.count)")
            if settings.count != 4 {
                return [true, false, true, true]
                
            } else {
                return settings
            }
        }
        
        // 0 image save home . 1 image to folder . 2. image to library . 3 watermark save home
        return [true, false, true, true]
    }
    
    static func retrieveColor() -> Int {
        let color = UserDefaults.standard.integer(forKey: "color")
            return color
    }
    
    static func retrieveColors() -> [String] {
        let language = retrieveLanguage()
        var colors: [String] = ["light / dark", "white", "black"]
        
        if language == "english" {
            colors = ["light / dark", "white", "black"]
            
        } else if language == "deutsch" {
            colors = ["light / dark", "weiß", "schwarz"]
        }
        
        return colors
    }
    
    static func retrieveLanguage() -> String {
        if let language = UserDefaults.standard.string(forKey: "language") {
            return language
        }
        
        return "english"
    }
    
    static func getFlagOpacity() -> [Double] {
        let language = retrieveLanguage()
        var opacity: [Double] = [1.0, 0.5]
        
        if language == "english" {
            opacity = [1.0, 0.5]
            
        } else if language == "deutsch" {
            opacity = [0.5, 1.0]
        }
        
        return opacity
    }
}
