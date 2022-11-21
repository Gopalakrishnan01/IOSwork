//
//  HeadlineWorker.swift
//  News
//
//  Created by zs-mac-6 on 09/11/22.
//

import Foundation
import UIKit


class HeadlineWorker{
    
   

    
    func storeImage(_ data:UIImage?,_ url: String){
        
               
        let filemanager = FileManager.default
        if let paths = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first{
            
            let pathToHeadlineImage=paths.appending(path: "HeadlineImage")
            let url=pathToHeadlineImage.absoluteURL
           
            if !filemanager.fileExists(atPath: pathToHeadlineImage.absoluteString){
                try? filemanager.createDirectory(at: pathToHeadlineImage, withIntermediateDirectories: true)
            }
            if let image=data{
                if let imageData=image.jpegData(compressionQuality: 1.0){
                    try? imageData.write(to: url)
                }
                else{
                    print("image not stored")
                }
            }
            
        }
        
    }
}
