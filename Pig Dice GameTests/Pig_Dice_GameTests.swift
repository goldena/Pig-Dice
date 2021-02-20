//
//  Pig_Dice_GameTests.swift
//  Pig Dice GameTests
//
//  Created by Denis Goloborodko on 18.02.21.
//

import XCTest
@testable import Pig_Dice_Game

class Pig_1Dice_GameTests: XCTestCase {

    // System Under Test
    var sut: Game!
    
    override func setUp() {
        super.setUp()
        
        Options.gameType = .PigGame1Dice
        sut = Game()
        // sut.initNewGame()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Initial state after the App launch
    func testActivePlayerInitialState() throws {
        XCTAssertEqual(sut.activePlayer.roundScore, 0)
        XCTAssertEqual(sut.activePlayer.totalScore, 0)
    }
    
    // 1 is thrown - the current score should be 0, total should be 0
    func testCalculateScoreOneDice1() throws {
        sut.calculateScores(1)
        
        XCTAssertEqual(sut.activePlayer.roundScore, 0)
        XCTAssertEqual(sut.activePlayer.totalScore, 0)
    }
    
    // 2 is thrown - the current score should be 2
    func testCalculateScoreOneDice2() throws {
        sut.calculateScores(2)
        sut.activePlayer.holdRoundScore()
        
        XCTAssertEqual(sut.activePlayer.roundScore, 2)
        XCTAssertEqual(sut.activePlayer.totalScore, 2)
    }

    func testCalculateScoreOneDice6() throws {
        sut.calculateScores(6)
        sut.activePlayer.holdRoundScore()

        XCTAssertEqual(sut.activePlayer.previousDiceIs6, true)
        XCTAssertEqual(sut.activePlayer.roundScore, 6)
        XCTAssertEqual(sut.activePlayer.totalScore, 8)
    }
}
