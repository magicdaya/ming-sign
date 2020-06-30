//
//  EditTextView.swift
//  ming sign
//
//  Created by magicday.a on 02.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import UIKit

class EditTextView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    weak var delegate: ToolsDelegate?
    
    var fontArray = UIFont.familyNames.sorted()
    var selectedFont: String = "Helvetica"
    var textColor: UIColor = UIColor(hue: 0.7, saturation: 0.6, brightness: 1.0, alpha: 1.0)
    var fontSize: CGFloat = 42.0
    
    var hue: CGFloat = 0.7
    var saturation: CGFloat = 0.6
    var brightness: CGFloat = 1.0
    var alphaValue: CGFloat = 1.0
    
    var pickerLabel: UILabel = {
        let label = UILabel()
        label.text = "font family"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemIndigo
        label.sizeToFit()
        label.textAlignment = .left
        
        return label
    }()
    
    var pickerView = UIPickerView()
    
    var fontSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "font size"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemIndigo
        label.sizeToFit()
        label.textAlignment = .left
        
        return label
    }()
    
    var fontSizeValueLabel: UILabel = {
       let label = UILabel()
       label.text = "42"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var fontSizeValueTextField: UITextField = {
        let textField = UITextField()
        textField.text = "42"
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .systemIndigo
        textField.sizeToFit()
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
       
        return textField
    }()

    var oldHue: CGFloat = 0.7
    var oldSaturation: CGFloat = 1.0
    var oldBrightness: CGFloat = 1.0
    var oldAlphaValue: CGFloat = 1.0
    
    var oldColorButton: UIButton!
    
    var colorButtons: [UIButton]!
    var hueColorButtons: [CGFloat] = [0.3, 0.5, 0.8]
    var saturationColorButtons: [CGFloat] = [1.0, 0.5, 0.8]
    var brightnessColorButtons: [CGFloat] = [1.0, 1.0, 1.0]
    var alphaValueColorButtons: [CGFloat] = [1.0, 1.0, 1.0]
        
    var hueLabel: UILabel = {
       let label = UILabel()
       label.text = "hue"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var hueSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        
        return slider
    }()
    
    var hueValueLabel: UILabel = {
       let label = UILabel()
       label.text = "0.700"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
        
    var saturationLabel: UILabel = {
       let label = UILabel()
       label.text = "saturation"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var saturationSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        
        return slider
    }()
    
    var saturationValueLabel: UILabel = {
       let label = UILabel()
       label.text = "1.000"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var brightnessLabel: UILabel = {
       let label = UILabel()
       label.text = "brigthness"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var brightnessSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        
        return slider
    }()
    
    var brightnessValueLabel: UILabel = {
       let label = UILabel()
       label.text = "1.000"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var alphaValueLabel: UILabel = {
       let label = UILabel()
       label.text = "alpha"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var alphaValueSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        
        return slider
    }()
    
    var alphaValueValueLabel: UILabel = {
       let label = UILabel()
       label.text = "1.000"
       label.font = .systemFont(ofSize: 16)
       label.textColor = .systemIndigo
       label.sizeToFit()
       label.textAlignment = .left
       
       return label
    }()
    
    var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.sizeToFit()
        
        return button
    }()
    
    /* * * * * * * * * * * * * * * * * */
    override func draw(_ rect: CGRect) {
        var defaultFontNumber = 0
        
        // set default font to picker
        for i in 0..<fontArray.count {
            if fontArray[i] == selectedFont {
                defaultFontNumber = i
            }
        }
        
        oldColorButton = UIButton(frame: CGRect(x: 200, y: 260, width: 42, height: 42))
        oldColorButton.layer.cornerRadius = 21
        oldColorButton.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alphaValue)
        oldColorButton.clipsToBounds = true
        oldColorButton.layer.borderColor = UIColor.systemPurple.cgColor
        oldColorButton.layer.borderWidth = 5
        oldColorButton.addTarget(self, action: #selector(setOldColor(_:)), for: .touchUpInside)
        addSubview(oldColorButton)
        
        colorButtons = [UIButton]()

        // set saved values if existent
        displayColorValuesArray(key: "hueColorButtons", colorValue: .hue)
        displayColorValuesArray(key: "saturationColorButtons", colorValue: .saturation)
        displayColorValuesArray(key: "brightnessColorButtons", colorValue: .brightness)
        displayColorValuesArray(key: "alphaValueColorButtons", colorValue: .alphaValue)
        
        // create 3 colors to pick
        for i in 0...2 {
            let colorButton = UIButton(frame: CGRect(x: 20 + 50 * i, y: 260, width: 42, height: 42))
            colorButton.layer.cornerRadius = 21
            colorButton.backgroundColor = UIColor(hue: hueColorButtons[i], saturation: saturationColorButtons[i], brightness: brightnessColorButtons[i], alpha: alphaValueColorButtons[i])
            colorButton.clipsToBounds = true
            colorButton.layer.borderColor = UIColor.systemPurple.cgColor
            colorButton.addTarget(self, action: #selector(changeColor(_:)), for: .touchUpInside)
            colorButtons.append(colorButton)
            addSubview(colorButtons[i])
        }

        addSubview(pickerLabel)
        addSubview(pickerView)
        
        addSubview(fontSizeLabel)
        addSubview(fontSizeValueTextField)
        
        addSubview(hueLabel)
        addSubview(hueSlider)
        addSubview(hueValueLabel)
        addSubview(saturationLabel)
        addSubview(saturationSlider)
        addSubview(saturationValueLabel)
        addSubview(brightnessLabel)
        addSubview(brightnessSlider)
        addSubview(brightnessValueLabel)
        addSubview(alphaValueLabel)
        addSubview(alphaValueSlider)
        addSubview(alphaValueValueLabel)

        addSubview(oldColorButton)
        
        addSubview(applyButton)
        
        pickerLabel.center = CGPoint(x: 140, y: 50)
        
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        pickerView.frame.size.width = 240
        pickerView.frame.size.height = 80
        pickerView.center = CGPoint(x: 140, y: 110)
        pickerView.selectRow(defaultFontNumber, inComponent: 0, animated: true)
        
        fontSizeLabel.frame = CGRect(x: 20, y: 200, width: 100, height: 30)
        fontSizeValueTextField.frame = CGRect(x: 210, y: 200, width: 60, height: 30)
        fontSizeValueTextField.text = (String(Int(fontSize)))

        hueLabel.frame = CGRect(x: 20, y: 330, width: 100, height: 30)
        hueValueLabel.frame = CGRect(x: 210, y: 330, width: 60, height: 30)
        hueValueLabel.text = (String(format: "%.3f", hue))
        hueSlider.frame = CGRect(x: 120, y: 330, width: 80, height: 30)
        hueSlider.value = Float(hue)
        
        saturationLabel.frame = CGRect(x: 20, y: 370, width: 100, height: 30)
        saturationValueLabel.frame = CGRect(x: 210, y: 370, width: 60, height: 30)
        saturationValueLabel.text = (String(format: "%.3f", saturation))
        saturationSlider.frame = CGRect(x: 120, y: 370, width: 80, height: 30)
        saturationSlider.value = Float(saturation)
 
        brightnessLabel.frame = CGRect(x: 20, y: 410, width: 100, height: 30)
        brightnessValueLabel.frame = CGRect(x: 210, y: 410, width: 60, height: 30)
        brightnessValueLabel.text = (String(format: "%.3f", brightness))
        brightnessSlider.frame = CGRect(x: 120, y: 410, width: 80, height: 30)
        brightnessSlider.value = Float(brightness)
        
        alphaValueLabel.frame = CGRect(x: 20, y: 450, width: 100, height: 30)
        alphaValueValueLabel.frame = CGRect(x: 210, y: 450, width: 60, height: 30)
        alphaValueValueLabel.text = (String(format: "%.3f", alphaValue))
        alphaValueSlider.frame = CGRect(x: 120, y: 450, width: 80, height: 30)
        alphaValueSlider.value = Float(alphaValue)
        
        applyButton.center = CGPoint(x: frame.size.width - 80, y: frame.size.height - 50)
        guard let image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")?.withTintColor(.systemPurple, renderingMode: .alwaysOriginal) else { return }
        applyButton.setBackgroundImage(image, for: .normal)
        
        // actions
      //  fontSizeSlider.addTarget(self, action: #selector(onApplyTextChanges), for: .valueChanged)
        fontSizeValueTextField.addTarget(self, action: #selector(onApplyTextChanges), for: .editingDidEnd)  // .editingChanged
        hueSlider.addTarget(self, action: #selector(onApplyTextChanges), for: .valueChanged)
        saturationSlider.addTarget(self, action: #selector(onApplyTextChanges), for: .valueChanged)
        brightnessSlider.addTarget(self, action: #selector(onApplyTextChanges), for: .valueChanged)
        alphaValueSlider.addTarget(self, action: #selector(onApplyTextChanges), for: .valueChanged)
        applyButton.addTarget(self, action: #selector(onApplyTextViewChanges), for: .touchUpInside)
        
        fontSizeValueTextField.delegate = self
        fontSizeValueTextField.allowsEditingTextAttributes = true
    }
    
    func displayColorValuesArray(key: String, colorValue: ColorValue) {
        DispatchQueue.global(qos: .background).async {
            if let colorValuesArray = self.retrieveColorValuesArray(forKey: key) {
                DispatchQueue.main.async {
                    switch colorValue {
                    case .hue: self.hueColorButtons = colorValuesArray
                    case .saturation: self.saturationColorButtons = colorValuesArray
                    case .brightness: self.brightnessColorButtons = colorValuesArray
                    case .alphaValue: self.alphaValueColorButtons = colorValuesArray
                    }
                    
                    for i in 0...2 {
                        self.colorButtons[i].backgroundColor = UIColor(hue: self.hueColorButtons[i], saturation: self.saturationColorButtons[i], brightness: self.brightnessColorButtons[i], alpha: self.alphaValueColorButtons[i])
                    }
                }
            }
        }
    }
    
    // retrieve watermark image array
    private func retrieveColorValuesArray(forKey key: String) -> [CGFloat]? {
        if let colorData = UserDefaults.standard.array(forKey: key) as? [CGFloat] {
            return colorData
        }
        
        return nil
    }
    
    func saveColorValues(colorArray: [CGFloat], key: String) {
        UserDefaults.standard.set(colorArray, forKey: key)
    }
    
    @objc func changeColor(_ sender: UIButton) {
        
        if hueColorButtons.count == 0 {
            displayColorValuesArray(key: "hueColorButtons", colorValue: .hue)
            
            if hueColorButtons.count == 0 {
                hueColorButtons = [0.3, 0.5, 0.8]
            }
        }
        
        if saturationColorButtons.count == 0 {
            displayColorValuesArray(key: "saturationColorButtons", colorValue: .saturation)
            
            if saturationColorButtons.count == 0 {
                saturationColorButtons = [1.0, 0.5, 0.8]
            }
        }
        
        if brightnessColorButtons.count == 0 {
            displayColorValuesArray(key: "brightnessColorButtons", colorValue: .brightness)
            
            if brightnessColorButtons.count == 0 {
                brightnessColorButtons = [1.0, 1.0, 1.0]
            }
        }
        
        if alphaValueColorButtons.count == 0 {
            displayColorValuesArray(key: "alphaValueColorButtons", colorValue: .alphaValue)
            
            if alphaValueColorButtons.count == 0 {
                alphaValueColorButtons = [1.0, 1.0, 1.0]
            }
        }
        
        for i in 0...2 {
            if colorButtons[i] == sender {
                colorButtons[i].layer.borderWidth = 5
                
                hue = hueColorButtons[i]
                hueValueLabel.text = (String(format: "%.3f", hue))
                hueSlider.value = Float(hue)
                
                saturation = saturationColorButtons[i]
                saturationValueLabel.text = (String(format: "%.3f", saturation))
                saturationSlider.value = Float(saturation)
                
                brightness = brightnessColorButtons[i]
                brightnessValueLabel.text = (String(format: "%.3f", brightness))
                brightnessSlider.value = Float(brightness)
                
                alphaValue = alphaValueColorButtons[i]
                alphaValueValueLabel.text = (String(format: "%.3f", alphaValue))
                alphaValueSlider.value = Float(alphaValue)
                
            } else {
                colorButtons[i].layer.borderWidth = 0
            }
        }
        
        oldColorButton.layer.borderWidth = 0
        
        self.delegate?.onApplyTextChanges()
    }
    
    @objc func setOldColor(_ sender: UIButton) {
        for i in 0...2 {
            colorButtons[i].layer.borderWidth = 0
        }
        
        oldColorButton.layer.borderWidth = 5

        hue = oldHue
        hueValueLabel.text = (String(format: "%.3f", hue))
        hueSlider.value = Float(hue)
        
        saturation = oldSaturation
        saturationValueLabel.text = (String(format: "%.3f", saturation))
        saturationSlider.value = Float(saturation)

        brightness = oldBrightness
        brightnessValueLabel.text = (String(format: "%.3f", brightness))
        brightnessSlider.value = Float(brightness)
        
        alphaValue = oldAlphaValue
        alphaValueValueLabel.text = (String(format: "%.3f", alphaValue))
        alphaValueSlider.value = Float(alphaValue)
        
        self.delegate?.onApplyTextChanges()
    }
    
    @objc func onApplyTextChanges() {
        displayColorValuesArray(key: "hueColorButtons", colorValue: .hue)
        
        if hueColorButtons.count == 0 {
            hueColorButtons = [0.3, 0.5, 0.8]
        }
        
        displayColorValuesArray(key: "saturationColorButtons", colorValue: .saturation)
        
        if saturationColorButtons.count == 0 {
            saturationColorButtons = [1.0, 0.5, 0.8]
        }
        
        displayColorValuesArray(key: "brightnessColorButtons", colorValue: .brightness)
        
        if brightnessColorButtons.count == 0 {
            brightnessColorButtons = [1.0, 1.0, 1.0]
        }
        
        displayColorValuesArray(key: "alphaValueColorButtons", colorValue: .alphaValue)
        
        if alphaValueColorButtons.count == 0 {
            alphaValueColorButtons = [1.0, 1.0, 1.0]
        }
        
        if let fontSizeString = fontSizeValueTextField.text {
            fontSize = CGFloat((fontSizeString as NSString).doubleValue)
            if fontSize < 12 {
                fontSize = 12
                fontSizeValueTextField.text = "12"
            }
        }
        
        fontSizeValueTextField.text = (String(Int(fontSize)))
        hue = CGFloat(hueSlider.value)
        hueValueLabel.text = (String(format: "%.3f", hue))
        saturation = CGFloat(saturationSlider.value)
        saturationValueLabel.text = (String(format: "%.3f", saturation))
        brightness = CGFloat(brightnessSlider.value)
        brightnessValueLabel.text = (String(format: "%.3f", brightness))
        alphaValue = CGFloat(alphaValueSlider.value)
        alphaValueValueLabel.text = (String(format: "%.3f", alphaValue))
        
        for i in 0...2 {
            if colorButtons[i].layer.borderWidth == 5 {
                hueColorButtons[i] = hue
                saturationColorButtons[i] = saturation
                brightnessColorButtons[i] = brightness
                alphaValueColorButtons[i] = alphaValue
                colorButtons[i].backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alphaValue)
            }
        }
        
        oldColorButton.layer.borderWidth = 0
        
        // save color values to user defaults
        saveColorValues(colorArray: hueColorButtons, key: "hueColorButtons")
        saveColorValues(colorArray: saturationColorButtons, key: "saturationColorButtons")
        saveColorValues(colorArray: brightnessColorButtons, key: "brightnessColorButtons")
        saveColorValues(colorArray: alphaValueColorButtons, key: "alphaValueColorButtons")
    
        // set changes to text view without dismising edit text view
        self.delegate?.onApplyTextChanges()
        // change values without moving edit text view
        self.delegate?.fixEditTextView()
    }
    
    @objc func onApplyTextViewChanges() {
        // set changes to text view and dismisses edit text view
        self.delegate?.onApplyTextViewChanges()
    }
    
    // from UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = fontArray[row]
        return row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFont = fontArray[row]
        self.delegate?.onApplyTextChanges()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: fontArray[row], attributes: [NSAttributedString.Key.foregroundColor : textColor])
        
        return attributedString
    }
    
    // from UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSetAllowed = CharacterSet.decimalDigits
        
        if let _ = string.rangeOfCharacter(from: characterSetAllowed) {
            return true
            
        } else {
            return false
        }
    }
}

enum ColorValue: String {
    case hue
    case saturation
    case brightness
    case alphaValue
}
