//
//  ListViewModel.swift
//  TradeMe
//
//  Created by ankita khare on 04/11/22.
//

import Foundation

class ListViewModel {
    
    let apiManager: ApiManagerProtocol
    
    init(apiManager: ApiManagerProtocol = ApiManager()) {
        self.apiManager = apiManager
    }
    
    var arrayList = [LatestListingModel]()
    
    func apiToGetQuestionData(completion : @escaping () -> ()) {
        apiManager.apiToGetQuestionData { [weak self] arrayList, error in
            if let error = error {
                print(error)
                // Add error handling
                return
            }
            guard let arrayList = arrayList else {
                return
            }
            self?.arrayList = arrayList
            completion()
        }
    }
    
}
