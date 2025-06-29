//
//  SwiftUIView.swift
//  IgorPro
//
//  Created by Dan Shahar on 6/29/25.
//

import SwiftUI

struct IgorProView: View {
    var itxVM: IgorProVM
    var itxFormatText: String? = nil
    @State private var showingAlert = false
    
    var body: some View {
        Button("iCloud") {
            if let textToSave = itxFormatText {
                itxVM.autoSaveItxFile(text: textToSave)
            } else {
                showingAlert = true
            }
        }
        .buttonStyle( BorderedButtonStyle())
        .alert(isPresented: $showingAlert)
        { Alert(title: Text("No text provided"), message: Text("Will not save"),
            dismissButton: .default(Text("Got it!"))
    )}
        
    }
}

#Preview {
    IgorProView(itxVM:  IgorProVM(), itxFormatText: "Hello, world!")
}
