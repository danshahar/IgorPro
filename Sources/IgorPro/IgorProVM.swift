//
//  IgorProVM.swift
//  testing
//
//  Created by Dan Shahar on 5/22/25.
//

import SwiftUI

public class IgorProVM: ObservableObject {
    private var itx = IgorProItxFiles()

    @Published var baseName: String = ""
    @Published var displayItxFilesList: [String] = []
    @Published var activeFileName: String = ""
    @Published var nextFileName: String = ""
 //   @Published var iCloudURL = URL(fileURLWithPath: "")
 
    public init() {
//        iCloudURL = getURLFromiCloud() ?? URL(fileURLWithPath: "no iCloud")
//        print(iCloudURL)
    }
    
    //MARK: Intents

    public func setBaseName(_ name: String) {
        itx.setBaseName(name)
        activeFileName = itx.makeNextFileName()
        if let tempFileList  = itx.getListOfItxFiles() {
            displayItxFilesList = tempFileList.filter {$0.hasPrefix(baseName)}
            nextFileName = itx.makeNextFileName()
        }
        print(itx.getActiveFileName())
    }
    
    public func deleteItxFile(_ name: String) {
        itx.deleteFile(name)
        displayItxFilesList = itx.getItxFilesList()
    }
    
    public func getSampleName() -> String {
        return itx.baseName ?? "No baseName"
    }
}



