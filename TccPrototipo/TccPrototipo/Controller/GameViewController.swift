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



class ARViewController: UIViewController {
    
    // MARK: - Properties
    
    var entities: [GeometryEntity] = []
    
    var selectedEntity: GeometryEntity?
    
    var orientationAnchorEntity: AnchorEntity!
    
    var animation: Cancellable!
    
    var currentAnimationSelectedEntity: AnimationPlaybackController!
    
    var currentAnimationOrientationAnchor: AnimationPlaybackController!
    
    var isRunningAnimation: Bool! = false
    
    var configuration: ARWorldTrackingConfiguration!
    
    var game: GameManager!
    
    var manager: Manager!
    
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
    
    var arGameView: ARGameView!
    
    // MARK:- Life Cicle
    
    override func viewDidLoad() {
        debugPrint(type(of:self), #function)
        super.viewDidLoad()
        
        arView = ARView(frame: UIScreen.main.bounds, cameraMode: .ar, automaticallyConfigureSession: true)

        view.addSubview(arView)

        arView.session.delegate = self
       
        arView.scene.addAnchor(cameraAnchor)
       
        arView.addGestureRecognizer(tapRecognizer)
        
        game = GameManager.shared
        game.delegate = self
        manager = game
        
        setUpConfigurations()
        createBoard()
        setUpARGameView()
        setUpSubscription()
        setUpMatchFormSound()
        setUpCoachingView()
    }
    
    // MARK:- Set ups
    
    func setUpConfigurations() {
        configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showPhysics]
        arView.session.run(configuration)
    }
    
    func createBoard() {
        game.createBoard(delegate: self, view: arView)
    }
    
