//
//  Bird.swift
//  AutocompleteDemo
//
//  Created by Elon Rubin on 2/19/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import Foundation

class Bird {
    var fullname = String()
    var birdname = String()
    var type: String?
    
    typealias CompletionHandler = (_ didFinish: Bool) -> Void
    
    static func initalizeJSON () -> Array<Bird>   {
        let pathForJSON = Bundle.main.path(forResource: "birds", ofType: "json")
        let rawBirdJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForJSON!))
        let parsedBirdJson = try! JSONSerialization.jsonObject(with: rawBirdJSON!, options: .allowFragments) as! Array<String>

        
        let birds = parsedBirdJson.map { (BirdString) -> Bird in
      
            if BirdString.contains(" ") {
                var birdArray = BirdString.components(separatedBy: " ")
                let bird = Bird()
                bird.fullname = BirdString
                bird.birdname = birdArray[1]
                bird.type = birdArray[0]
                return bird
            } else {
                let bird = Bird()
                bird.fullname = BirdString
                bird.birdname = BirdString
                bird.type = nil
                return bird
            }
        }

        return birds
     
    }

    // To Do - Save Extracted Data into User Defaults
    
//    static func extractJSON (completion: @escaping CompletionHandler) {
//        let pathForJSON = Bundle.main.path(forResource: "birds", ofType: "json")
//        let rawBirdJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForJSON!))
//        let parsedBirdJson = try! JSONSerialization.jsonObject(with: rawBirdJSON!, options: .allowFragments) as! Array<String>
//
//        let birds = parsedBirdJson.map { (BirdString) -> Bird in
//      
//            if BirdString.contains(" ") {
//                var birdArray = BirdString.components(separatedBy: " ")
//                let bird = Bird()
//                bird.fullname = BirdString
//                bird.birdname = birdArray[1]
//                bird.type = birdArray[0]
//                return bird
//            } else {
//                let bird = Bird()
//                bird.fullname = BirdString
//                bird.birdname = BirdString
//                bird.type = nil
//                return bird
//            }
//        }
//        UserDefaults.standard.set(birds, forKey: "Datasource")
//        UserDefaults.standard.set(true, forKey: "FirstInitializationComplete")
//        
//        completion(true)
//        
//    }
}
