//
//  MainView.swift
//  busanFF
//
//  Created by D7702_10 on 2017. 11. 2..
//  Copyright © 2017년 D7702_10. All rights reserved.
//

import UIKit

class MainView: UITableViewController, XMLParserDelegate {
    
    //엔드 포인트 기본
    let endpoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
    
    //엔드 포인트 상세
    let dendpoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersDetailsInfo"
    
    //api를 사용하기 위한 개인 키
    let apikey = "3L0t1Le0OHr%2BokuEyRQNFEet%2B%2FZU3S7%2FsccY9Xi4krQWLv83G1KflEpY3i0jYU9Ggs2dXGCKau8Y3Q9JFAunXw%3D%3D"
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var currentElement:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "부산 무료 급식소"
        
        //파일을 만들어서 데이터를 넣을 공간을 만든다.
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("bff.plist")
        
        print(url)
        
        
        if fileManager.fileExists(atPath: (url?.path)!){
            //데이터를 읽는 기능
            items = NSArray(contentsOf: url!) as! Array
        } else {
            getList()
            
            //리스트의 정보를 잠시 담아둘 빈 공간을 생성 한다.
            let tempItems = items
            //공간을 빈공간을 생성해준다.
            items = []
            
            //상세정보를 불러오기 위해서
            for dic in tempItems {
                getDetail(idx: dic["idx"]!)
            }
            
            //데이터를 넣는 기능
            let temp = items as NSArray
            temp.write(to: url!, atomically: true)
        }
    }
    
    //리스트를 가져오는것
    func  getList(){
        
        //한글을 안쓸경우 nsstring을 안써도 된다.
        let str = "\(endpoint)?serviceKey=\(apikey)&numofRows=10"
        
        //한글이나 특수문자를 코드로 바꿔주는 코드 한글이 필요없으면 안써도 된다
        //let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: str)
        
        print(url ?? "url is error") //에러 확인
        
        //url을 테스트하여 작동이 되는 지 확인하는 동작
        //URL전환, xml파싱을 하는 코드
        
        if  let url = URL(string: str), let parser = XMLParser(contentsOf: url){
            parser.delegate = self
            
            let success = parser.parse()
            if success {
                print("parse sucess!")
              //  print(items)
            } else {
                print("parse failure!")
            }
        }
    }
    
    func getDetail(idx:String){
        
        //한글을 안쓸경우 nsstring을 안써도 된다.
        let str = "\(dendpoint)?serviceKey=\(apikey)&idx=\(idx)"
        
        //한글이나 특수문자를 코드로 바꿔주는 코드 한글이 필요없으면 안써도 된다
        //let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: str)
        
        print(url ?? "url is error") //에러 확인
        
        //url을 테스트하여 작동이 되는 지 확인하는 동작
        //URL전환, xml파싱을 하는 코드
        
        if  let url = URL(string: str), let parser = XMLParser(contentsOf: url){
            parser.delegate = self
            
            let success = parser.parse()
            if success {
                print("parse sucess!")
                print(items)
            } else {
                print("parse failure!")
            }
        }

    }
    
    //시작하는 지점을 찾는다
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //태그를 저장한다 키로 사용하기 위해서 //api가 이상할경우 trim을 사용하고 . whitespaces를 사용한다
        currentElement = elementName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //아이템을 처음 만나을 때 딕셔너리를 다시만든다
        if currentElement == "item" {
            item = [:]
        }
    }
    
    //키를 이용하여 데이터를 찾아 넣는다.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //api가 이상할경우 trim을 사용하고 . whitespaces를 사용한다
        //api가 이상할 경우 2번 호출이 된다. 그럴 경우 nil을 사용하여 비교한다
        
        if item[currentElement] == nil {
            item[currentElement] = string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        //print("key : \(currentElement) value: \(string)")
    }
    
    //파싱이 끝나서 배열에 집어넣는다.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            items.append(item)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let dic = items[indexPath.row]
        
        cell.textLabel?.text = dic["name"]
        cell.detailTextLabel?.text = dic["mealDay"]

        return cell
    }
}
