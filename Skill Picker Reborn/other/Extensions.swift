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
    var collumns: [SubSequence] { split(separator: ",", omittingEmptySubsequences: false)}
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

