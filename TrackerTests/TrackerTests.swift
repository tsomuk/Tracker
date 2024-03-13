//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Nikita Tsomuk on 12/03/2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

        func testViewController() {
            let vc = TrackerViewController()
            assertSnapshot(matching: vc, as: .image)
        }
    }
