//
//  AlertManager.swift
//  GPSPrivacy
//
//  Created by Jae hyung Kim on 1/24/24.
//

import UIKit

enum AlertManager {
    enum AllTheater {
        static func showActionSheet(title: String, message: String, alertAction: @escaping(String) -> ()) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let theathers = TheaterList.theaters
            
            
            for theather in theathers {
                let alertAction = UIAlertAction(title: theather, style: .default ) { action in
                    
                    print(action)
                    alertAction(theather)
                    
                }
                alert.addAction(alertAction)
            }
            
            let cancle = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(cancle)
            return alert
        }
        
    }
    
}
