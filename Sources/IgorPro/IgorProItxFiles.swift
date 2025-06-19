//
//  FileHandling.swift
//
// we need to provide baseName early on
// for saving we need as input waveNames, data, metaData
//
// Here, we need to assemble into the Igor text String and -
// provide the fileName automatically
// Generate feedback to user "fileName saved"
// Option to read files, and compare on Chart
//

//  Created by Dan Shahar on 5/17/25.
//

import Foundation

/// Use to handle IgorPro text files
public struct IgorProItxFiles {
     
     var baseName: String?
     var textToSave: String = ""
    
     private(set) var itxFilesList: [String] = []
     private(set) var nextFileName: String = ""
     var waveNames: [String] = []
     private(set) var fileNumber: String = "000"
 
    let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
                     .appendingPathComponent("Documents")
     

    /// if exists, get last file number as nnn, and sets baseName
    /// - Parameter path: documentDirectory
    /// - Returns: File number  as String
    public mutating func getLastFileNumber(using sampleName: String) -> String? {
        var lastFileNumber: String?
        
        do {
            if let listFiles = getListOfItxFiles() {
                itxFilesList = listFiles
                print(listFiles)
            } else {
                print("Error reading directory")
                return nil
            }
            itxFilesList = itxFilesList.filter{ $0.hasPrefix(sampleName) } //
            if let tempFileName = (itxFilesList.first) { // we have a file...
                if tempFileName.components(separatedBy: "_").count > 1 {
                    baseName = tempFileName.components(separatedBy: "_")[0]
                    lastFileNumber = tempFileName.components(separatedBy: "_")[1]
                        .replacingOccurrences(of: ".itx", with: "")
                    return lastFileNumber
                }
            }
            return nil
        }
    }
    
    //MARK: - Intents

    // FIXME: put logic for various destinations
    
    /// Start here, set baseName
    /// - Parameter baseName: used to create file names: baseName_nnn.itx
    public mutating func setBaseName(_ baseName: String) {
        self.baseName = baseName
        nextFileName = makeNextFileName()
      }
    
    ///  fileName of format "baseName_nnn.itx"
   /// - Returns: next filename
    public mutating func makeNextFileName() -> String {
           if let sampleName = baseName {  //we have a baseName
               if let fileNumber = getLastFileNumber(using: sampleName) {
                   let newFileNumber: String = String(format: "%03d",(Int(fileNumber)! + 1))
                   self.fileNumber = newFileNumber
                   print("File number: \(newFileNumber)")
                   return "\(sampleName)_\(newFileNumber).itx"
               } else {
                   print("No previous file found")
                    return "\(sampleName)_001.itx"
                }
           }
           return ""
        }
 
    public mutating func saveItxToICloud(fileName: String, text: String) {
        guard let iCloudDir = iCloudURL else {
            print("iCloud not available")
            return
        }

        let fileURL = iCloudDir.appendingPathComponent(fileName)
        do {
            try FileManager.default.createDirectory(at: iCloudDir, withIntermediateDirectories: true)
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved to iCloud at \(fileURL)")
        } catch {
            print("Error saving to iCloud:", error)
        }
        itxFilesList = getListOfItxFiles() ?? ["No files found"]
        nextFileName = makeNextFileName()
        print("Next file name: \(nextFileName)")
    }
   
    public mutating func autoSaveItxToICloud( text: String) {
        guard let iCloudDir = iCloudURL else {
            print("iCloud not available")
            return
        }

        let fileURL = iCloudDir.appendingPathComponent(nextFileName)
        do {
            try FileManager.default.createDirectory(at: iCloudDir, withIntermediateDirectories: true)
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved to iCloud at \(fileURL)")
        } catch {
            print("Error saving to iCloud:", error)
        }
        itxFilesList = getListOfItxFiles() ?? ["No files found"]
        nextFileName = makeNextFileName()
        print("Next file name: \(nextFileName)")
    }
   
    public mutating func deleteFile(_ fileName: String) {
        guard let iCloudDir = iCloudURL else {
            print("iCloud not available")
            return
        }
        let fileURL = iCloudDir.appendingPathComponent(fileName)
        print(fileURL.path)
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Failed to delete file.")
            }
            itxFilesList = getListOfItxFiles() ?? ["No files found"]
            nextFileName = makeNextFileName()
        
    }
    
    public  func getListOfItxFiles() -> [String]? {
            var fileList: [String] = []
            guard let iCloudDir = iCloudURL else {
                print("iCloud not available")
                return nil
            }
           do {
               fileList = try FileManager.default.contentsOfDirectory(atPath: iCloudDir.path)
                    .sorted { $0 > $1 }
                    .filter { $0.hasSuffix(".itx") }
 
           } catch {
                print("Error reading directory: \(error)")
                return nil
            }
            return fileList
        }

         
    public func getItxFilesList() -> [String] {
            return itxFilesList
        }

    public func getBaseName() -> String? {
            return baseName
        }
}
 
