//
//  GuideView.swift
//  ming sign
//
//  Created by magicday.a on 13.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import SwiftUI

struct GuideView: View {
    @Binding var isPresented: Bool
    @State var isChecked: [Bool] = ImageStorage.retrieveSettings()
    
    @State var pageNumber: Int = 0
    let gradient = Gradient(colors: [.blue, Color("gradient")])

    var body: some View {
        
        VStack {
            Text(Languages.getEntryFromJSON(section: .settings, entry: .header4))
                .font(.largeTitle)
                .foregroundColor(Color.purple)
            
            Spacer()
            
            if pageNumber == 0 {
                ScrollView {
                    HStack {
                        Spacer()
                        
                        Text(Languages.getEntryFromJSON(section: .create, entry: .sectionheader))
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(Color.purple)
                    }
                    .padding()

                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .header1))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Text(Languages.getEntryFromJSON(section: .create, entry: .description1))
                            .font(.body)
                            .foregroundColor(Color("textcolor"))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .header2))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .description2))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .header3))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Text(Languages.getEntryFromJSON(section: .create, entry: .description3))
                                .font(.body)
                                .foregroundColor(Color("textcolor"))
                        }
                        
                        Spacer()
                        
                        Image("tap-gesture")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .trailing)
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .header4))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .description4))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
            } else if pageNumber == 1 {
                ScrollView {
                    HStack {
                        Spacer()
                        
                        Text(Languages.getEntryFromJSON(section: .sign, entry: .sectionheader))
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(Color.purple)
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .header1))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Text(Languages.getEntryFromJSON(section: .sign, entry: .description1))
                            .font(.body)
                            .foregroundColor(Color("textcolor"))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .header2))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .description2))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()

                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .header3))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .description3))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("scale-up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .trailing)
                            
                            Image("scale-down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .trailing)
                        }
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .header4))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Text(Languages.getEntryFromJSON(section: .sign, entry: .description4))
                            .font(.body)
                            .foregroundColor(Color("textcolor"))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("tap-gesture")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .trailing)
                            
                            Image("left-right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .trailing)
                        }
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .header5))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .description5))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
            } else if pageNumber == 2 {
                ScrollView {
                    // ming sign settings
                    HStack {
                        Spacer()
                        
                        Text(Languages.getEntryFromJSON(section: .settings, entry: .sectionheader))
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(Color.purple)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // section: create watermark
                    HStack {
                        VStack {
                            // heading: create watermark
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .create, entry: .sectionheader))
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            
                            // heading1: save your watermark
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .settings, entry: .header1))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            // description1: saving text
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .settings, entry: .description1))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            .frame(height: 80)
                            
                            HStack {
                                CheckSettingsView(isChecked: self.$isChecked, title: Languages.getEntryFromJSON(section: .settings, entry: .description4), saveNumber: 3)
                                
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            // heading2: set background
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .settings, entry: .header2))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            // description5: set background
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .settings, entry: .description5))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            .frame(height: 120)
                            
                            // picker to select background color
                            HStack {
                                SelectSettingsView()
                            }
                            .frame(height: 100)
                        }

                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    // section: sign image(s)
                    HStack {
                        VStack {
                            // heading: sign image(s)
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .sign, entry: .sectionheader))
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            // heading3: save your signed image
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .settings, entry: .header3))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            // description6: saving text
                            HStack {
                                Text(Languages.getEntryFromJSON(section: .settings, entry: .description6))
                                    .font(.body)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            .frame(height: 100)
                            
                            HStack {
                                CheckSettingsView(isChecked: self.$isChecked, title: Languages.getEntryFromJSON(section: .settings, entry: .description2), saveNumber: 1)
                                
                                Spacer()

                                CheckSettingsView(isChecked: self.$isChecked, title: Languages.getEntryFromJSON(section: .settings, entry: .description3), saveNumber: 2)
                            }
                            
                            HStack {
                                CheckSettingsView(isChecked: self.$isChecked, title: Languages.getEntryFromJSON(section: .settings, entry: .description4), saveNumber: 0)
                                
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                }
                
            } else if pageNumber == 3 {
                ScrollView {
                    // about ming sign
                    HStack {
                        Spacer()
                        
                        Text(Languages.getEntryFromJSON(section: .about, entry: .sectionheader))
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(Color.purple)
                    }
                    .padding()
                    
                    HStack {
                        VStack {
                            HStack {
                                Text("ming coding")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("... a glowing in the dark")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("textcolor"))
                                
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Image("coding_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 204, height: 70, alignment: .trailing)
                        }
                        .frame(width: 360, height: 120, alignment: .trailing)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("© 2020 magicday.a . barbara stegh \nweb: magicdaya.design › ming sign")
                            .font(.body)
                            .foregroundColor(Color("textcolor"))
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(Languages.getEntryFromJSON(section: .about, entry: .header1))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("textcolor"))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(Languages.getEntryFromJSON(section: .about, entry: .description1))
                            .font(.body)
                            .foregroundColor(Color("textcolor"))
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(Languages.getEntryFromJSON(section: .about, entry: .header2))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("textcolor"))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(Languages.getEntryFromJSON(section: .about, entry: .description2))
                            .font(.body)
                            .foregroundColor(Color("textcolor"))
                        
                        Spacer()
                    }
                }
                .padding()
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                        self.pageNumber = 0

                }, label: {
                    HStack {
                        Image(systemName: "hand.draw")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color.purple)
                    }
                })
                .padding()
                
                Spacer()
                
                Button(action: {
                        self.pageNumber = 1

                }, label: {
                    HStack {
                        Image(systemName: "scribble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color.purple)
                    }
                })
                .padding()
                
                Spacer()

                Button(action: {
                    self.pageNumber = 2
                    
                }, label: {
                    HStack {
                        Text(Languages.getEntryFromJSON(section: .settings, entry: .sectionheader))
                            .font(.system(size: 20))
                            .foregroundColor(Color.purple)
                    }
                })
                .padding()
                
                Spacer()
                
                Button(action: {
                        self.pageNumber = 3

                }, label: {
                    HStack {
                        Text(Languages.getEntryFromJSON(section: .about, entry: .sectionheader))
                        .font(.system(size: 20))
                        .foregroundColor(Color.purple)
                    }
                })
                .padding()
            }
        }
        .padding()
        .background(RadialGradient(gradient: gradient, center: .center, startRadius: 1, endRadius: 700))
    }
}
