//
//  UIHelper.swift
//  KNU_Plate_iOS
//
//  Created by Kevin Kim on 2021/12/28.
//

import Foundation

struct UIHelper {
    
    static func getRecommendationLabelForMainScreen() -> String {
        
        let now = Date()
        let one_PM = now.dateAt(hours: 13, minutes: 0)
        let five_PM = now.dateAt(hours: 17, minutes: 0)
        
        if now >= one_PM && now <= five_PM {
           return "오늘은 이 카페 어때?"
        } else if now < one_PM {
            return "점심으로는 이거 어때?"
        } else {
            return "저녁으로는 이거 어때?"
        }
    }
    
    
    
}
