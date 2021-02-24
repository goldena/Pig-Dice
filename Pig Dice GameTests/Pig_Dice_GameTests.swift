//
//  Pig_Dice_GameTests.swift
//  Pig Dice GameTests
//
//  Created by Denis Goloborodko on 18.02.21.
//

import XCTest
@testable import Pig_Dice_Game

class Player_Class_Tests: XCTestCase {
    
    // MARK: - Test(s) Lifecycle
    
    var sut: Player!
    
    override func setUp() {
        super.setUp()
        
        sut = Player(name: "TestPlayer", isAI: false)
        sut.rollDice()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Test(s)
    
    func testDiceAreRolledForTheFirstThrow() {
        XCTAssertNil(sut.previousDice, "Previous dice is not nil after the first throw of the round")
        
        XCTAssertNotNil(sut.dice1, "Dice 1 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice1!, 1, "Dice 1 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice1!, 6, "Dice 1 is greater than 6")
        
        XCTAssertNotNil(sut.dice2, "Dice 2 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice2!, 1, "Dice 2 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice2!, 6, "Dice 2 is greater than 6")
    }
    
    func testDiceAreRolledForTheNextThrows() {
        sut.rollDice()
        
        XCTAssertNotNil(sut.previousDice, "Previous dice is nil after the second throw of the round")
        
        XCTAssertNotNil(sut.dice1, "Dice 1 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice1!, 1, "Dice 1 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice1!, 6, "Dice 1 is greater than 6")
        
        XCTAssertNotNil(sut.dice2, "Dice 2 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice2!, 1, "Dice 2 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice2!, 6, "Dice 2 is greater than 6")
    }
    
    func testPlayersStateIsClearedAfterRound() {
        sut.clearStateAfterRound()

        XCTAssertNil(sut.dice1, "Dice 1 is not nil after clearing player's state")
        XCTAssertNil(sut.dice2, "Previous dice is not nil after clearing player's state")
        XCTAssertNil(sut.previousDice, "Previous dice is not nil after clearing player's state")
        
        XCTAssertEqual(sut.roundScore, 0, "Round score is not nil after clearing player's state")
        XCTAssertEqual(sut.totalScore, 0, "Total score is not nil after clearing player's state without holding any scores")
    }
    
    func testPlayersScoresFlow() {
        sut.addRoundScore(sut.dice1! + sut.dice2!)
        sut.holdRoundScore()
        
        XCTAssertGreaterThan(sut.totalScore, 0, "Total score is 0 after holding round score")
        XCTAssertEqual(sut.roundScore, 0, "Round score is not 0 after holding round score")
    }
}


class Pig_1Dice_GameTests: XCTestCase {

    // MARK: - Test(s) Lifecycle
    
    var sut: Game!
    
    override func setUp() {
        super.setUp()
        
        Options.gameType = .PigGame1Dice
        sut = Game()
        // sut.initNewGame()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Test(s)
    
    func testActivePlayerInitialState() throws {
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round score is not zero at game init")
        XCTAssertEqual(sut.activePlayer.totalScore, 0, "Total score is not zero at game init")
    }
    
    func testDiceAreBeingThrown() throws {
        sut.activePlayer.rollDice()
        
        XCTAssertNil(sut.activePlayer.previousDice, "Previous dice not nil, while it should be")
        XCTAssertNotNil(sut.activePlayer.dice1, "Dice one is nil while it should not be.")
        XCTAssertNotNil(sut.activePlayer.dice1, "Dice one is nil while it should not be.")
    }
        
    func testCalculateScoreOneDice1() throws {
//        sut.activePlayer.addRoundScore(1)
//        sut.calculateScores(1)
//        sut.activePlayer.holdRoundScore()
        
        XCTAssertEqual(sut.activePlayer.previousDice, 0, "Previous dice is not zero after 1 is thrown")
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round score is not 0 after 1 is thrown")
        XCTAssertEqual(sut.activePlayer.totalScore, 0, "Round score is not 0 after 1 is thrown")
    }
    
    func testCalculateScoreOneDice5() throws {
//        sut.activePlayer.addRoundScore(5)
//        sut.calculateScores(5)
//        sut.activePlayer.holdRoundScore()
        
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round score is not 0 after 1 is thrown")
        XCTAssertEqual(sut.activePlayer.totalScore, 0, "Round score is not 0 after 1 is thrown")
    }
    
    
    // 2 is thrown - the current score should be 2
    func testCalculateScoreOneDice2() throws {
//        sut.activePlayer.dice1 = 2
//        sut.calculateScores(2)
//        sut.activePlayer.holdRoundScore()
        
        XCTAssertEqual(sut.activePlayer.roundScore, 2)
        XCTAssertEqual(sut.activePlayer.totalScore, 2)
    }

    func testCalculateScoreOneDice6() throws {
//        sut.activePlayer.dice1 = 6
//        sut.calculateScores(6)
//        sut.activePlayer.holdRoundScore()
        
//        sut.activePlayer.dice1 = 2
//        sut.calculateScores(2)
//        sut.activePlayer.holdRoundScore()

        XCTAssertEqual(sut.activePlayer.roundScore, 8)
        XCTAssertEqual(sut.activePlayer.totalScore, 8)
    }
}
