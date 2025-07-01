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
    @Published public var displayNextFileName: String?
    @Published public var nextFileNumber: String?
    
    var textToSave: String?
 
    public init() {
        displayNextFileName = itx.nextFileName
    }
    
    //MARK: Intents

    public func setBaseName(_ name: String) {
        itx.setBaseName(name)
        if let tempFileList  = itx.getListOfItxFiles() {
            displayItxFilesList = tempFileList.filter {$0.hasPrefix(name)}
            displayNextFileName = itx.nextFileName
        }
    }
    
    ///  saves itx file with filename sets automatically
    /// - Parameter text: itx format data
    public func autoSaveItxFile(text: String) {
        itx.autoSaveItxToICloud(fileName: nil, text: text)
        displayItxFilesList = itx.itxFilesList
        displayNextFileName = itx.nextFileName
    }
    
    //MARK: - Getters
    
    public func getNextFileName() -> String? {
        if let nextName = itx.nextFileName {
            return nextName
        }
        return nil
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
        for name in itx.itxFilesList {
            itx.deleteFile(name)
        }
        displayItxFilesList = itx.itxFilesList
        displayNextFileName = itx.nextFileName
    }
    public func deleteLastItxFile() {
        if let fileToDelete = itx.itxFilesList.first {
            print("Deleting: \(fileToDelete)")
            deleteItxFile(name: fileToDelete)
        } else {
            print("No file to delete")
        }
    }
    
   public func deleteItxFile(name: String) {
        itx.deleteFile(name)
        displayItxFilesList = itx.itxFilesList
        displayNextFileName = itx.nextFileName
    }

}



