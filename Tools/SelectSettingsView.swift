//
//  SelectSettingsView.swift
//  ming sign
//
//  Created by magicday.a on 19.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import SwiftUI

struct SelectSettingsView: View {
    let colors = ImageStorage.retrieveColors()
    @State private var colorAmount = ImageStorage.retrieveColor()
    
  
    var body: some View {
        VStack {
            Picker("color", selection: $colorAmount) {
                ForEach(0..<self.colors.count) {
                    Text("\(self.colors[$0])")
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            Spacer()
    
        }.onDisappear {
            UserDefaults.standard.set(self.colorAmount, forKey: "color")
        }
    }
}
