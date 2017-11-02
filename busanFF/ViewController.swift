//
//  ViewController.swift
//  busanFF
//
//  Created by D7702_10 on 2017. 11. 2..
//  Copyright © 2017년 D7702_10. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    
    //엔드 포인트
    let endpoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService"

    //api를 사용하기 위한 개인 키
    let apikey = "3L0t1Le0OHr%2BokuEyRQNFEet%2B%2FZU3S7%2FsccY9Xi4krQWLv83G1KflEpY3i0jYU9Ggs2dXGCKau8Y3Q9JFAunXw%3D%3D"
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var currentElement:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //시작하는 지점을 찾는다
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //태그를 저장한다 키로 사용하기 위해서
        currentElement = elementName
        
        //아이템을 처음 만나을 때 딕셔너리를 다시만든다
        if currentElement == "item" {
            item = [:]
        }
    }
    
    //키를 이용하여 데이터를 찾아 넣는다.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        item[currentElement] = string
    }
    
    //파싱이 끝나서 배열에 집어넣는다.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            items.append(item)
        }
    }

}

