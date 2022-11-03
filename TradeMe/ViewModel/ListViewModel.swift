//
//  ListViewModel.swift
//  TradeMe
//
//  Created by ankita khare on 04/11/22.
//

import Foundation

class ListViewModel {
    
    var arrayList = [LatestListingModel]()
    func apiToGetQuestionData(completion : @escaping () -> ()) {
        
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
                    
                    self.arrayList.removeAll()
                    for obj in data{
                        self.arrayList.append(LatestListingModel(dict: obj))
                    }
                    
                    
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    // Set the security header
    private var basicAuthHeader: String {
        return "OAuth oauth_consumer_key=A1AC63F0332A131A78FAC304D007E7D1,oauth_signature_method=PLAINTEXT,oauth_timestamp=1667470157,oauth_nonce=flNPPxiOaIh,oauth_version=1.0,oauth_signature=EC7F18B17A062962C6930A8AE88B16C7%26"
    }

    
    
}
