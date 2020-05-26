//
//  ChecklistItem.swift
//  Stop Watch Nurtilek
//
//  Created by Nurtilek Nurbekov on 4/5/20.
//  Copyright © 2020 neobis. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    var text: String?
    var checked: Bool?
    
    func toggleChecked() {
        checked = !checked!
    }
    
    init(text: String = "", extraText: String = "", checked: Bool = false) {
        self.text = text
        self.checked = checked
    }
    
    init(json: [String: Any]) {
        self.text = json["text"] as? String
        self.checked = json["checked"] as? Bool
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.text, forKey: "text")
        coder.encode(checked, forKey: "checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObject(forKey: "text") as? String
        self.checked = aDecoder.decodeObject(forKey: "checked") as? Bool
    }
}


