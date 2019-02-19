//
//  ViewController.swift
//  AWS S3
//
//  Created by Mustafa on 07/02/2019.
//  Copyright © 2019 Mustafa. All rights reserved.
//

import UIKit
import AWSS3

class ViewController: UIViewController {

    @IBOutlet weak var loaderLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    let s3BucketName = "ceer-app"
    let s3Key = "iosUpload.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    func uploadData(image: UIImage) {
        loaderLabel.text = "UpLoading .."
        let data = image.pngData()
        DispatchQueue.main.async {
            self.myImageView.image = UIImage(data: data!)
        }
        
        let fileName = "test.png"
        let transferManager = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()

        transferManager.uploadData(data!, bucket: s3BucketName, key: "vehicle/\(ProcessInfo.processInfo.globallyUniqueString)" + ".png", contentType: "image/png", expression: expression) { (task, err) in
            
        
                if let error = err {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self.loaderLabel.text = "ERROR"
                    }
                    
                    return
                }
            
    
            
            DispatchQueue.main.async {
                self.loaderLabel.text = "SUCCESS"
            }
                
            
            }
//        } catch {
//            print("file not saved")
//        }
    
        
    }

    
    
    @IBAction func uploadBtn(_ sender: UIButton) {
        uploadData(image: UIImage(named: "avatar")!)
    }
    
        
    @IBAction func downloadBtn(_ sender: UIButton) {
        
        
        loaderLabel.text = "DOWNLOADING .."
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            self.loaderLabel.text = "downloading .. "
        })
        }
        transferUtility.downloadData(fromBucket: self.s3BucketName, key: "ce77eeec-dd4e-4fd5-9c45-9ba17453b711.png", expression: expression) { (task, url, data, error) in
            if let error = error{
                print(error)
            }
            DispatchQueue.main.async(execute: {
                self.myImageView.image = UIImage(data: data!)!
                self.loaderLabel.text = "DOWNLOADED SUCCESSFULLY!"
            })
        }
        
        
    }
    

}

