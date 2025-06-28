//
//  IgorProVM.swift
//  testing
//
//  Created by Dan Shahar on 5/22/25.
//

import SwiftUI

public class IgorProVM: ObservableObject {
    public var itx = IgorProItxFiles()

    @Published public var baseName: String = (UserDefaults.standard.string(forKey: "baseName") ?? "Sample")
    @Published public var displayItxFilesList: [String] = []
    @Published public var nextFileName: String?
 
    public init() {
        nextFileName = itx.nextFileName
    }
    
    //MARK: Intents

    public func setBaseName(_ name: String) {
        itx.setBaseName(name)
        if let tempFileList  = itx.getListOfItxFiles() {
            displayItxFilesList = tempFileList.filter {$0.hasPrefix(baseName)}
            nextFileName = itx.nextFileName
        }
    }
    
    ///  saves itx file with filename sets automatically
    /// - Parameter text: itx format data
    public func autoSaveItxFile(text: String) {
        itx.autoSaveItxToICloud(fileName: nil, text: text)
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



