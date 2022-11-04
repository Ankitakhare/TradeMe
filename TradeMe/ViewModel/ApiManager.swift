//
//  ApiManager.swift
//  TradeMe
//
//  Created by ankita khare on 04/11/22.
//

import Foundation

enum APIError: LocalizedError {

    case responseInvalid
    case authorisationError(String)
    
    var errorDescription: String? {
        switch self {
        case .responseInvalid: return "The server response was invalid."
        case .authorisationError(let error): return "Failed Authorisation with service error: \(error)"
        }
    }
}

protocol ApiManagerProtocol {
    func apiToGetQuestionData(completion : @escaping ([LatestListingModel]?, Error?) -> ())
}

class ApiManager: ApiManagerProtocol {
    
    func apiToGetQuestionData(completion : @escaping ([LatestListingModel]?, Error?) -> ()) {
        
        let Url = String(format: "https://api.tmsandbox.co.nz/v1/listings/latest.json")
        guard let serviceUrl = URL(string: Url) else { return }
        var urlRequest = URLRequest(url: serviceUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(basicAuthHeader, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response {
                completion(nil, APIError.responseInvalid)
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                                        
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                    let data = dictionary?["List"] as? [[String:Any]] ?? [[:]]
                    
                    var arrayList = [LatestListingModel]()
                    for obj in data{
                        arrayList.append(LatestListingModel(dict: obj))
                    }

                    completion(arrayList, nil)
                    
                } catch {
                    completion(nil, APIError.responseInvalid)
                }
            }
        }.resume()
    }
    
    // Set the security header
    private var basicAuthHeader: String {
        return "OAuth oauth_consumer_key=A1AC63F0332A131A78FAC304D007E7D1,oauth_signature_method=PLAINTEXT,oauth_timestamp=1667470157,oauth_nonce=flNPPxiOaIh,oauth_version=1.0,oauth_signature=EC7F18B17A062962C6930A8AE88B16C7%26"
    }
}
