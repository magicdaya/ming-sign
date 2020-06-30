//
//  WatermarkView.swift
//  ming sign
//
//  Created by magicday.a on 03.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import UIKit
import SwiftUI
import PencilKit


protocol ToolsDelegate: class {
//    func onTouchesInPencilCanvas()
    func onApplyTextChanges()
    func onApplyTextViewChanges()
    func fixEditTextView()
//    func setBackgroundColor()
//    func hideEditTextView()
}

class WatermarkView: UIViewController, UIScreenshotServiceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, ToolsDelegate {
    
    var savedAlertLabel: UILabel = {
        let label = UILabel()
        label.text = Languages.getEntryFromJSON(section: .create, entry: .header5)
        label.backgroundColor = .clear
        label.textColor = .systemPurple
        label.font = .systemFont(ofSize: 27)
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }()
    
    var isWatermark = false
    var lastWatermarkPoint: CGPoint = CGPoint(x: 100, y: 100)
    
    var isTextWritingMode = false

    var canvasView: PencilCanvas = PencilCanvas()

    var textFieldArrayNumber: Int = 0
    var textFieldArray: [UITextField]!
    var textFieldHue: [CGFloat] = [CGFloat]()
    var textFieldSaturation: [CGFloat] = [CGFloat]()
    var textFieldBrightness: [CGFloat] = [CGFloat]()
    var textFieldAlphaValue: [CGFloat] = [CGFloat]()
    
    var textImageViewArray: [UIImageView] = [UIImageView]()

    var watermarkImage: UIImage!
    
