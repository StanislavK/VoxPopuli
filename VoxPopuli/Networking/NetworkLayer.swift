//
//  NetworkLayer.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation

protocol NetworkLayer {
    typealias FetchFioTransactionsCompletion = (Result<[Transaction]>) -> Void
    
    func fetchTransactions(completionHandler: @escaping FetchFioTransactionsCompletion)
}

class FioLayer: NetworkLayer {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter
    }()

    func fetchTransactions(completionHandler: @escaping NetworkLayer.FetchFioTransactionsCompletion) {
        // TODO: Refactor date input
        let fromDate = dateFormatter.string(from: Date().startOfMonth())
        let toDate = dateFormatter.string(from: Date().endOfMonth())
        
        let session = URLSession.shared
        let url = URL(string: "https://www.fio.cz/ib2/transparent?a=2501277007&f=\(fromDate)&t=\(toDate)")!
        session.dataTask(with: url) { (data, response, error) in
            switch (data, error) {
            case (_, let error?):
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            case (let data?, _):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(NetworkingError.unknownStatusCode))
                    }
                    return
                }
                guard statusCode == 200 else {
                    // statusCode != 200, parse error json response
                    DispatchQueue.main.async {
                        completionHandler(.failure(NetworkingError.incorrectStatusCode))
                    }
                    return
                }
                // statusCode == 200, get data
                let parser = HTMLParser()
                do {
                    
                    let transactions = try parser.parseFioData(data: data)
                    
                    DispatchQueue.main.async {
                        completionHandler(.success(transactions))
                    }
                } catch (let error) {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            case (nil, nil):
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkingError.missingData))
                }
            }
            }.resume()
    }
    
}
