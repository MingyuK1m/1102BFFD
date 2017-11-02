//
//  MainView.swift
//  busanFF
//
//  Created by D7702_10 on 2017. 11. 2..
//  Copyright © 2017년 D7702_10. All rights reserved.
//

import UIKit

class MainView: UITableViewController, XMLParserDelegate {
    
    //엔드 포인트
    let endpoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
    
    //api를 사용하기 위한 개인 키
    let apikey = "3L0t1Le0OHr%2BokuEyRQNFEet%2B%2FZU3S7%2FsccY9Xi4krQWLv83G1KflEpY3i0jYU9Ggs2dXGCKau8Y3Q9JFAunXw%3D%3D"
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var currentElement:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "부산 급식소"
        
        //한글을 안쓸경우 nsstring을 안써도 된다.
        let str = "\(endpoint)?serviceKey=\(apikey)"
        
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
                tableView.reloadData()
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
        
        print("key : \(currentElement) value: \(string)")
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