    var savedDrawing: PKDrawing = PKDrawing()

    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 29)
        button.setTitle(Languages.getEntryFromJSON(section: .create, entry: .header6), for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.sizeToFit()
        button.addTarget(self, action: #selector(handleSaveWatermark), for: .touchUpInside)
        return button
    }()
    
    // create new text view
    var createTextViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 29)
        button.setTitle(" abc ", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.sizeToFit()
        button.addTarget(self, action: #selector(handleCreateNewText), for: .touchUpInside)
        
        return button
    }()
    
    var textViewEditingSize: CGSize = CGSize(width: 500, height: 50)
    var panRecognizerEdit = UIPanGestureRecognizer()
    var editTextView: EditTextView!
    
    var toolPicker: PKToolPicker!
    
    // * * * * * * * * * * * * * * * * * * * *
    // Set up the drawing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // set up the tool picker, using the window of the parent because the view has not
        // been added to a window yet.
        if let window = parent?.view.window, let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder() // show drawing tools
            self.toolPicker = toolPicker
        }
        
        parent?.view.window?.windowScene?.screenshotService?.delegate = self
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        canvasView.frame = view.bounds
        canvasView.delegatePencilCanvas = self
        
        view.addSubview(canvasView)
        textFieldArray = [UITextField]()

        editTextView = EditTextView()
        editTextView.frame = CGRect(x: 0, y: 0, width: 280, height: 580)
        editTextView.layer.cornerRadius = 140
        editTextView.layer.borderWidth = 1
        editTextView.layer.borderColor = UIColor.lightGray.cgColor
        editTextView.clipsToBounds = true
        editTextView.delegate = self
        
        canvasView.drawing = savedDrawing
        
        setBackgroundColor()

        if traitCollection.userInterfaceStyle == .light {
            editTextView.backgroundColor = .white
            
        } else {
            editTextView.backgroundColor = .black
        }
        
        activateCanvas()
        
        view.addSubview(createTextViewButton)
        view.addSubview(saveButton)
        view.addSubview(editTextView)
        
        saveButton.center = CGPoint(x: view.frame.size.width - 100, y: view.frame.size.height - 200)
        createTextViewButton.center = CGPoint(x: view.frame.size.width - 80, y: 50)
        editTextView.center = CGPoint(x: 160, y: view.center.y)
        editTextView.isHidden = true
        
        addPanRecognizerToButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if watermarkImage != nil && ImageStorage.retrieveSettings()[3] == true {
            handleSaveWatermark()
        }
    }
    
    override func viewWillLayoutSubviews() {
        // re-set buttons and editTextView when rotating
        saveButton.removeFromSuperview()
        createTextViewButton.removeFromSuperview()
        editTextView.removeFromSuperview()
        
        saveButton.center = CGPoint(x: view.frame.size.width - 100, y: view.frame.size.height - 200)
        createTextViewButton.center = CGPoint(x: view.frame.size.width - 80, y: 50)
        editTextView.center = CGPoint(x: 160, y: view.center.y)
        
        view.addSubview(createTextViewButton)
        view.addSubview(saveButton)
        view.addSubview(editTextView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .light {
            editTextView.backgroundColor = .white
            
            if ImageStorage.retrieveColor() == 1 || ImageStorage.retrieveColor() == 0 {
                canvasView.backgroundColor = .white
                editTextView.backgroundColor = .white
                
            } else {
                canvasView.backgroundColor = .black
                editTextView.backgroundColor = .black
            }
            
        } else {
            editTextView.backgroundColor = .black
            
            if ImageStorage.retrieveColor() == 1 {
                canvasView.backgroundColor = .white
                editTextView.backgroundColor = .white
                
            } else {
                canvasView.backgroundColor = .black
                editTextView.backgroundColor = .black
            }
        }
    }
    
    func setBackgroundColor() {
        if ImageStorage.retrieveColor() == 1 {
            canvasView.backgroundColor = .white
            editTextView.backgroundColor = .white
            
        } else if ImageStorage.retrieveColor() == 2 {
            canvasView.backgroundColor = .black
            editTextView.backgroundColor = .black
            
        } else {
            // light / dark
            if traitCollection.userInterfaceStyle == .light {
                canvasView.backgroundColor = .white
                editTextView.backgroundColor = .white
                
            } else {
                canvasView.backgroundColor = .black
                editTextView.backgroundColor = .black
            }
        }
    }
    
    func onApplyTextChanges() {
        if isTextWritingMode == true {
            editTextView.textColor = UIColor(hue: editTextView.hue, saturation: editTextView.saturation, brightness: editTextView.brightness, alpha: editTextView.alphaValue)

            if textFieldArray.count > textFieldArrayNumber {
                if editTextView.selectedFont == "System Font" {
                    textFieldArray[textFieldArrayNumber].font = .systemFont(ofSize: editTextView.fontSize)
                } else {
                    textFieldArray[textFieldArrayNumber].font = UIFont(name: editTextView.selectedFont, size: editTextView.fontSize)
                }
                // textColor
                textFieldArray[textFieldArrayNumber].textColor = editTextView.textColor
                textFieldHue[textFieldArrayNumber] = editTextView.hue
                textFieldSaturation[textFieldArrayNumber] = editTextView.saturation
                textFieldBrightness[textFieldArrayNumber] = editTextView.brightness
                textFieldAlphaValue[textFieldArrayNumber] = editTextView.alphaValue
                
                // textField
                textFieldArray[textFieldArrayNumber].sizeToFit()
            //    textFieldArray[textFieldArrayNumber].frame.size = CGSize(width: textFieldArray[textFieldArrayNumber].frame.size.width * 1.5, height: textFieldArray[textFieldArrayNumber].frame.size.height * 1.5)
                
                // better create in onApplyTextViewChanges due to size!!!
          //      createTextFieldImage(number: textFieldArrayNumber)
            }
        }
    }
    
    @objc func onApplyTextViewChanges() {
        onApplyTextChanges()
        
        for i in 0..<textFieldArray.count {
            textFieldArray[i].endEditing(true)
            textFieldArray[i].backgroundColor = .clear
            
            // textField
            textFieldArray[i].sizeToFit()
            textFieldArray[i].frame.size = CGSize(width: textFieldArray[i].frame.size.width * 1.5, height: textFieldArray[i].frame.size.height * 1.5)
            
            createTextFieldImage(number: i)
            
            // show textImageView instead of textField
            textFieldArray[i].center = textImageViewArray[i].center
            textFieldArray[i].isHidden = true
            textImageViewArray[i].isHidden = false
        }
        
        for i in 0...2 {
            editTextView.colorButtons[i].layer.borderWidth = 0
        }
        
        editTextView.oldColorButton.layer.borderWidth = 5
        
        
        // dismiss editTextView
        editTextView.isHidden = true
        editTextView.addGestureRecognizer(panRecognizerEdit)
        
        // show toolpicker again after closing the editor
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    // MARK: - add pan recognizer to buttons - for moving save & create text view buttons to custom place
    func addPanRecognizerToButtons() {
        let panRecognizerSave = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        saveButton.addGestureRecognizer(panRecognizerSave)
        let panRecognizerCreate = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        createTextViewButton.addGestureRecognizer(panRecognizerCreate)
        panRecognizerEdit = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        editTextView.addGestureRecognizer(panRecognizerEdit)
    }
    
    // fix edit text view while changing text field values
    func fixEditTextView() {
        editTextView.removeGestureRecognizer(panRecognizerEdit)
    }

    // MARK: - pan recognizer for text field
//    func addPanRecognizerToTextField(textField: UITextView) {
    func addPanRecognizerToTextField(textField: UITextField) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        textField.addGestureRecognizer(panRecognizer)
        textField.isUserInteractionEnabled = true
    }
    
    // add pan to textImageView
    func addPan(imageView: UIImageView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(pan)
        imageView.isUserInteractionEnabled = true
    }
    
    // add tap to textImageView
    func addTap(imageView: UIImageView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
    }
    /*
    // MARK: - tap recognizer (to edit text fields)
    func addOneTapRecognizerToTextField(textField: UITextField) {
        let oneTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOneTap(_:)))
        textField.isUserInteractionEnabled = true
        textField.addGestureRecognizer(oneTapRecognizer)
    }
    */
    
    // MARK: - pan recognizer for any view
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // tap imageView to change the related textField
    @objc func onTapImageView(_ recognizer: UITapGestureRecognizer) {
        if let imageView = recognizer.view {
            for i in 0..<textImageViewArray.count {
                if imageView == textImageViewArray[i] {
                    // hide all textFields and show imageViews
                    for m in 0..<textFieldArray.count {
                        textFieldArray[m].isHidden = true
                        
                        if m < textImageViewArray.count {
                            textImageViewArray[m].isHidden = false
                            textFieldArray[m].center = textImageViewArray[m].center
                        }
                    }
                    
                    if i < textFieldArray.count {
                        textFieldArrayNumber = i
                        textFieldArray[i].sizeToFit()
                        textFieldArray[i].frame.size = CGSize(width: textFieldArray[i].frame.size.width * 1.5, height: textFieldArray[i].frame.size.height * 1.5)
                        
                        if i < textImageViewArray.count {
                            textFieldArray[i].center = textImageViewArray[i].center
                        }
                        
                        if let color = textFieldArray[i].textColor {
                            editTextView.textColor = color
                            editTextView.oldColorButton.backgroundColor = color
                        }
                        
                        if let fontsize = textFieldArray[i].font?.pointSize {
                            editTextView.fontSize = fontsize
                        }
                        
                        if let fontName: String = textFieldArray[i].font?.familyName {
                            var defaultFontNumber = 0
                            
                            for m in 0..<editTextView.fontArray.count {
                                if editTextView.fontArray[m] == fontName {
                                    defaultFontNumber = m
                                }
                            }
                            editTextView.pickerView.selectRow(defaultFontNumber, inComponent: 0, animated: true)
                            editTextView.selectedFont = fontName
                        }
                        
                        editTextView.hue = textFieldHue[i]
                        editTextView.saturation = textFieldSaturation[i]
                        editTextView.brightness = textFieldBrightness[i]
                        editTextView.alphaValue = textFieldAlphaValue[i]
                        
                        editTextView.oldHue = textFieldHue[i]
                        editTextView.oldSaturation = textFieldSaturation[i]
                        editTextView.oldBrightness = textFieldBrightness[i]
                        editTextView.oldAlphaValue = textFieldAlphaValue[i]
                        
                        textFieldArray[i].allowsEditingTextAttributes = true
                        textFieldArray[i].endEditing(false)
                        
                        isTextWritingMode = true
                        
                        for i in 0...2 {
                            editTextView.colorButtons[i].layer.borderWidth = 0
                        }
                        
                        editTextView.oldColorButton.layer.borderWidth = 5
                        editTextView.setNeedsDisplay()
                        
                        editTextView.isHidden = false
                        editTextView.addGestureRecognizer(panRecognizerEdit)
                        view.bringSubviewToFront(editTextView)
                        
                        setBackgroundColor()
                        
                        imageView.isHidden = true
                        // show the active text field
                        textFieldArray[i].isHidden = false
                        textFieldArray[i].center = imageView.center
                     }
                }
            }
        }
    }
    
    fileprivate func activateCanvas() {
        if isTextWritingMode == true  {
            canvasView.saveDrawing()
            savedDrawing = canvasView.drawing
            watermarkImage = canvasView.createUIImage()
        }
    }
    
    // MARK: - handleCreateNewText()
    @objc func handleCreateNewText() {
        isTextWritingMode = true
        activateCanvas()
        createTextField()
        setBackgroundColor()
    }
    
    // MARK: - createTextField()
    fileprivate func createTextField() {
        isTextWritingMode = true
        
        if textFieldArray.count > 0 {
            for i in 0..<textFieldArray.count {
                textFieldArray[i].endEditing(true)
                textFieldArray[i].backgroundColor = .clear
                
                // textField
                textFieldArray[i].sizeToFit()
                textFieldArray[i].frame.size = CGSize(width: textFieldArray[i].frame.size.width * 1.5, height: textFieldArray[i].frame.size.height * 1.5)
            }
        }
        
        let newTextField = UITextField(frame: CGRect(origin: CGPoint(x: view.center.x, y: view.center.y - 180), size: textViewEditingSize))
        view.addSubview(newTextField)
        view.bringSubviewToFront(newTextField)
        newTextField.setNeedsDisplay()
        
 //       addPanRecognizerToTextField(textField: newTextField)
//        addOneTapRecognizerToTextField(textField: newTextField)
        
        newTextField.textColor = editTextView.textColor
        
        if editTextView.selectedFont == "System Font" {
            newTextField.font = .systemFont(ofSize: editTextView.fontSize)
            
        } else {
            newTextField.font = UIFont(name: editTextView.selectedFont, size: editTextView.fontSize)
        }
        
        newTextField.autocapitalizationType = .none
        newTextField.autocorrectionType = .no
        newTextField.keyboardAppearance = .default
        newTextField.keyboardType = .default
        newTextField.delegate = self
        newTextField.allowsEditingTextAttributes = true
        newTextField.text = "magic."
        newTextField.textAlignment = .left
        newTextField.endEditing(false)
        
        newTextField.sizeToFit()
        newTextField.frame.size = CGSize(width: newTextField.frame.size.width * 1.5, height: newTextField.frame.size.height * 1.5)
        newTextField.addTarget(self, action: #selector(setTextFieldSize(_:)), for: .editingChanged)
        
        let newTextImageView = UIImageView()
        view.addSubview(newTextImageView)
        newTextImageView.isHidden = true
        newTextImageView.frame.size = newTextField.frame.size
    //    newTextImageView.frame.size = CGSize(width: newTextField.frame.size.width * 1.5, height: newTextField.frame.size.height * 1.5)
        newTextImageView.center = newTextField.center
        
        addTap(imageView: newTextImageView)
        addPan(imageView: newTextImageView)
        
        // describes the position of newTextField in textFieldArray
        newTextField.accessibilityIdentifier = String(textFieldArray.count)
        newTextImageView.accessibilityIdentifier = String(textImageViewArray.count)
        
        textImageViewArray.append(newTextImageView)
        textFieldArray.append(newTextField)
        
        createTextFieldImage(number: textImageViewArray.count - 1)
        
        textFieldHue.append(editTextView.hue)
        textFieldBrightness.append(editTextView.brightness)
        textFieldSaturation.append(editTextView.saturation)
        textFieldAlphaValue.append(editTextView.alphaValue)
        
        textFieldArrayNumber = textFieldArray.count - 1
        
        for i in 0...2 {
            editTextView.colorButtons[i].layer.borderWidth = 0
        }
        
        editTextView.oldColorButton.layer.borderWidth = 5
        editTextView.setNeedsDisplay()
        
        editTextView.isHidden = false
        editTextView.addGestureRecognizer(panRecognizerEdit)
        view.bringSubviewToFront(editTextView)
    }
    
    @objc func setTextFieldSize(_ sender: UITextField) {
        sender.sizeToFit()
        sender.frame.size = CGSize(width: sender.frame.size.width * 1.5, height: sender.frame.size.height * 1.5)

        if textImageViewArray.count > textFieldArrayNumber {
            createTextFieldImage(number: textFieldArrayNumber)
            sender.center = textImageViewArray[textFieldArrayNumber].center
            textImageViewArray[textFieldArrayNumber].frame.size = sender.frame.size
        }
    }
    
    /*
    func hideEditTextView() {
      //  editTextView.isHidden = true
        for i in 0..<textImageViewArray.count {
            textImageViewArray[i].isHidden = false
            
            if i < textFieldArray.count {
                textFieldArray[i].isHidden = true
            }
        }
        
        // the following doesn't work with pencil kit !!!
//        editTextView.addGestureRecognizer(panRecognizerEdit)
//
//        // show toolpicker again after closing the editor
//        toolPicker.setVisible(true, forFirstResponder: canvasView)
//        toolPicker.addObserver(canvasView)
//        canvasView.becomeFirstResponder()
    }
    */
    
    // MARK: - with text field: create watermark image (drawing & text)
    fileprivate func createWatermarkImage() {
        var size = self.view.frame.size
        
        if watermarkImage != nil {
            size = watermarkImage.size
        }
        
        if textFieldArray.count > 0 {
            for i in 0..<textFieldArray.count {
                // else the modifed text will not be taken
                textFieldArray[i].endEditing(true)
            }
        }
        
        UIGraphicsBeginImageContext(size)
        
        if watermarkImage != nil {
            let area = CGRect(x: 0, y: 0, width: watermarkImage.size.width, height: watermarkImage.size.height)
            watermarkImage.draw(in: area)
        }
        
        for i in 0..<textImageViewArray.count {
            textImageViewArray[i].image?.draw(at: CGPoint(x: textImageViewArray[i].center.x - textImageViewArray[i].frame.size.width / 2, y: textImageViewArray[i].center.y - textImageViewArray[i].frame.size.height / 2))
        }
        
        /*
        if textFieldArray.count > 0 {
            for i in 0..<textFieldArray.count {
                NSString(string: textFieldArray[i].text ?? "").draw(at: CGPoint(x: textFieldArray[i].center.x - textFieldArray[i].frame.size.width / 2, y: textFieldArray[i].center.y - textFieldArray[i].frame.size.height / 2), withAttributes: [NSAttributedString.Key.font: textFieldArray[i].font ?? UIFont.systemFont(ofSize: 0), NSAttributedString.Key.foregroundColor: textFieldArray[i].textColor ?? UIColor.clear])
                
                if textFieldArray[i].font?.pointSize != nil {
                }
            }
        }
        */

        watermarkImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // scale to height = 2500 px
//        watermarkImage = watermarkImage.scaledTo(height: 2500)
        
        // save in 300dpi
        if let source = watermarkImage, let cgSource = source.cgImage {
            let my300dpiImage = UIImage(cgImage: cgSource, scale: 300.0 / 72.0, orientation: source.imageOrientation)
            watermarkImage = my300dpiImage
       //     print("saved with 300dpi")
        }  
    }
    
    
    fileprivate func createTextFieldImage(number: Int) {
        
        if textFieldArray.count > number && textImageViewArray.count > number {
 //           print("textFieldArray.size: \(textFieldArray[number].frame.size.width) x \(textFieldArray[number].frame.size.height)")
            let textFieldSize = textFieldArray[number].frame.size
            let innerTextFieldWidth = textFieldSize.width / 1.5
            let innerTextFieldHeight = textFieldSize.height / 1.5
//            let size = CGSize(width: textFieldSize.width * 1.5, height: textFieldSize.height * 1.5)
            let size = CGSize(width: textFieldSize.width, height: textFieldSize.height)
            UIGraphicsBeginImageContext(size)
                    
//            NSString(string: textFieldArray[number].text ?? "").draw(at: CGPoint(x: (size.width - textFieldSize.width) / 2, y: (size.height - textFieldSize.height) / 2), withAttributes: [NSAttributedString.Key.font: textFieldArray[number].font ?? UIFont.systemFont(ofSize: 0), NSAttributedString.Key.foregroundColor: textFieldArray[number].textColor ?? UIColor.clear])
            NSString(string: textFieldArray[number].text ?? "").draw(at: CGPoint(x: (size.width - innerTextFieldWidth) / 2, y: (size.height - innerTextFieldHeight) / 2), withAttributes: [NSAttributedString.Key.font: textFieldArray[number].font ?? UIFont.systemFont(ofSize: 0), NSAttributedString.Key.foregroundColor: textFieldArray[number].textColor ?? UIColor.clear])

            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                textImageViewArray[number].frame.size = image.size
                textImageViewArray[number].image = image
                textImageViewArray[number].sizeToFit()
            }
            
            UIGraphicsEndImageContext()
        }
    }
    
    // MARK: - handleSaveWatermark()
    @objc func handleSaveWatermark() {
        watermarkImage = canvasView.createUIImage()
        createWatermarkImage()
          
        // save image to user defaults
        if watermarkImage != nil {
            isWatermark = true
            saveImageToFileSystem("watermarkImage")
        }
    }
    
    // MARK: - save a single watermark image to file system
    func saveImageToFileSystem(_ imageKey: String) {
        if let watermarkImage = self.watermarkImage {
            DispatchQueue.global(qos: .background).async {
                ImageStorage.storeImage(image: watermarkImage, forKey: imageKey)
 //               print("watermark image saved to file system")
            }
        }
    }
    
    func showSavedMessage() {
        self.view.addSubview(savedAlertLabel)
        self.savedAlertLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 200)
        self.view.bringSubviewToFront(self.savedAlertLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
             self.savedAlertLabel.removeFromSuperview()
        }
    }
}

extension WatermarkView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// resizing UIImage
extension UIImage {
    func scaledTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
            
        } else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
    }
    
    // resizing an UIImage with given new height value
    func scaledTo(height: CGFloat) -> UIImage {
        let width = height * self.size.width / self.size.height
        
        return scaledTo(size: CGSize(width: width, height: height))
    }
}

