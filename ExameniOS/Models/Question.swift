//
//  Question.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import Foundation

struct Question: Codable {
  let total: Int
  let text: String
  let chartData: [ChartDatum]
}
