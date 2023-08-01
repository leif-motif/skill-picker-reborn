//
//  Extensions.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    public static let csv = UTType(importedAs: "com.domain.csv")
}

extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}
