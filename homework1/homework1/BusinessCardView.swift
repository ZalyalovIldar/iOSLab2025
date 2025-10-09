//
//  BusinessCardView.swift
//  
//
//  Created by krnklvx on 10.10.2025.
//

import SwiftUI

struct BusinessCardView: View {
    var body: some View {
        GeometryReader { geo in
            let isPad = geo.size.width > 700 // проверка айпад или нет
            
            if isPad {
                HStack(spacing: 40) {
                    VStack {
                        Image("person1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .clipShape(.rect(cornerRadius: 150))
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(.primary, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 17) {
                        Text("name_text")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundStyle(.primary)
                        
                        Text("profession_text")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundStyle(.secondary)
                            Text("+(7) 927 455-14-14")
                                .italic()
                                .font(.title2)
                        }
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.secondary)
                            Text("sawosit@gmail.com")
                                .font(.title2)
                        }
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                print("Call +(7) 927 455-14-14")
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("call_button")
                                }
                                .frame(width: 520)
                                .padding()
                                .background(Color("AccentColorGreen"))
                                .foregroundStyle(.white)
                                .cornerRadius(20)
                                
                            }
                            
                            ShareLink(item: "Akhmetova Karina Rinatovna\n +(7) 927 455-14-14\n sawosit@gmail.com") {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("share_button")
                                }
                            }
                        }
                    }
                }
                .padding(20)
            } else {
                VStack {
                    VStack {
                        Image("person1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(.rect(cornerRadius: 90))
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(.primary, lineWidth: 1))
                        
                        Text("name_text")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(.primary)
                        
                        Text("profession_text")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                        .padding(5)
                    
                    VStack(alignment: .center, spacing: 5) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundStyle(.secondary)
                            Text("+(7) 927 455-14-14")
                                .italic()
                        }
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.secondary)
                            Text("sawosit@gmail.com")
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 9) {
                        Button(action: {
                            print("Call +(7) 927 455-14-14")
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("call_button")
                            }
                            .frame(width: 350)
                            .padding()
                            .background(Color("AccentColorGreen"))
                            .foregroundStyle(.white)
                            .cornerRadius(20)
                        }
                        
                        ShareLink(item: "Akhmetova Karina Rinatovna\n +(7) 927 455-14-14\n sawosit@gmail.com") {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("share_button")
                            }
                        }
                    }
                }
                .padding(5)
                Spacer()
            }
        }
    }
}

#Preview {
    BusinessCardView()
}
