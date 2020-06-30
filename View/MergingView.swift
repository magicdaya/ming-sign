//
//  MergingView.swift
//  ming sign
//
//  Created by magicday.a on 03.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import UIKit
import SwiftUI

class MergingView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView: UIImageView!
    var watermarkView: UIImageView!
    
    var maxImageViewWidth: CGFloat = 300.0
    var maxImageViewHeight: CGFloat = 300.0
    
    var savedAlertLabel: UILabel = {
        let label = UILabel()
        label.text = Languages.getEntryFromJSON(section: .sign, entry: .header12)
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .systemPurple
        label.font = .systemFont(ofSize: 27)
        label.layoutMargins.bottom = 10
        label.layoutMargins.top = 10
        label.layoutMargins.left = 10
        label.layoutMargins.right = 10
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()
    
    var selectedImage: UIImage!
    var watermarkImage: UIImage!
    
    var isImageSelected: Bool = false
    var imageKeys: [String] = [""]
    var actualImageKey: Int = 0
    
    var isOpacity: Bool = false
    var alphaValue: CGFloat = 1.0
    
    var scalingFactor: CGFloat = 1.0
    
    var opacityLabel: UILabel = {
        let label = UILabel()
        label.text = " ------------------ "
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .systemPurple
        label.font = .systemFont(ofSize: 27)
        label.layoutMargins.bottom = 10
        label.layoutMargins.top = 10
        label.layoutMargins.left = 10
        label.layoutMargins.right = 10
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()
 
    var scalingLabel: UILabel = {
        let label = UILabel()
        label.text = " ------------------ "
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .systemPurple
        label.font = .systemFont(ofSize: 27)
        label.layoutMargins.bottom = 10
        label.layoutMargins.top = 10
        label.layoutMargins.left = 10
        label.layoutMargins.right = 10
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()

    let startWatermarkPoint = CGPoint(x: 400, y: 400)
    
    var imageViewSize: CGSize!
    
    // selected image name in ming sign folder
    var watermarkKey: String = ""
    
    var buttonCenter: CGPoint!
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Languages.getEntryFromJSON(section: .create, entry: .header6), for: .normal)    
        button.titleLabel?.font = .systemFont(ofSize: 29)
        button.setTitleColor(.systemPurple, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPurple.cgColor
        button.clipsToBounds = true
        button.sizeToFit()
        button.addTarget(self, action: #selector(saveImage),
                         for: .touchUpInside)
        return button
    }()
    
    var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "photo")?.withTintColor(.systemPurple, renderingMode: .alwaysOriginal), for: .normal)
        button.setTitle("----", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 42)
        button.setTitleColor(.clear, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.clipsToBounds = true
        button.sizeToFit()
        button.addTarget(self, action: #selector(selectImage),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
         
        watermarkView = UIImageView()
        
        if traitCollection.userInterfaceStyle == .light {
            saveButton.backgroundColor = .white
        //    selectImageButton.backgroundColor = .white
            
        } else {
            saveButton.backgroundColor = .black
         //   selectImageButton.backgroundColor = .black
        }

        maxImageViewWidth = view.bounds.width
        maxImageViewHeight = view.bounds.height

        buttonCenter = CGPoint(x: maxImageViewWidth - 160, y: maxImageViewHeight - 60)
        
        view.addSubview(saveButton)
        view.addSubview(selectImageButton)
        saveButton.center = buttonCenter
        selectImageButton.center = buttonCenter
        
        setWatermarkImage()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .light {
            saveButton.backgroundColor = .white
         //   selectImageButton.backgroundColor = .white
            
        } else {
            saveButton.backgroundColor = .black
         //   selectImageButton.backgroundColor = .black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if selectedImage != nil && ImageStorage.retrieveSettings()[0] == true {
            saveImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        maxImageViewWidth = view.bounds.width
        maxImageViewHeight = view.bounds.height
        
        if selectedImage != nil {
            buttonCenter = CGPoint(x: maxImageViewWidth - 160, y: maxImageViewHeight - 60)
            saveButton.center = buttonCenter
            selectImageButton.center = buttonCenter
            setSelectedImage(selectedImage)
            
            if watermarkView != nil {
                moveWatermark(toPoint: watermarkView.center)
                
            } else {
                moveWatermark(toPoint: startWatermarkPoint)
            }
        }
    }
    
    // MARK: - pan recognizer (for moving watermark)
    func addPanRecognizerToWatermarkView() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        watermarkView.addGestureRecognizer(panRecognizer)
        watermarkView.isUserInteractionEnabled = true
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.imageView)
        if let view = recognizer.view {
            if !isOpacity {
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
                
            } else {
               // self.view.bringSubviewToFront(watermarkView)
                alphaValue = alphaValue + 0.01 * translation.x
                
                if alphaValue > 1.0 {
                    alphaValue = 1.0
                    
                } else if alphaValue < 0.1 {
                    alphaValue = 0.1
                } else { }
                
                watermarkView.alpha = alphaValue
                
                self.view.addSubview(opacityLabel)
                opacityLabel.center = CGPoint(x: self.view.center.x + 200, y: self.view.center.y + 200)
                self.view.bringSubviewToFront(opacityLabel)
                opacityLabel.text = Languages.getEntryFromJSON(section: .sign, entry: .header14)
                opacityLabel.text?.append("\(Int(alphaValue * 100)) %")
                
                
                if recognizer.state == .ended {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
                        self.opacityLabel.removeFromSuperview()

                        self.saveButton.isHidden = false
                        self.view.bringSubviewToFront(self.saveButton)
                    }
                }
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: self.imageView)
    }
    
    // MARK: - pinch recognizer (for scaling watermark)
    func addPinchRecognizerToWatermarkView() {
        let scaleRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:)))
        watermarkView.addGestureRecognizer(scaleRecognizer)
        watermarkView.isUserInteractionEnabled = true
    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.view != nil {
        
            if let scale = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)) {
                guard scale.a > 0.01 else { return }
                guard scale.d > 0.01 else { return }
                recognizer.view?.transform = scale
                
                view.addSubview(scalingLabel)
                scalingLabel.center = CGPoint(x: view.center.x - 200, y: view.center.y + 200)
                view.bringSubviewToFront(scalingLabel)
                scalingFactor = scalingFactor * recognizer.scale
                scalingLabel.text = Languages.getEntryFromJSON(section: .sign, entry: .header15)
                scalingLabel.text?.append("\(Int(scalingFactor * 100)) %")
                
                recognizer.scale = 1.0
            }
            
            if recognizer.state == .ended {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
                    self.scalingLabel.removeFromSuperview()
                    self.view.bringSubviewToFront(self.saveButton)
                }
            }
            
        } else {
            return
        }
    }
    
    func addDoubleTapRecognizerToWatermarkView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        watermarkView.addGestureRecognizer(tapRecognizer)
        watermarkView.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.view != nil {
            if recognizer.state == .ended {
                isOpacity = !isOpacity
            }
            
        } else { return }
    }
    
    // set watermark position view
    // called once - when watermark is selected
    func setWatermarkPosition() {
        
        if watermarkImage != nil {
            watermarkView.image = watermarkImage
         }
        
        view.addSubview(watermarkView)
        
        var watermarkViewSize = CGSize()
        
        if watermarkImage != nil {
            watermarkViewSize = watermarkView.image!.size
            
        } else {
            watermarkViewSize = view.bounds.size
        }
        
        if watermarkViewSize.width > view.bounds.size.width {
            scalingFactor = view.bounds.size.width / watermarkViewSize.width
            
            watermarkViewSize.width = view.bounds.size.width
            watermarkViewSize.height = watermarkViewSize.height * scalingFactor
        }
        
        if watermarkViewSize.height > view.bounds.size.height {
            scalingFactor = view.bounds.size.height / watermarkViewSize.height
            
            watermarkViewSize.height = view.bounds.size.height
            watermarkViewSize.width = watermarkViewSize.width * scalingFactor
        }
        
//        print("watermarkImage: \(watermarkImage.size.width) x \(watermarkImage.size.height)")
//        print("scalingFactor: \(scalingFactor)")
//        print("watermarkViewSize: \(watermarkViewSize.width) x \(watermarkViewSize.height)")
        
 //       watermarkView.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: watermarkViewSize.width, height: watermarkViewSize.height)
        watermarkView.frame = CGRect(origin: .zero, size: watermarkViewSize)
        
        watermarkView.sizeThatFits(watermarkViewSize)
        watermarkView.setNeedsDisplay()
         
        watermarkView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        
        addPinchRecognizerToWatermarkView()
        addPanRecognizerToWatermarkView()
        addDoubleTapRecognizerToWatermarkView()
    }

    // MARK: - retrieve watermark image from ming sign folder
    func setWatermarkImage() {
        watermarkImage = ImageStorage.retrieveImagePNGFromFileSystem(forKey: watermarkKey)
        setWatermarkPosition()
        selectImage()
    }
    
    // MARK: select image from image picker or file system
    @objc func selectImage() {
        if isImageSelected == true {
            if actualImageKey < imageKeys.count {
                selectImageByActualKey(actualKey: actualImageKey)
            }
            
        } else {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            present(picker, animated: true, completion: {
                // if image picker is dismissed (just closed, not canceled)
                self.saveButton.isHidden = true
                self.selectImageButton.isHidden = false
                
                self.selectImageButton.removeFromSuperview()
                self.view.addSubview(self.selectImageButton)
                self.selectImageButton.center = self.buttonCenter
                self.view.bringSubviewToFront(self.selectImageButton)

                self.saveButton.removeFromSuperview()
            })
        }
        
        // set watermark image (if image picker is dismissed)
        moveWatermark(toPoint: startWatermarkPoint)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // shows selected image
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            self.setSelectedImage(self.selectedImage)
            self.moveWatermark(toPoint: self.startWatermarkPoint)
            
            self.saveButton.isHidden = false
            self.selectImageButton.isHidden = true

            self.saveButton.removeFromSuperview()
            self.view.addSubview(self.saveButton)
            self.saveButton.center = buttonCenter
            self.view.bringSubviewToFront(self.saveButton)

            self.selectImageButton.removeFromSuperview()
        } 
        
        // finish pickerController
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        selectedImage = UIImage()
        setSelectedImage(selectedImage)
        moveWatermark(toPoint: startWatermarkPoint)
        
        saveButton.isHidden = true
        selectImageButton.isHidden = false
        
        selectImageButton.removeFromSuperview()
        view.addSubview(selectImageButton)
        selectImageButton.center = buttonCenter
        view.bringSubviewToFront(selectImageButton)

        saveButton.removeFromSuperview()

        // (re)set to moving mode
        isOpacity = false
        
        dismiss(animated: true, completion: nil)
    }
    
    // returns selected image from file system
    func selectedImageFromFileSystem(key: String) -> UIImage? {
        if let selectedImage = ImageStorage.retrieveImagePNGFromFileSystem(forKey: key) {
            return selectedImage
        }
        
        return nil
    }
    
    func setSelectedImage(_ image: UIImage) {
        if imageView == nil {
            imageView = UIImageView()
            
        } else {
            imageViewSize = CGSize(width: 0.0, height: 0.0)
            imageView.frame = CGRect(origin: .zero, size: imageViewSize)
            imageView.removeFromSuperview()
        }
        
        view.addSubview(imageView)
    
        var sizeY: CGFloat = 0.0
        var sizeX: CGFloat = 0.0
    
        var ratio = image.size.width / image.size.height
        let ratioScreen = maxImageViewWidth / maxImageViewHeight

        if image.size.width == 0 || image.size.height == 0 {
            sizeX = maxImageViewWidth
            sizeY = maxImageViewHeight
            ratio = ratioScreen
        }
        
        // device landscape
        if ratioScreen > 1 {
            // image landscape
            if ratio > 1 {
                if ratio < ratioScreen {
                    // image less wide than screen width
                    // image height = screen height
                    sizeY = maxImageViewHeight
                    sizeX = sizeY * ratio
                    
                } else {
                    // image less high than screen height
                    // image width = screen width
                    sizeX = maxImageViewWidth
                    sizeY = sizeX / ratio
                }
            // image square or portrait
            } else {
                // image height = screen height
                sizeY = maxImageViewHeight
                sizeX = sizeY * ratio
            }
          
        // device portrait
        } else {
            // image portrait
            if ratio < 1 {
                if ratio < ratioScreen {
                    // image less wide than screen width
                    // image height = screen height
                    sizeY = maxImageViewHeight
                    sizeX = sizeY * ratio
                    
                } else {
                    // image less high than screen height
                    // image width = screen width
                    sizeX = maxImageViewWidth
                    sizeY = sizeX / ratio
                }
             
            // image square or landscape
            } else {
                // image width = screen width
                sizeX = maxImageViewWidth
                sizeY = sizeX / ratio
            }
        }
        
        imageViewSize = CGSize(width: sizeX, height: sizeY)
        imageView.frame = CGRect(origin: .zero, size: imageViewSize)

        imageView.image = image
        imageView.setNeedsDisplay()
    }
    
    
    // MARK: - move watermark
    func moveWatermark(toPoint: CGPoint) {
        watermarkView.center = toPoint
        view.bringSubviewToFront(watermarkView)
        view.bringSubviewToFront(saveButton)
        view.bringSubviewToFront(selectImageButton)
        view.bringSubviewToFront(opacityLabel)
        view.bringSubviewToFront(scalingLabel)
    }
    
    // MARK: - saveUIImage() (returns UIImage from imageView context)
    func saveUIImage(toPoint: CGPoint) -> UIImage? {
        
        if selectedImage == nil {
            imageViewSize = CGSize(width: maxImageViewWidth, height: maxImageViewHeight)
        }
        
        // context within imageView
        UIGraphicsBeginImageContext(imageViewSize)
        
        // draw: image
        if selectedImage != nil {
            selectedImage.draw(in: CGRect(origin: .zero, size: imageViewSize))
        }

        watermarkView.image?.draw(in: CGRect(x: toPoint.x - watermarkView.frame.size.width / 2, y: toPoint.y - watermarkView.frame.size.height / 2, width: watermarkView.frame.size.width , height: watermarkView.frame.size.height), blendMode: .normal, alpha: alphaValue)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // save in 300dpi
        if let source = image, let cgSource = source.cgImage {
            let my300dpiImage = UIImage(cgImage: cgSource, scale: 300.0 / 72.0, orientation: source.imageOrientation)
            image = my300dpiImage
 //           print("saved with 300dpi")
        }
        
        return image
    }
    
    @objc func saveImage() {
        // only ming sign folder
        if ImageStorage.retrieveSettings()[1] == true && ImageStorage.retrieveSettings()[2] == false {
            saveImageToFileSystem("signedImage")
            saveSetLayout()
        }
        
        // only photo library
        if ImageStorage.retrieveSettings()[2] == true && ImageStorage.retrieveSettings()[1] == false {
            if let image = self.saveUIImage(toPoint: watermarkView.center) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                saveSetLayout()
            }
        }
        
        // ming sign folder and photo library
        if ImageStorage.retrieveSettings()[2] == true && ImageStorage.retrieveSettings()[1] == true {
            if let image = self.saveUIImage(toPoint: watermarkView.center) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            saveImageToFileSystem("signedImage")
            saveSetLayout()
        }
        
        // default saving to photo library
        if ImageStorage.retrieveSettings()[2] == false && ImageStorage.retrieveSettings()[1] == false {
            if let image = self.saveUIImage(toPoint: watermarkView.center) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                saveSetLayout()
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "okay", style: .default))
            present(ac, animated: true)
        
        } else {
            // nothing
        }
    }
    
    // MARK: - save a single image to file system
    func saveImageToFileSystem(_ imageKey: String) {
        if let image = saveUIImage(toPoint: watermarkView.center) {
            DispatchQueue.global(qos: .background).async {
                ImageStorage.storeImage(image: image, forKey: imageKey)
            }
        }
    }
    
    func selectImageByActualKey(actualKey: Int) {
        if actualKey < imageKeys.count {

            if let image = selectedImageFromFileSystem(key: imageKeys[actualKey]) {
                selectedImage = image
                setSelectedImage(selectedImage)
                
                if watermarkView != nil {
                    moveWatermark(toPoint: watermarkView.center)
                    
                } else {
                    moveWatermark(toPoint: startWatermarkPoint)
                }
                
                saveButton.isHidden = false
                selectImageButton.isHidden = true
            }
            
        } else {
            print("no imageKey available")
            
            saveButton.isHidden = true
            selectImageButton.isHidden = false
            selectImageButton.removeFromSuperview()
            view.addSubview(selectImageButton)
            selectImageButton.center = buttonCenter
            view.bringSubviewToFront(selectImageButton)

            saveButton.removeFromSuperview()
        }
    }
    
    func saveSetLayout() {
        view.addSubview(savedAlertLabel)
        savedAlertLabel.text = Languages.getEntryFromJSON(section: .sign, entry: .header12)
        savedAlertLabel.sizeToFit()
        savedAlertLabel.center = view.center
        view.bringSubviewToFront(savedAlertLabel)
        
        imageView.image = UIImage()
        imageView.setNeedsDisplay()
        
//        print("saved image no. \(actualImageKey)")
        actualImageKey = actualImageKey + 1
        
        if actualImageKey < imageKeys.count {
            print("next image no. \(actualImageKey)")
            selectImageByActualKey(actualKey: actualImageKey)
            
        } else if isImageSelected == true {
 //           print("last image had been saved: no. \(actualImageKey - 1)")
            savedAlertLabel.text = Languages.getEntryFromJSON(section: .sign, entry: .header13)
            savedAlertLabel.sizeToFit()
            
           // select new images
            selectImageButton.isHidden = false
            
            selectImageButton.removeFromSuperview()
            view.addSubview(selectImageButton)
            selectImageButton.center = buttonCenter
            view.bringSubviewToFront(selectImageButton)

            saveButton.removeFromSuperview()
            
            isImageSelected = false
            
            selectedImage = UIImage()
            setSelectedImage(selectedImage)

        } else {
            print("no image to save anymore")
            saveButton.removeFromSuperview()
            
            selectImageButton.removeFromSuperview()
            view.addSubview(selectImageButton)
            selectImageButton.center = buttonCenter
            selectImageButton.isHidden = false
            view.bringSubviewToFront(selectImageButton)
            
            selectedImage = UIImage()
            setSelectedImage(selectedImage)
        }
         
         // (re)set to moving mode
        isOpacity = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
            self.savedAlertLabel.removeFromSuperview()
        }
    }
}

extension MergingView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

