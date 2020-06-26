//
//  GameViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 10/11/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Combine

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    var entities: [GeometryEntity] = []
    
    var selectedEntity: GeometryEntity?
    
    var orientationAnchorEntity: AnchorEntity!
    
    var animation: Cancellable!
    
    var currentAnimationSelectedEntity: AnimationPlaybackController!
    
    var currentAnimationOrientationAnchor: AnimationPlaybackController!
    
    var isRunningAnimation: Bool! = false
    
    var configuration: ARWorldTrackingConfiguration!
    
    var game: Game!
    
    var generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    var matchFormSound: AVAudioPlayer!
    
    lazy var cameraAnchor: AnchorEntity! = {
        var anchor = AnchorEntity(.camera)
        anchor.name = "cameraAnchor"
        
        return anchor
    }()
    
    // MARK: Gesture Recognizers
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        return recognizer
    }()
    
    // MARK: UI Views
    
    var arView: ARView!
    
    var coachingView: ARCoachingOverlayView!
    
    var timerView: TimerView!
    
    var pointsView: PointsView!
    
    var placeBoardView: PlaceBoardView!
    
    var startGameView: StartGameView!
    
    var endGameView: EndGameView!
    
    var countDownView: CountDownView!
    
    var buttonUp: ArrowButtonView!
    
    var buttonDown: ArrowButtonView!
    
    var buttonRight: ArrowButtonView!
    
    var buttonLeft: ArrowButtonView!
    
    // MARK:- Life Cicle
    
    override func loadView() {
        let view = ARView(frame: UIScreen.main.bounds)
        
        self.view = view
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = self.view as? ARView
        
        arView.session.delegate = self
        
        arView.scene.addAnchor(cameraAnchor)
        
        arView.addGestureRecognizer(tapRecognizer)
        
        game = Game.shared
        
        setUpConfigurations()
        createBoard()
        setUpButtons()
        setUpTimerView()
        setUpPointsView()
        setUpPlaceBoardView()
        setUpCountDownView()
        setUpStartGameView()
        setUpEndGameView()
        setUpSubscription()
        setUpMatchFormSound()
    }
    
    // MARK:- Set ups
    
    func setUpConfigurations() {
        configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showPhysics]
        arView.session.run(configuration)
    }
    
    func createBoard() {
        game.createBoard(viewController: self, view: arView)
    }
    
    func setUpButtons() {
        buttonUp = ArrowButtonView(type: .up)
        view.addSubview(buttonUp)
        buttonUp.setUpConstraints()
        buttonUp.addTarget(self, action: #selector(buttonUpClicked), for: .touchDown)
        buttonUp.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        buttonDown = ArrowButtonView(type: .down)
        view.addSubview(buttonDown)
        buttonDown.setUpConstraints()
        buttonDown.addTarget(self, action: #selector(buttonDownClicked), for: .touchDown)
        buttonDown.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        buttonRight = ArrowButtonView(type: .right)
        view.addSubview(buttonRight)
        buttonRight.setUpConstraints()
        buttonRight.addTarget(self, action: #selector(buttonRightClicked), for: .touchDown)
        buttonRight.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        buttonLeft = ArrowButtonView(type: .left)
        view.addSubview(buttonLeft)
        buttonLeft.setUpConstraints()
        buttonLeft.addTarget(self, action: #selector(buttonLeftClicked), for: .touchDown)
        buttonLeft.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
    }
    
    func setUpTimerView() {
        timerView = TimerView(frame: .zero, duration: game.duration)
        view.addSubview(timerView)
        
        timerView.setUpConstraints()
    }
    
    func setUpPointsView() {
        pointsView = PointsView(frame: .zero)
        view.addSubview(pointsView)
        
        pointsView.setUpConstraints()
    }
    
    func setUpEndGameView() {
        endGameView = EndGameView(frame: .zero)
        view.addSubview(endGameView)
        
        endGameView.setUpConstraints()
        
        endGameView.playButton.addTarget(self, action: #selector(playAgain), for: .touchDown)
        endGameView.homeButton.addTarget(self, action: #selector(goHome), for: .touchDown)
    }
    
    func setUpStartGameView() {
        startGameView = StartGameView(frame: .zero)
        view.addSubview(startGameView)
        
        startGameView.setUpConstraints()
        
        startGameView.playButton.addTarget(self, action: #selector(start), for: .touchDown)
        startGameView.homeButton.addTarget(self, action: #selector(goHome), for: .touchDown)
    }
    
    func setUpPlaceBoardView() {
        placeBoardView = PlaceBoardView(frame: .zero)
        view.addSubview(placeBoardView)
        
        placeBoardView.setUpConstraints()
        
        placeBoardView.placeButton.addTarget(self, action: #selector(place), for: .touchDown)
        placeBoardView.homeButton.addTarget(self, action: #selector(goHome), for: .touchDown)
    }
    
    func setUpCountDownView() {
        countDownView = CountDownView()
        view.addSubview(countDownView)
        
        countDownView.setUpConstraints()
        
        countDownView.delegate = self
    }
    
    func setUpSubscription() {
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackTerminated.self) { (event) in
            guard let movingEntity = event.playbackController.entity as? GeometryEntity else { return }
            
            for entity in self.entities {
                for match in self.game.mapMatches[movingEntity.type]! {
                    if entity.type == match && entity != movingEntity {
                        if self.game.board.didCombine(movingEntity: movingEntity, staticEntity: entity) {
                            
                            self.selectedEntity = nil
                            self.hideOrientationEntity()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                self.game.board.removePair(firstEntity: movingEntity, secondEntity: entity)
                                self.game.board.addNewPair()
                            }
                            
                            let points = self.game.newCombination()
                            self.pointsView.update(points)
                            
                            self.generator.notificationOccurred(.success)
                            self.matchFormSound.play()
                            
                            return
                        }
                    }
                }
            }
        }
    }
    
    func setUpMatchFormSound() {
        let soundPath = Bundle.main.path(forResource: "matchForms.mp3", ofType: nil)!
        let soundUrl = URL(fileURLWithPath: soundPath)
        
        matchFormSound = try! AVAudioPlayer(contentsOf: soundUrl)
    }
    
    func setUpOrientationEntity() {
        let oritentationEntity = OrientationEntity(size: 2 * game.board.getGeometriesSize())
        
        orientationAnchorEntity = AnchorEntity()
        orientationAnchorEntity.addChild(oritentationEntity)
    }
    
    // MARK: - Actions
    
    func resetToInitialConfiguration() {
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        resetWidgets()
    }
    
    func appearWidgets() {
        timerView.isHidden = false
        
        buttonUp.isHidden = false
        buttonDown.isHidden = false
        buttonRight.isHidden = false
        buttonLeft.isHidden = false
        
        pointsView.isHidden = false
    }
    
    func desappearWidgets() {
        timerView.isHidden = true
        
        buttonUp.isHidden = true
        buttonDown.isHidden = true
        buttonRight.isHidden = true
        buttonLeft.isHidden = true
        
        pointsView.isHidden = true
    }
    
    func resetWidgets() {
        timerView.restart()
        
        let points = game.resetPoints()
        pointsView.update(points)
    }
    
    func getSelectedEntityTransform() -> Transform? {
        guard let selectedEntity = selectedEntity else { return nil }
        
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        return Transform(matrix: transformMatrix)
    }
    
    func moveAnimation(to transform: Transform) {
        guard let selectedEntity = selectedEntity else { return }
        
        currentAnimationSelectedEntity = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: game.moveDuration)
        
        currentAnimationOrientationAnchor = orientationAnchorEntity.move(to: transform, relativeTo: cameraAnchor, duration: game.moveDuration)
        
        isRunningAnimation = true
    }
    
    func stopAnimation() {
        currentAnimationSelectedEntity?.stop()
        currentAnimationOrientationAnchor?.stop()
        
        isRunningAnimation = false
    }
    
    func showOrientationEntity() {
        guard let selectedEntity = selectedEntity else { return }
        let size = game.board.getGeometriesSize()
        var position = selectedEntity.position(relativeTo: nil)
        position.y += Float(size / 2)
        
        orientationAnchorEntity.setPosition(position, relativeTo: nil)
        arView.scene.addAnchor(orientationAnchorEntity)
    }
    
    func hideOrientationEntity() {
        orientationAnchorEntity.removeFromParent()
    }
    
    func updateOrientationEntityRotation() {
        orientationAnchorEntity?.setOrientation(cameraAnchor.orientation(relativeTo: cameraAnchor), relativeTo: cameraAnchor)
    }
    
    //MARK: - Objc actions
    
    @objc
    func buttonUpClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.y += game.moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonDownClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.y -= game.moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonLeftClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.x -= game.moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonRightClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.x += game.moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonReleased() {
        stopAnimation()
    }
    
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer) {
        print(">>>> TAP <<<<")
        let tapLocation = recognizer.location(in: arView)
        
        switch game.current {
        case .placing:
            handleTapPlacing(location: tapLocation)
        case .playing:
            handleTapPlaying(location: tapLocation)
        default:
            break
        }
    }
    
    func handleTapPlacing(location: CGPoint) {
        guard let result = arView.raycast(from: location,
                                          allowing: .existingPlaneGeometry,
                                          alignment: .horizontal).first
            else { return }
        
        let arAnchor = ARAnchor(name: "Anchor for cube", transform: result.worldTransform)
        
        arView.session.add(anchor: arAnchor)
        game.board.addPoint(to: arAnchor)
        print("Botou")
    }
    
    func handleTapPlaying(location: CGPoint) {
        let hits = arView.hitTest(location)
        
        for hit in hits {
            //            print(hit.entity)
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                showOrientationEntity()
                //                print("SELECTED ENTITY IS:::: ", selectedEntity as Any)
                return
            }
        }
        
        print("Achou nada")
    }
    
    @objc
    func place() {
        game.change(viewController: self,to: .placing)
    }
    
    @objc
    func start() {
        game.change(viewController: self,to: .counting)
    }
    
    @objc
    func playAgain() {
        game.change(viewController: self,to: .starting)
        start()
    }
    
    @objc
    func goHome() {
        game.change(viewController: self,to: .waiting)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Game actions
    
    func waitingToWaiting() {
        placeBoardView.onboarding()
    }
    
    func waitingToPlacing() {
        placeBoardView.isHidden = true
        placeBoardView.onboarding()
        setUpCoachingView()
        resetToInitialConfiguration()
        desappearWidgets()
    }
    
    func placingToWaiting() {
        placeBoardView.placeAgain()
        placeBoardView.isHidden = false
        game.board.restart()
    }
    
    func placingToStarting() {
        startGameView.isHidden = false
    }
    
    func startingToCounting() {
        game.board.clearBoard()
        startGameView.isHidden = true
        countDownView.start()
        resetWidgets()
    }
    
    func startingToWaiting() {
        desappearWidgets()
        coachingView?.removeFromSuperview()
        coachingView = nil
        startGameView.isHidden = true
        endGameView.isHidden = true
        placeBoardView.isHidden = false
        game.board.restart()
    }
    
    func countingToPlaying() {
        game.board.randomizeInitialBoard()
        setUpOrientationEntity()
        appearWidgets()
        DispatchQueue.main.async { [unowned self] in
            self.timerView.startClock() {
                self.played()
            }
        }
    }
    
    func playingToFinished() {
        desappearWidgets()
        stopAnimation()
    }
    
    func finishedToStarting() {
        coachingView?.removeFromSuperview()
        coachingView = nil
        selectedEntity = nil
        endGameView.isHidden = true
    }
    
    func finishedToWaiting() {
        desappearWidgets()
        coachingView?.removeFromSuperview()
        coachingView = nil
        startGameView.isHidden = true
        endGameView.isHidden = true
        placeBoardView.isHidden = false
        game.board.restart()
    }
}

//MARK: - Game Delegate

extension GameViewController: GameDelegate {
    func placed(area: Double) {
        if area < game.minimumArea {
            game.change(viewController: self,to: .waiting)
        } else {
            game.change(viewController: self,to: .starting)
        }
    }
    
    func counted() {
        game.change(viewController: self,to: .playing)
    }
    
    func updatedEntities(_ entities: [GeometryEntity]) {
        print("Update entities!")
        self.entities = entities
    }
    
    func updateScores(score: Int, highScore: Int) {
        endGameView.present(score: score, highScore: highScore)
    }
    
    func played() {
        game.change(viewController: self,to: .finished)
    }
}

//MARK: - AR Coaching Overlay View Delegate

extension GameViewController: ARCoachingOverlayViewDelegate {
    
    func setUpCoachingView() {
        coachingView = ARCoachingOverlayView()
        view.addSubview(coachingView)
        
        coachingView.delegate = self
        coachingView.goal = .horizontalPlane
        coachingView.session = arView.session
        coachingView.translatesAutoresizingMaskIntoConstraints = false
        coachingView.activatesAutomatically = true
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            coachingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingView.heightAnchor.constraint(equalTo: view.heightAnchor),
            coachingView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    }
}

// MARK:- AR Session Delegate

extension GameViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !isRunningAnimation {
            updateOrientationEntityRotation()
        }
    }
}
