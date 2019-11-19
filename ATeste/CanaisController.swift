//
//  CanaisController.swift
//  ATeste
//
//  Created by Robert Ferreira on 18/11/2019.
//  Copyright © 2019 Robert Ferreira. All rights reserved.
//

import UIKit

class CanaisController: UITableViewController {

    
    let defaultSession = URLSession(configuration: .default)

   
    var canalList: [Canal] = []
    var nextpage : String? = "https://ott.online.meo.pt/catalog/v7/Channels?UserAgent=IOS&$filter=substringof(%27MEO_Mobile%27,AvailableOnChannels)%20and%20IsAdult%20eq%20false&$orderby=ChannelPosition%20asc&$inlinecount=allpages"
    let programasUrl = "https://ott.online.meo.pt/Program/v7/Programs/NowAndNextLiveChannelPrograms?UserAgent=IOS"
    let imagesUrl = "http://proxycache.app.iptv.telecom.pt:8080/eemstb/ImageHandler.ashx?"
    
    var isLoading : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = true
        getCanais(nextpage, true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canalList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CanalCell", for: indexPath) as! CanaisViewCell
        
        let canal = canalList[indexPath.row]

        cell.canalImage.image = nil
        cell.canalName?.text = canal.title
        
        //get programas
        if let callletter = canal.callLetter?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            var programaTask: URLSessionDataTask?
            programaTask?.cancel()
            let urlString = programasUrl + "&$filter=CallLetter%20eq%20%27" + callletter + "%27&$orderby=StartDate%20asc"
            
            if let url = URL(string: urlString) {
        
                programaTask = defaultSession.dataTask(with: url) { data, response, error in
                    guard let dataResponse = data, error == nil else {
                             print(error?.localizedDescription ?? "Response Error")
                             return
                    }
                   do {
                       let jsonResponse = try JSONSerialization.jsonObject(with:
                                               dataResponse, options: [])
                       guard let jsonDic = jsonResponse as? [String: Any] else {
                           print("response error")
                             return
                       }
                       let programas = try? JSONSerialization.data(withJSONObject: jsonDic["value"] ?? [], options: [])
                       let programasList = try JSONDecoder().decode([Programa].self, from: programas!)

                       if(programasList.count == 0){
                           return }
                       else{
                          self.canalList.filter({$0.id == canal.id}).first?.currentProgram = programasList[0]
                          if(programasList.count > 1){
                              self.canalList.filter({$0.id == canal.id}).first?.nextProgram = programasList[1]
                          }
                        DispatchQueue.main.async() {
                            cell.currentProgram?.text = canal.currentProgram?.title
                            cell.nextProgram?.text = canal.nextProgram?.title
                        }
                        //get image
                        if let currentProgram = canal.currentProgram {
                            let titlecurrent = currentProgram.title ?? ""
                            let currentLetter = canal.callLetter ?? ""
                            let urlString = self.imagesUrl + "evTitle=" + titlecurrent + "&chCallLetter=" + currentLetter + "&profile=16_9&width=320"
                            if let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                               let url = URL(string: urlEncoded) {
                                var dataTask: URLSessionDataTask?
                                dataTask?.cancel()
                                dataTask = self.defaultSession.dataTask(with: url) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    DispatchQueue.main.async() {
                                        cell.canalImage.image = UIImage(data: data)
                                    }
                                }
                                dataTask?.resume()
                            }
                        }
                       }
                    } catch let parsingError {
                       print("Error", parsingError)
                  }
                
                }
                programaTask?.resume()

            }
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 5 == canalList.count, isLoading == false, let page = nextpage, page.isEmpty == false {
            isLoading = true
            getCanais(nextpage, false)
        }
    }
}

extension CanaisController {
   
    func getCanais(_ page: String?, _ loadMore : Bool){
        
        if let validPage = page, let url = URL(string:validPage){
            var dataTask: URLSessionDataTask?
            dataTask?.cancel()
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                print(response?.suggestedFilename ?? url.lastPathComponent)
                guard let dataResponse = data,
                           error == nil else {
                           print(error?.localizedDescription ?? "Response Error")
                           return }
                     do{
                         let jsonResponse = try JSONSerialization.jsonObject(with:
                                                dataResponse, options: [])
                        guard let jsonDic = jsonResponse as? [String: Any] else {
                            print("response error")
                              return
                        }
                        let canais = try? JSONSerialization.data(withJSONObject: jsonDic["value"] ?? [], options: [])
                        self.canalList += try JSONDecoder().decode([Canal].self, from: canais!)
                        try self.nextpage = jsonDic["odata.nextLink"] as? String
                        if loadMore {
                            if let page = self.nextpage, page.isEmpty == false {
                                self.getCanais(self.nextpage,false)
                            }
                        }

                        if(self.canalList.count == 0){
                            return }
                        else{
                            if self.canalList.count > 0 {
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    if !loadMore {
                                        self.isLoading = false
                                        
                                    }
                                }
                            }
                        }
                      } catch let parsingError {
                         print("Error", parsingError)
                    }
                }
            dataTask?.resume()
        }
    }
}


class CanaisViewCell : UITableViewCell {
    @IBOutlet weak var canalImage: UIImageView!
    @IBOutlet weak var canalName: UILabel!
    @IBOutlet weak var currentProgram: UILabel!
    @IBOutlet weak var nextProgram: UILabel!
    
}
