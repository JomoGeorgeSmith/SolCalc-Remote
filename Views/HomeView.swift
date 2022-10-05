//
//  ContentView.swift
//  SolCalc
//
//  Created by Jomo Smith on 1/17/22.
//

import SwiftUI

enum InstallationType: String, CaseIterable, Identifiable {
    
    case Residential, Commercial
    var id: Self { self }
}

struct HomeView: View {

    func pickView() -> AnyView{
        
        if(selectedInstallationType == InstallationType.Residential)
        {
            return AnyView( ResidentialView() )
        }
        else{
            return AnyView( CommericalView())
        }
        
    }
    
    @State private var selectedInstallationType: InstallationType = .Residential
    
    var body: some View {
        
        NavigationView {
            
            LazyVStack {
                
                
                
                VStack{
                    Image("logo2")
                        .resizable()
                        .aspectRatio( contentMode:.fill)
                        .clipped()
                        .frame(width: 100, height:100)
                }
                
                VStack{
                    
                    Text("Select Installation Type : ")
                        .font(.title3)
                        .position(x: 200, y: 80)
                    
                    Picker("Installation Type", selection: $selectedInstallationType) {
                        Text("Residential").tag(InstallationType.Residential)
                        Text("Commercial").tag(InstallationType.Commercial)
                    }.pickerStyle(WheelPickerStyle())
                    
                    //Button("Go", action: pickSolarCalculator)
                    
                    NavigationLink(destination: pickView(), label:{ Text("Go")
                    })
                    
                }
                
            }.navigationTitle("Home View").navigationBarHidden(true)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

