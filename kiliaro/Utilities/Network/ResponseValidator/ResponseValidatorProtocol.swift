//
//  ResponseValidatorProtocol.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/4/21.
//

import Foundation

protocol ResponseValidatorProtocol {
    func validation<T: Codable>(response: HTTPURLResponse?, data: Data?) -> Result<T, RequestError>
}
