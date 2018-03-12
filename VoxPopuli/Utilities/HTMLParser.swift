//
//  HTMLParser.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation
import HTMLReader

class HTMLParser {
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter
    }()
    
    enum HTMLSelectorTag: String {
        case table
        case tbody
        case tr
    }
    
    enum Constants {
        static let id = "id"
        static let contentTypeHeader = "text/html;charset=UTF-8"
    }
    
    enum FioHTMLParserErrors: Error {
        case tableNotFound
        case contentBodyNotFound
    }
    
    func parseFioData(data: Data) throws -> [Transaction] {
        
        let fioHTMLDocument = HTMLDocument(data: data, contentTypeHeader: Constants.contentTypeHeader)
        
        // Find the table with Fio transactions in HTML document
        let tables = fioHTMLDocument.nodes(matchingSelector: HTMLSelectorTag.table.rawValue)
        var transactionsTable: HTMLElement?
        for table in tables {
            if isTransactionsTable(tableElement: table) {
                transactionsTable = table
                break
            }
        }
        
        guard let fioTransactionsTable = transactionsTable else {
            throw FioHTMLParserErrors.tableNotFound
        }
        
        let htmlSelector: HTMLSelector = HTMLSelector(string: HTMLSelectorTag.tbody.rawValue)
        let tableBody = fioTransactionsTable.nodes(matchingParsedSelector: htmlSelector).first
        
        guard let tableBodyContent = tableBody else {
            throw FioHTMLParserErrors.contentBodyNotFound
        }
        
        // Find and parse table rows
        var transactions: [Transaction] = []
        for element in tableBodyContent.children {
            if let rowElement = (element as? HTMLElement)?.nodes(matchingParsedSelector: HTMLSelector(string: HTMLSelectorTag.tr.rawValue)).first {
                if let newTransaction = parseHTMLRow(rowElement: rowElement) {
                    transactions.append(newTransaction)
                }
            }
        }
        return transactions
    }
}

private extension HTMLParser {
    
    func isTransactionsTable(tableElement: HTMLElement) -> Bool {
        if tableElement.children.count > 0 {
            if tableElement.attributes[Constants.id] != nil  {
                return true
            }
        }
        return false
    }
    
    func getRowContent(from htmlElement: HTMLElement) -> String? {
        return htmlElement.textContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\t", with: "")
    }
    
    func getAmountAndCurrency(_ amountAndCurrencyString: String?) -> (amount: Double?, currency: String?) {
        guard let amountAndCurrencyString = amountAndCurrencyString else {
            return (nil, nil)
        }
        let amountAndCurrencyStringWithReplacedComma = String(amountAndCurrencyString.map { $0 == "," ? "." : $0 })
        let amountAndCurrencyStringComponents = amountAndCurrencyStringWithReplacedComma.components(separatedBy: " ")
        
        let currency = amountAndCurrencyStringComponents.last
        
        guard let amountString = amountAndCurrencyStringComponents.first else {
            // finding "amount" as string failed
            return (nil, currency)
        }
        
        guard let amount = Double(amountString) else {
            // conversion of "found" amount as string to Double failed
            return (nil, currency)
        }
        
        return (amount, currency)
    }
    
    // TODO: Refactor parseHTMLRow
    func parseHTMLRow(rowElement: HTMLElement)  -> Transaction? {
        // transactionDate
        guard let transactionDateElement = rowElement.child(at: 1) as? HTMLElement else {
            // can not get transactionDate element from row
            return nil
        }
        guard let transactionDateContent = getRowContent(from: transactionDateElement) else {
            // can not get transactionDate content from row
            return nil
        }
        let transactionDateContentConverted = dateFormatter.date(from: transactionDateContent)
        
        // amount as String "amount + currency" i.e. "0,01 CZK"
        guard let amountAndCurrencyElement = rowElement.child(at: 3) as? HTMLElement else {
            // can not get castkaAMena
            return nil
        }
        let amountAndCurrencyContent = getRowContent(from: amountAndCurrencyElement)
        let amountAndCurrency = getAmountAndCurrency(amountAndCurrencyContent)
        
        // type
        guard let typeElement = rowElement.child(at: 5) as? HTMLElement else {
            // can not get type element
            return nil
        }
        let typeContent = getRowContent(from: typeElement)
        
        // correspondingAccountName
        guard let correspondingAccountNameElement = rowElement.child(at: 7) as? HTMLElement else {
            // can not get correspondingAccountName element
            return nil
        }
        let correspondingAccountNameContent = getRowContent(from: correspondingAccountNameElement)
        
        // noteForBeneficiary
        guard let noteForBeneficiaryElement = rowElement.child(at: 9) as? HTMLElement else {
            // can not get noteForBeneficiary element
            return nil
        }
        let noteForBeneficiaryContent = getRowContent(from: noteForBeneficiaryElement)
        
        // constantSymbol
        guard let constantSymbolElement = rowElement.child(at: 11) as? HTMLElement else {
            // can not get constantSymbol element
            return nil
        }
        let constantSymbolContent = getRowContent(from: constantSymbolElement)
        
        // variableSymbol
        guard let variableSymbolElement = rowElement.child(at: 13) as? HTMLElement else {
            // can not get variableSymbol element
            return nil
        }
        let variableSymbolContent = getRowContent(from: variableSymbolElement)
        
        // specificSymbol
        guard let specificSymbolElement = rowElement.child(at: 15) as? HTMLElement else {
            // can not get specificSymbol element
            return nil
        }
        let specificSymbolContent = getRowContent(from: specificSymbolElement)
        
        // note
        guard let noteElement = rowElement.child(at: 17) as? HTMLElement else {
            // can not get note element
            return nil
        }
        let noteContent = getRowContent(from: noteElement)
        
        guard
            let transactionDate = transactionDateContentConverted,
            let amount = amountAndCurrency.amount,
            let currency = amountAndCurrency.currency,
            let type = typeContent,
            let correspondingAccountName = correspondingAccountNameContent,
            let noteForBeneficiary = noteForBeneficiaryContent,
            let constantSymbol = constantSymbolContent,
            let variableSymbol = variableSymbolContent,
            let specificSymbol = specificSymbolContent,
            let note = noteContent
            else {
                // Something went wrong
                return nil
        }
        
        return Transaction(transactionDate: transactionDate,
                           amount: amount,
                           currency: currency,
                           type: type,
                           correspondingAccountName: correspondingAccountName,
                           noteForBeneficiary: noteForBeneficiary,
                           constantSymbol: constantSymbol,
                           variableSymbol: variableSymbol,
                           specificSymbol: specificSymbol,
                           note: note)
    }
}
