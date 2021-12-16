//
//  Chart.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import Foundation

class Chart {
  
 static func fetchData(onSuccess: @escaping (_ testData: TestData) -> Void,
                 onFailure: @escaping (_ error: String) -> Void) {
    let path = "https://us-central1-bibliotecadecontenido.cloudfunctions.net/helloWorld"
    guard let url = URL(string: path) else {return}
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { responseData, responseBody, error in
      if error == nil {
        guard let response = responseBody as? HTTPURLResponse else {return}
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            guard let data = responseData else {return}
            let value = try decoder.decode(TestData.self, from: data)
            onSuccess(value)
          } catch {
            onFailure("Decoder error:  \(error.localizedDescription)")
          }
        } else {
          onFailure("Error: status code \(response.statusCode)")
        }
      } else {
        onFailure("Error: status code \(error!.localizedDescription)")
      }
      
    }.resume()
  }
}

