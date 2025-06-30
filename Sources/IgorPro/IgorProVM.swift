//
//  IgorProVM.swift
//  testing
//
//  Created by Dan Shahar on 5/22/25.
//

import SwiftUI

public class IgorProVM: ObservableObject {
    public var itx = IgorProItxFiles()

    @Published public var baseName: String?
    @Published public var displayItxFilesList: [String] = []
    @Published public var nextFileName: String?
    @Published public var nextFileNumber: String?
    
    var textToSave: String?
 
    public init() {
        nextFileName = itx.nextFileName
    }
    
    //MARK: Intents

    public func setBaseName(_ name: String) {
        itx.setBaseName(name)
        if let tempFileList  = itx.getListOfItxFiles() {
            displayItxFilesList = tempFileList.filter {$0.hasPrefix(name)}
            nextFileName = itx.nextFileName
        }
    }
    
    ///  saves itx file with filename sets automatically
    /// - Parameter text: itx format data
    public func autoSaveItxFile(text: String) {
        itx.autoSaveItxToICloud(fileName: nil, text: text)
        displayItxFilesList = itx.getItxFilesList()
        nextFileName = itx.nextFileName
        print("autosave")
    }
    
    //MARK: - Getters
    
    public func getNextFileName() -> String? {
        if let nextName = itx.nextFileName {
            return nextName
        }
        return nil
    }
        
    public func getFileNameList() -> [String] {
        return displayItxFilesList
    }
    
    //FIXME: work properly with optional
    public func getNextFileNumber() -> String? {
        if let nextName = itx.nextFileName {
            return nextName.components(separatedBy: "_")[1]
                .replacingOccurrences(of: ".itx", with: "")
        }
        return "000"
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
            deleteItxFile(name: fileToDelete)
        } else {
            print("No file to delete")
        }
    }
    
   public func deleteItxFile(name: String) {
        itx.deleteFile(name)
        displayItxFilesList = itx.getItxFilesList()
        nextFileName = itx.nextFileName
    }

}



