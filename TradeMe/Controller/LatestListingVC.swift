//
//  LatestListingVC.swift
//  TradeMe
//
//  Created by ankita khare on 04/11/22.
//

import UIKit

class ProductDataCell: UITableViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!{
        didSet{
            imgProduct.layer.cornerRadius = 5
            imgProduct.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class LatestListingVC: UIViewController {
    
    ////var arrayList = [LatestListingModel]()
    var listViewModel = ListViewModel()
    var lists: [LatestListingModel]?
    
    @IBOutlet weak var tableProductData: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    @IBOutlet var searchBarButtonItem: UIBarButtonItem!
    
    private lazy var dataSearchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 44.0))
        searchBar.placeholder = "Search..."
        return searchBar
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchTapped))
        let cart = UIBarButtonItem(image: UIImage(named: "cart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cartTapped))
        navigationItem.rightBarButtonItems = [cart, search]
        
        //self.callWebServieForLatestListings()
        
        listViewModel.apiToGetQuestionData { [weak self] in
            self?.lists = self?.listViewModel.arrayList
            
            DispatchQueue.main.async {
                self?.tableProductData.reloadData()
            }
        }
    }
    
    @objc func searchTapped(){
        searchBar.placeholder = "Your placeholder"
        

        AppDelegate.sharedManager.showAlertWithAction(title: "", message: "Search button tapped", controller: self)
    }
    
    @objc func cartTapped(){
        AppDelegate.sharedManager.showAlertWithAction(title: "", message: "Cart button tapped", controller: self)
    }
    
    func callWebServieForLatestListings(){
        
               let Url = String(format: "https://api.tmsandbox.co.nz/v1/listings/latest.json")
               guard let serviceUrl = URL(string: Url) else { return }
               var urlRequest = URLRequest(url: serviceUrl)
               urlRequest.httpMethod = "GET"
               urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
               urlRequest.setValue(basicAuthHeader, forHTTPHeaderField: "Authorization")

               let session = URLSession.shared
               session.dataTask(with: urlRequest) { (data, response, error) in
                   if let response = response {
                       print(response)
                   }
                   if let data = data {
                       do {
                           let json = try JSONSerialization.jsonObject(with: data, options: [])
                           print(json)
                                               
                           let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                           let data = dictionary?["List"] as? [[String:Any]] ?? [[:]]
                           
                           self.lists.removeAll()
                           for obj in data{
                               self.listViewModel.append(LatestListingModel(dict: obj))
                           }
                           
                           DispatchQueue.main.async {
                               self.tableProductData.reloadData()
                           }
                           
                       } catch {
                           print(error)
                       }
                   }
               }.resume()
           }
}

// Set the security header
private var basicAuthHeader: String {
    return "OAuth oauth_consumer_key=A1AC63F0332A131A78FAC304D007E7D1,oauth_signature_method=PLAINTEXT,oauth_timestamp=1667470157,oauth_nonce=flNPPxiOaIh,oauth_version=1.0,oauth_signature=EC7F18B17A062962C6930A8AE88B16C7%26"
}

//MARK:- Table View Methods
extension LatestListingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDataCell", for: indexPath) as! ProductDataCell
        
        let obj = self.arrayList[indexPath.row]
        cell.lblProduct.text = obj.Title
        cell.lblRegion.text = obj.Region
        
        cell.lblProduct.text = obj.Title
        
        if obj.IsClassified == true{
            cell.lblPrice.text = obj.PriceDisplay
        }else{
            if obj.BuyNowPrice != ""{
                cell.lblPrice.text = obj.BuyNowPrice
            }else{
                cell.lblPrice.text = obj.PriceDisplay
            }
        }
        
        if let url = URL(string: obj.PictureHref){
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        cell.imgProduct.image = UIImage(data: data)
                    }
                }else{
                    cell.imgProduct.image = UIImage(named: "img")
                }
            }
        }else{
            cell.imgProduct.image = UIImage(named: "img")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let obj = self.arrayList[indexPath.row]
        AppDelegate.sharedManager.showAlertWithAction(title: "", message: obj.Title + "\nProduct is tapped", controller: self)
    }
}
