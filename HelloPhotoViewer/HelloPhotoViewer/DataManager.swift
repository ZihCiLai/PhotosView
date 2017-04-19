//
//  DataManager.swift
//  HelloPhotoViewer
//
//  Created by Lai Zih Ci on 2016/12/21.
//  Copyright © 2016年 ZihCi. All rights reserved.
//

import Foundation
import UIKit
// Singleton
class DataManager {
    
    static let shared = DataManager()
    
    private var photos = [String]()
    
    private let documentsURL:URL
    
    private init() {
        documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Documents: \(documentsURL.path)")
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
            photos += files
            
            
            //Workaround to remove ".DS_Stror" file.
            if let targerIndex = photos.index(of: ".DS_Store") {
                print("Delete .DS_Store")
                photos.remove(at: targerIndex)
            }
            print("Total \(photos.count) files.")
        } catch {
            print("FileManager Error: \(error.localizedDescription)")
        }
        if photos.count < 2 {
            guard let image = UIImage(named: "cat3.jpg") else { return }
            
            if let dataToSave = UIImagePNGRepresentation(image){
                let fileUrl = documentsURL.appendingPathComponent("cat3.jpg")
                
                print("fileURL", fileUrl)
                do{
                    try dataToSave.write(to: fileUrl)
                }catch{
                    print("Can not save Image")
                }
            }
        }
    }
    
    var totalCount:Int {
        return photos.count
    }
    
    
    /// Get Filename of Photos by index.
    ///
    /// - Parameter at: Target index of photos
    /// - Returns: Filename in String format.
    func getFileName(at: Int) -> String? {
        
        guard at >= 0 && at < photos.count else {
            return nil
        }
        return photos[at]
    }
    
    func getImage(at:Int) -> UIImage? {
        guard let fileName = getFileName(at: at) else {
            return nil
        }
        let finalFilePathName = documentsURL.path + "/" + fileName
        return UIImage(contentsOfFile: finalFilePathName)
    }
}
