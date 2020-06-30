//
//  ContentView.swift
//  ming sign
//
//  Created by magicday.a on 03.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import SwiftUI
import PencilKit
import Combine

struct ContentView: View {
    @State var isShowingSelectView = false
    @State var isShowingWatermarkView = false
    @State var isShowingMergingView = false
    
    @State var isShowingGuide = false
    @State var isShowingFileSystemImages = false
    @State var isChecked: [Bool] = ImageStorage.getIsCheckedArray()
    @State var isLibrarySelected: Bool = false
    
    @State var isImageSelected: Bool = false
    @State var selectedImageKeys: [String] = [String]()
    
    @State var opacity: [Double] = ImageStorage.getFlagOpacity()
    
    @State var watermarkKey: String = ""

    let mingImage = UIImage(named: "ming_sign.png")
    let gradient = Gradient(colors: [.blue, Color("gradient")])

    var body: some View {
        
        VStack {
            
            // show start screen
            if isShowingWatermarkView == false && isShowingMergingView == false && isShowingSelectView == false {
                if mingImage != nil {
                    Image(uiImage: mingImage!)
                        .resizable()
                        .scaledToFit()
                        .border(Color.black, width: 0)
                    
                } else {
                    Text("ming sign")
                        .font(.title)
                        .foregroundColor(.purple)
                        .border(Color.black, width: 1)
                }
                
                HStack {

                    Button(action: {
                        self.isShowingSelectView = true
                        
                    }, label: {
                        HStack {
                            Image(systemName: "signature")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .padding()
                                .foregroundColor(Color.purple)
                            
                            Text(Languages.getEntryFromJSON(section: .sign, entry: .sectionheader))
                                .font(.title)
                                .foregroundColor(Color("textcolor"))
                        }
                    })
                            
                    Spacer()
                            
                    Button(action: {
                        self.isShowingWatermarkView = true
                        
                    }, label: {
                        HStack {
                            Image(systemName: "hand.draw")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color.purple)
                            
                            Text(Languages.getEntryFromJSON(section: .create, entry: .sectionheader))
                                .font(.title)
                                .foregroundColor(Color("textcolor"))
                        }
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.isShowingGuide = true

                    }) {
                        Image(systemName: "line.horizontal.3.decrease")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .foregroundColor(Color.purple)
                    }
                    .sheet(isPresented: $isShowingGuide, content: {
                        GuideView(isPresented: self.$isShowingGuide)
                    })
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Text("© 2020 magicday.a")
                        .font(.body)
                        .foregroundColor(Color.purple)
                        .padding()
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            // select english
                            UserDefaults.standard.set("english", forKey: "language")
                            self.opacity[0] = 1.0
                            self.opacity[1] = 0.5
                          //  print("set english")

                        }, label: {
                            Text("🇬🇧")
                                .font(.system(size: 42))
                        })
                        .opacity(self.opacity[0])
                        
                        Button(action: {
                            // select deutsch
                            UserDefaults.standard.set("deutsch", forKey: "language")
                            self.opacity[1] = 1.0
                            self.opacity[0] = 0.5
                         //   print("set deutsch")

                        }, label: {
                            Text("🇩🇪")
                                .font(.system(size: 42))
                        })
                        .opacity(self.opacity[1])
                    }
                    .padding()
                }
               
            // show WatermarkView
            } else if isShowingWatermarkView == true && isShowingMergingView == false {
                VStack {
                    WatermarkViewController()
                    
                    HStack {
                        Button(action: {
                            self.isShowingWatermarkView = false
                            self.isShowingSelectView = false
                            // set new value for isChecked (if new watermark image(s) had been saved)
                            self.isChecked = ImageStorage.getIsCheckedArray()
                            
                        }) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color.purple)
                        }

                        
                        Spacer()
                        
                        Button(action: {
                            self.isShowingGuide = true

                        }) {
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color.purple)
                        }
                        .sheet(isPresented: $isShowingGuide, content: {
                            GuideView(isPresented: self.$isShowingGuide)
                        })
                    }
                    .padding()
                    .background(Color("menubackground"))
                }
                .padding()
            
               // show MergingView
            }  else if isShowingMergingView == true && isShowingWatermarkView == false {
                VStack {
                    if isLibrarySelected == false && isShowingFileSystemImages == false {
                        Spacer()
                        
                        Text(Languages.getEntryFromJSON(section: .sign, entry: .header2))
                            .font(.title)
                            .foregroundColor(Color("textcolor"))
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // action folder
                                if ImageStorage.findImagesInFileSystem().count > 0 {
                                    self.isShowingFileSystemImages = true
                                    self.isChecked = ImageStorage.getIsCheckedArray()
                                }

                            }) {
                                VStack {
                                    Image(systemName: "folder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 92, height: 92)
                                        .foregroundColor(Color.purple)
                                    
                                    if ImageStorage.findImagesInFileSystem().count > 0 {
                                        Text(Languages.getEntryFromJSON(section: .sign, entry: .header7))
                                            .font(.body)
                                            .foregroundColor(Color("textcolor"))
                                        
                                    } else {
                                        // ming sign folder is empty
                                        Text(Languages.getEntryFromJSON(section: .sign, entry: .header16))
                                            .font(.body)
                                            .foregroundColor(Color("textcolor"))
                                    }
                                }
                            }

                            Spacer()
                            
                            Button(action: {
                                // action library
                                self.isLibrarySelected = true

                            }) {
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 92, height: 92)
                                        .foregroundColor(Color.purple)
                                    
                                    Text(Languages.getEntryFromJSON(section: .sign, entry: .header8))
                                        .font(.body)
                                        .foregroundColor(Color("textcolor"))
                                }
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                    } else if isLibrarySelected == false && isShowingFileSystemImages == true {
                        if isImageSelected == false {
                            HStack {
                                Button(action: {
                                    if ImageStorage.getIsCheckedValue(isCheckedArray: self.isChecked) == true {
                                        self.isImageSelected = true
                                        let selectedKeysArray = ImageStorage.findImagesInFileSystem()
                                        self.selectedImageKeys = [String]()
                                        
                                        for i in 0..<self.isChecked.count {
                                            if self.isChecked[i] {
                                                self.selectedImageKeys.append(selectedKeysArray[i])
                                                // print("\(selectedKeysArray[i]) added to selectedImageKeys: no. \(self.selectedImageKeys.count - 1) \(self.selectedImageKeys[self.selectedImageKeys.count - 1])")
                                            }
                                        }
                                        
                                    } else {
                                        print("no image checked")
                                    }

                                }) {
                                    HStack {
                                        Image(systemName: "signature")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 42, height: 42)
                                            .foregroundColor(Color.purple)
                                            .padding()
                                        
                                        if ImageStorage.getIsCheckedValue(isCheckedArray: self.isChecked) == true {
                                            Text(Languages.getEntryFromJSON(section: .sign, entry: .header9))
                                                .font(.title)
                                                .foregroundColor(Color("textcolor"))
                                                .padding()
                                            
                                        } else {
                                            Text(Languages.getEntryFromJSON(section: .sign, entry: .header2))
                                            .font(.title)
                                            .foregroundColor(Color("textcolor"))
                                            .padding()
                                        }
                                    }
                                }
                                .background(Color("menubackground"))
                                .cornerRadius(20)
                                .padding()
                            }
                                
                            List{
                                ImageCheckRow(isChecked: self.$isChecked)
                            }
                            
                        } else {
                            MergingViewController(watermarkKey: self.$watermarkKey, isImageSelected: self.$isImageSelected, imageKeys: self.$selectedImageKeys)
                        }
                           
                    } else if isLibrarySelected == true {
                        MergingViewController(watermarkKey: self.$watermarkKey, isImageSelected: self.$isImageSelected, imageKeys: self.$selectedImageKeys)
                    }
                    
                    HStack {
                        Button(action: {
                            self.isShowingMergingView = false
                            self.isShowingSelectView = false
                            self.isLibrarySelected = false
                            self.isShowingFileSystemImages = false
                            self.isImageSelected = false
                            self.isChecked = ImageStorage.getIsCheckedArray()
                            
                        }) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color.purple)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.isShowingMergingView = false
                            self.isShowingSelectView = true
                            self.isLibrarySelected = false
                            self.isShowingFileSystemImages = false
                            self.isImageSelected = false
                            self.isChecked = ImageStorage.getIsCheckedArray()
                            
                        }) {
                            HStack {
                                Image(systemName: "scribble")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Color.purple)
                                
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .header10))
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("textcolor"))
                            }
                        }
                        
                        Spacer()
                        
                        if isLibrarySelected == false && isShowingFileSystemImages == true && isImageSelected == false {
                            Button(action: {
                                self.isLibrarySelected = true
                                self.isShowingFileSystemImages = false
                                    
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Color.purple)
                                        .padding()
                                    
                                    Text(Languages.getEntryFromJSON(section: .sign, entry: .header11))
                                        .font(.system(size: 20))
                                        .foregroundColor(Color("textcolor"))
                                        .padding()
                                }
                                .background(Color("menubackground"))
                                .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.isShowingGuide = true

                        }) {
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color.purple)
                        }
                        .sheet(isPresented: $isShowingGuide, content: {
                            GuideView(isPresented: self.$isShowingGuide)
                        })
                    }
                    .padding()
                    .background(Color("menubackground"))
                }
                .padding()
             
            // show watermark images from ming sign folder
            } else if isShowingSelectView == true && isShowingWatermarkView == false {
                VStack {
                    VStack {
                        Spacer()
                        
                        if ImageStorage.findImagesInFileSystem().count > 0 {
                            Text(Languages.getEntryFromJSON(section: .sign, entry: .header6))
                                .font(.largeTitle)
                                .foregroundColor(Color.purple)
                            
                            List {
                                ImageTapRow(isImageSelected: $isShowingMergingView, imageKey: $watermarkKey)
                            }
                            
                        } else {
                            // ming sign folder is empty
                            Text(Languages.getEntryFromJSON(section: .sign, entry: .header16))
                                .font(.body)
                                .foregroundColor(Color("textcolor"))

                            Button(action: {
                                self.isShowingWatermarkView = true

                            }, label: {
                                HStack {
                                    Image(systemName: "hand.draw")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 42, height: 42)
                                        .foregroundColor(Color.purple)
                                    
                                    Text(Languages.getEntryFromJSON(section: .create, entry: .sectionheader))
                                        .font(.title)
                                        .foregroundColor(Color("textcolor"))
                                }
                            })
                                .background(Color("menubackground"))
                                .cornerRadius(20)
                                .padding(20)

                            Spacer()
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            self.isShowingSelectView = false
                            self.isShowingFileSystemImages = false
                            
                        }) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color.purple)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.isShowingGuide = true

                        }) {
                            HStack {
                                Image(systemName: "line.horizontal.3.decrease")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                    .foregroundColor(Color.purple)
                            }
                        }
                        .sheet(isPresented: $isShowingGuide, content: {
                            GuideView(isPresented: self.$isShowingGuide)
                        })
                    }
                    .padding()
                    .background(Color("menubackground"))
                }
                .padding()                  
            }
        }
    .background(RadialGradient(gradient: gradient, center: .center, startRadius: 1, endRadius: 700))
    }
}
