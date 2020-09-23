//
//  ContentView.swift
//  FetchExercise
//
//  Created by Ryan McKenzie on 9/23/20.
//

import SwiftUI

// Define exerciseItem struct for JSON parsing into pre-mapped objects
struct exerciseItem: Codable {
    var id: Int
    var listId: Int
    var name: String
    
    init(_ dictionary: [String: Any]) {
        // Init maps a dict of values from JSON object to exerciseItem object attributes of same name
        self.id = dictionary["id"] as? Int ?? 0
        self.listId = dictionary["listId"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
    }
}

struct ContentView: View {
    // Content view keeps state with list of items
    @State private var fetchResults = [exerciseItem]()
    
    
    var body: some View {
        Text("Hello Fetch team!")
        Text("I've set up the request with a button, just for fun")
        Button("Get Items!", action: fetchFetchData)
        
        // For each value in fetched array, create list tile with object info
        List (self.$fetchResults.wrappedValue, id: \.id) { item in
            VStack(alignment: .leading) {
                Text("Item List ID: \(String(item.listId))").padding(1)
                Text("Item Name: \(item.name)").padding(1)
                Text("Item ID: \(String(item.id))").padding(1)
            }
        }
    }
    
    
    
    
    func fetchFetchData() {
        /*
         fetchFetchData, my attempt at a fun punny function, sends a URL request to Fetch's hiring json,
         and calls a URLSession dataTask, where the completion handler of the task awaits the response,
         changing our state array after the callback, thereby displaying the requested information in the list view.
         */
        
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else {
            print("Bad URL")
            return
        }
        
        let req = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: req, completionHandler: { (data, response, error) in
            // Create URL Request with completion callback to get data from API
            if let error = error {
                print("Error fetching JSON from fetch-hiring \(error)")
                return
            }
            
        guard let httpResponse = response as? HTTPURLResponse,
              // If HTTP Status code is not within OK range, display response error
            (200...299).contains(httpResponse.statusCode) else {
            print("Response error - Status Code \(response.debugDescription)")
                return
            }
        
        guard let dataResponse = data,
              // Guard for error in case of faulty response, else parse
              error == nil else {
            print(error?.localizedDescription ?? "Response Error")
            return
        }
            do {
                // Parse JSON response object if response is not an error
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let asArr = jsonResponse as? [[String: Any]] else {
                    return
                }
                
                let itemMap = asArr.compactMap { (dictionary) in
                    // Map items to array of objects with exercise item attributes, removes nil names
                    return exerciseItem(dictionary)
                    
                }.filter { (item) -> Bool in
                    // Filter out any item for which the name is not provided
                    item.name != ""
                    
                }.sorted {first, second in
                    // Originally I had parsed the names for comparison, but since the names are just
                    //  'item' + the item's id, the ideal comparitor is just the id number
                    // If we needed to sort by name alphabetically, we would use a lexicographical comparison.
                    //let nameVal1 = Int(first.name.split(separator: " ")[1])!
                    //let nameVal2 = Int(second.name.split(separator: " ")[1])!
                    
                    // Sort first by listID, resolve equal values by item ID (stand-in for value of name)
                    return (first.listId, first.id) < (second.listId, second.id)
                }
                
                // Set filtered, sorted item map to State object to refresh with listview
                self.fetchResults = itemMap
                
                return
                
            } catch let parsingError {
                print("error", parsingError)
            }

        }).resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
