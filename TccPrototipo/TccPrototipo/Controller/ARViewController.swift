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
    
    enum Action {
        case game
        case sandbox
    }
    
    var action: Action!
    
    var entities: [GeometryEntity] = []
    
    var selectedEntity: GeometryEntity?
    
    var orientationAnchorEntity: AnchorEntity!
    
    var animation: Cancellable!
    
    var currentAnimationSelectedEntity: AnimationPlaybackController!
    
    var currentAnimationOrientationAnchor: AnimationPlaybackController!
    
    var isRunningAnimation: Bool! = false
    
    var configuration: ARWorldTrackingConfiguration!
    
    var manager: Manager!
    
    var board: Board!
    
    var gameManager: GameManager? {
        didSet {
            guard let gameManager = gameManager else { return }
            manager = gameManager
            constructionManager = nil
            board = gameManager.board
        }
    }
    
    var constructionManager: ConstructionManager? {
        didSet {
            guard let constructionManager = constructionManager else { return }
            manager = constructionManager
            gameManager = nil
            board = constructionManager.board
        }
    }
    
    var construction: Construction?
        
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
    
    var arConstructionView: ARConstructionView!
    
    // MARK:- Life Cicle
    
    override func viewWillAppear(_ animated: Bool) {
        setUpActionsMode()
    }
    
    override func viewDidLoad() {
        debugPrint(type(of:self), #function)
        super.viewDidLoad()
        
        arView = ARView(frame: UIScreen.main.bounds, cameraMode: .ar, automaticallyConfigureSession: true)

        view.addSubview(arView)

        arView.session.delegate = self
       
        arView.scene.addAnchor(cameraAnchor)
       
        arView.addGestureRecognizer(tapRecognizer)

        setUpConfigurations()
        setUpARGameView()
        setUpARConstructionView()
        setUpSubscription()
        setUpMatchFormSound()
        setUpCoachingView()
    }
    
    // MARK:- Set ups
    
    func setUpActionsMode() {
        createBoard()
        
        switch action {
        case .game:
            gameManager = GameManager.shared
            gameManager!.delegate = self
            arGameView.isHidden = false
            arConstructionView.isHidden = true
        case .sandbox:
            guard let _ = construction else { fatalError("Didn't find any construction!") }
            constructionManager = ConstructionManager.shared
            constructionManager!.delegate = self
            arConstructionView.isHidden = false
            arGameView.isHidden = true
        case .none:
            fatalError("Didn't find any action!")
        }
    }
    
    func setUpConfigurations() {
        configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showPhysics]
        arView.session.run(configuration)
    }
    
    func createBoard() {
        GameManager.shared.createBoard(delegate: self, view: arView)
        ConstructionManager.shared.createBoard(delegate: self, view: arView)
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
    
    func setUpARConstructionView() {
        arConstructionView = ARConstructionView(frame: self.view.frame)
        arView.addSubview(arConstructionView)
        
        arConstructionView.setUpConstraints()
    }
    
    func setUpSubscription() {
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackTerminated.self) { (event) in
            guard let movingEntity = event.playbackController.entity as? GeometryEntity else { return }
            
            for entity in self.entities {
                for match in EntityProperties.shared.mapMatches[movingEntity.type]! {
                    if entity.type == match && entity != movingEntity {
                        if self.board.didCombine(movingEntity: movingEntity, staticEntity: entity) {
                            
                            self.selectedEntity = nil
                            self.hideOrientationEntity()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                self.gameManager?.board.removePair(firstEntity: movingEntity, secondEntity: entity)
                                self.gameManager?.board.addNewPair()
                            }
                            
                            self.changeGamePoints(self.gameManager?.newCombination())
                            
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
        var oritentationEntity: OrientationEntity!
        if let size = gameManager?.board.getGeometriesSize() {
            oritentationEntity = OrientationEntity(size: 2 * size)
        }
        
        if let size = constructionManager?.board.getGeometriesSize() {
            oritentationEntity = OrientationEntity(size: 2 * size)
        }
        
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
        changeGamePoints(gameManager?.resetPoints())
        arGameView.restartTimer()
    }
    
    func changeGamePoints(_ points: Int?) {
        guard let points = points else { return }
        arGameView.updatePoints(points)
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
        let size = board.getGeometriesSize()
        var position = selectedEntity.position(relativeTo: nil)
        position.y += Float(size / 2)
        
        orientationAnchorEntity?.setPosition(position, relativeTo: nil)
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
        
        switch gameManager?.current {
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
        gameManager?.board.addPoint(to: arAnchor)
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
        gameManager?.change(to: .placing)
    }
    
    @objc
    func start() {
        gameManager?.change(to: .counting)
    }
    
    @objc
    func playAgain() {
        gameManager?.change(to: .starting)
        start()
    }
    
    @objc
    func goHome() {
        gameManager?.change(to: .waiting)
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
        gameManager?.board.restart()
    }
    
    func placingToStarting() {
        arGameView.showStartGameView()
    }
    
    func startingToCounting() {
        gameManager?.board.clearBoard()
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
        gameManager?.board.restart()
    }
    
    func countingToPlaying() {
        gameManager?.board.randomizeInitialBoard()
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
        gameManager?.board.restart()
    }
    
    func placed(area: Double) {
        if area < gameManager!.minimumArea {
            gameManager?.change(to: .waiting)
        } else {
            gameManager?.change(to: .starting)
        }
    }
    
    func counted() {
        gameManager?.change(to: .playing)
    }
    
    func updatedEntities(_ entities: [GeometryEntity]) {
        self.entities = entities
    }
    
    func updateScores(score: Int, highScore: Int) {
        arGameView.showEndGameView(score: score, highScore: highScore)
    }
    
    func played() {
        gameManager?.change(to: .finished)
    }
}

// MARK:- Construcion Delegate

extension ARViewController: ConstructionDelegate {
    func initializingToPlacing() {}
    
    func initializingToInitializing() {}
    
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
    
    func leavingToInitializing() {}
    
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
