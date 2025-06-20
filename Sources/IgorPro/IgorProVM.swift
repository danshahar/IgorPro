//
//  IgorProVM.swift
//  testing
//
//  Created by Dan Shahar on 5/22/25.
//

import SwiftUI

public class IgorProVM: ObservableObject {
    public var itx = IgorProItxFiles()

    @Published public var baseName: String = ""
    @Published var displayItxFilesList: [String] = []
    @Published public var nextFileName: String = "Sample_000.itx"
 
    public init() {
    }
    
    //MARK: Intents

    public func setBaseName(_ name: String) {
        itx.setBaseName(name)
       // activeFileName = itx.makeNextFileName()
        if let tempFileList  = itx.getListOfItxFiles() {
            displayItxFilesList = tempFileList.filter {$0.hasPrefix(baseName)}
            nextFileName = itx.nextFileName
        }
    }
    
    public func autoSaveItxFile(text: String) {
        itx.autoSaveItxToICloud(text: text)
        displayItxFilesList = itx.getItxFilesList()
        nextFileName = itx.nextFileName
    }
    
    //MARK: - Deleting
    public func deleteAllItxFile() {
        for name in itx.getItxFilesList() {
            itx.deleteFile(name)
        }
        displayItxFilesList = itx.getItxFilesList()
        nextFileName = itx.nextFileName
    }
    public func deleteLastItxFile() {
        if let fileToDelete = getFileNameList().first {
            print("Deleting: \(fileToDelete)")
            deleteItxFile(fileToDelete)
        } else {
            print("No file to delete")
        }
    }
    
   public func deleteItxFile(_ name: String) {
        itx.deleteFile(name)
        displayItxFilesList = itx.getItxFilesList()
        nextFileName = itx.nextFileName
    }
    
    //MARK: - Getters
    
    public func getNextFileName() -> String {
        return itx.nextFileName
    }
    public func getFileNameList() -> [String] {
        return displayItxFilesList
    }

}



