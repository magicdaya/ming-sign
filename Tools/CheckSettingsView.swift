//
//  CheckSettingsView.swift
//  ming sign
//
//  Created by magicday.a on 18.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import SwiftUI

struct CheckSettingsView: View {
    @Binding var isChecked: [Bool]
    var title: String
    var saveNumber: Int
  
    var body: some View {
        VStack {
            HStack {
                Button(action: toggle) {
                    Image(systemName: isChecked[saveNumber] ? "checkmark.square" : "square")
                        .foregroundColor(Color("textcolor"))
                        .frame(width: 52, height: 52)
                }
                
                Text(title)
                    .foregroundColor(Color("textcolor"))
                    .font(.body)
            }
        }
        .onDisappear {
            UserDefaults.standard.set(self.isChecked, forKey: "settings")
//            print("saved \(self.saveNumber): \(self.isChecked[self.saveNumber]) to user defaults")
        }
    }
    
    func toggle() {
        isChecked[saveNumber] = !isChecked[saveNumber]
        
//        UserDefaults.standard.set(isChecked, forKey: "settings")
      //  print("saved \(saveNumber): \(isChecked[saveNumber]) to user defaults")
    }
}
