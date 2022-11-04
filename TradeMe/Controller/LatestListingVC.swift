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
}
    
    //MARK:- Table View Methods
    extension LatestListingVC: UITableViewDelegate, UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return listViewModel.arrayList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDataCell", for: indexPath) as! ProductDataCell
            
            let obj = listViewModel.arrayList[indexPath.row]
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
            
            let obj = listViewModel.arrayList[indexPath.row]
            AppDelegate.sharedManager.showAlertWithAction(title: "", message: obj.Title + "\nProduct is tapped", controller: self)
        }
    }

