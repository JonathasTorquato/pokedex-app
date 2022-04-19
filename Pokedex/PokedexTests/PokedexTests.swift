//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {
    var main : MainViewModel!

    override func setUpWithError() throws {
        self.main = MainViewModel()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.main = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_int_is_invalid() throws{
        let integer : Int = 0
        XCTAssertEqual(integer.numberToSpecialNumber(), "invalid number")
    }
    func test_int_is_valid_one_zero() throws{
        let integer1 : Int = 10
        let integer2 : Int = 99
        XCTAssertEqual(integer1.numberToSpecialNumber(), "0\(integer1)")
        XCTAssertEqual(integer2.numberToSpecialNumber(), "0\(integer2)")
    }
    func test_int_is_valid_two_zeros() throws {
        let integer1 : Int = 1
        let integer2 : Int = 9
        XCTAssertEqual(integer1.numberToSpecialNumber(), "00\(integer1)")
        XCTAssertEqual(integer2.numberToSpecialNumber(), "00\(integer2)")
    }
    
    func test_int_is_valid_no_zeros() throws {
        let integer1 : Int = 100
        let integer2 : Int = 999
        XCTAssertEqual(integer1.numberToSpecialNumber(), "\(integer1)")
        XCTAssertEqual(integer2.numberToSpecialNumber(), "\(integer2)")
    }
    func test_string_capitalize_letter_valid() throws {
        let string : String = "not captalized"
        XCTAssertEqual(string.capitalizingFirstLetter(), "Not captalized")
    }
    
    

/*    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