    func setUpARGameView() {
        arGameView = ARGameView(frame: self.view.frame)
        arView.addSubview(arGameView)
        
        arGameView.setUpConstraints()
        
        arGameView.addButtonsAction(
            buttonUpAction: #selector(buttonUpClicked),
            buttonDownAction: #selector(buttonDownClicked),
            buttonLeftAction: #selector(buttonLeftClicked),
            buttonRightAction: #selector(buttonRightClicked),
            buttonReleasedAction: #selector(buttonReleased),
            target: self)
        
        arGameView.addCountDownViewDelegate(delegate: self)
        
        arGameView.addPlaceViewActions(placeAction: #selector(place), homeAction: #selector(goHome), target: self)
        
        arGameView.addStartViewActions(startAction: #selector(start), homeAction: #selector(goHome), target: self)
        
        arGameView.addEndViewActions(playAction: #selector(playAgain), homeAction: #selector(goHome), target: self)
    }
    
    func setUpSubscription() {
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackTerminated.self) { (event) in
            guard let movingEntity = event.playbackController.entity as? GeometryEntity else { return }
            
            for entity in self.entities {
                for match in EntityProperties.shared.mapMatches[movingEntity.type]! {
                    if entity.type == match && entity != movingEntity {
                        if self.game.board.didCombine(movingEntity: movingEntity, staticEntity: entity) {
                            
                            self.selectedEntity = nil
                            self.hideOrientationEntity()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                self.game.board.removePair(firstEntity: movingEntity, secondEntity: entity)
                                self.game.board.addNewPair()
                            }
                            
                            let points = self.game.newCombination()
                            self.arGameView.updatePoints(points)
                            
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
    
    func gameWidgetsIsHidden(_ isHidden: Bool) {
        arGameView.timerIsHidden(isHidden)
        
        arGameView.buttonsIsHidden(isHidden)
        
        arGameView.pointsIsHidden(isHidden)
    }
    
    func appearWidgets() {
        gameWidgetsIsHidden(false)
    }
    
    func desappearWidgets() {
        hideOrientationEntity()
        
        gameWidgetsIsHidden(true)
    }
    
    func resetWidgets() {
        let points = game.resetPoints()
        arGameView.updatePoints(points)
        arGameView.restartTimer()
    }
    
    func getSelectedEntityTransform() -> Transform? {
        guard let selectedEntity = selectedEntity else { return nil }
        
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        return Transform(matrix: transformMatrix)
    }
    
    func moveAnimation(to transform: Transform) {
        guard let selectedEntity = selectedEntity else { return }
        
        currentAnimationSelectedEntity = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: manager.getMoveDuration())
        
        currentAnimationOrientationAnchor = orientationAnchorEntity.move(to: transform, relativeTo: cameraAnchor, duration: manager.getMoveDuration())
        
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
        orientationAnchorEntity?.removeFromParent()
    }
    
    func updateOrientationEntityRotation() {
        orientationAnchorEntity?.setOrientation(cameraAnchor.orientation(relativeTo: cameraAnchor), relativeTo: cameraAnchor)
    }
    
    // MARK: - Objc actions
    
    @objc
    func buttonUpClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.y += manager.getMoveDistance()
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonDownClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.y -= manager.getMoveDistance()
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonLeftClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.x -= manager.getMoveDistance()
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonRightClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.x += manager.getMoveDistance()
        
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
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                showOrientationEntity()
                return
            }
        }
        
        print("Achou nada")
    }
    
    @objc
    func place() {
        game.change(to: .placing)
    }
    
    @objc
    func start() {
        game.change(to: .counting)
    }
    
    @objc
    func playAgain() {
        game.change(to: .starting)
        start()
    }
    
    @objc
    func goHome() {
        game.change(to: .waiting)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Game Delegate

extension ARViewController: GameDelegate {
    func waitingToWaiting() {
        arGameView.showPlaceBoardViewOnboarding()
    }
    
    func waitingToPlacing() {
        arGameView.hidePlaceBoardView()
        addCoachingView()
        resetToInitialConfiguration()
        desappearWidgets()
    }
    
    func placingToWaiting() {
        arGameView.showPlaceBoardViewPlaceAgain()
        game.board.restart()
    }
    
    func placingToStarting() {
        arGameView.showStartGameView()
    }
    
    func startingToCounting() {
        game.board.clearBoard()
        arGameView.hideStartGameView()
        arGameView.countDownStart()
        resetWidgets()
    }
    
    func startingToWaiting() {
        desappearWidgets()
        coachingView?.removeFromSuperview()
        arGameView.hideStartGameView()
        arGameView.hideEndGameView()
        arGameView.showPlaceBoardViewOnboarding()
        game.board.restart()
    }
    
    func countingToPlaying() {
        game.board.randomizeInitialBoard()
        setUpOrientationEntity()
        appearWidgets()
        DispatchQueue.main.async { [unowned self] in
            self.arGameView.startTimer {
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
        selectedEntity = nil
        arGameView.hideEndGameView()
    }
    
    func finishedToWaiting() {
        desappearWidgets()
        coachingView?.removeFromSuperview()
        arGameView.hideStartGameView()
        arGameView.hideEndGameView()
        arGameView.showPlaceBoardViewOnboarding()
        game.board.restart()
    }
    
    func placed(area: Double) {
        if area < game.minimumArea {
            game.change(to: .waiting)
        } else {
            game.change(to: .starting)
        }
    }
    
    func counted() {
        game.change(to: .playing)
    }
    
    func updatedEntities(_ entities: [GeometryEntity]) {
        self.entities = entities
    }
    
    func updateScores(score: Int, highScore: Int) {
        arGameView.showEndGameView(score: score, highScore: highScore)
    }
    
    func played() {
        game.change(to: .finished)
    }
}

// MARK:- Construcion Delegate

extension ARViewController: ConstructionDelegate {
    func placingToLooking() {}
    
    func lookingToAdding() {}
    
    func lookingToConstructing() {}
    
    func lookingToLeaving() {}
    
    func addingToLooking() {}
    
    func addingToClassifying() {}
    
    func constructingToLooking() {}
    
    func constructingToLeaving() {}
    
    func classifyingToConstructing() {}
    
    func classifyingToAdding() {}
    
    func leavingToWaiting() {}
    
    func leavingToLooking() {}
}

//MARK: - AR Coaching Overlay View Delegate

extension ARViewController: ARCoachingOverlayViewDelegate {
    
    func setUpCoachingView() {
        coachingView = ARCoachingOverlayView()
        
        coachingView.delegate = self
        coachingView.goal = .horizontalPlane
        coachingView.session = arView.session
        coachingView.translatesAutoresizingMaskIntoConstraints = false
        coachingView.activatesAutomatically = true
        
        
    }
    
    func addCoachingView() {
        view.addSubview(coachingView)
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
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {}
}


// MARK:- AR Session Delegate

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !isRunningAnimation {
            updateOrientationEntityRotation()
        }
    }
}
