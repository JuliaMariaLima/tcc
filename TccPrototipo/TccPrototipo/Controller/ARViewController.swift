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
    
    var modelClassifier: ModelClassifier!
    
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
    
    private lazy var swipeRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        recognizer.direction = [.right, .left]
        
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
        arView.addGestureRecognizer(swipeRecognizer)
        
        createBoard()
        setUpConfigurations()
        setUpARGameView()
        setUpARConstructionView()
        setUpSubscription()
        setUpMatchFormSound()
        setUpCoachingView()
        setUpModelClassifier()
    }
    
    // MARK:- Set ups
    
    func setUpActionsMode() {
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
        
        arGameView.allArrowButtonsView.addButtonsAction(
            buttonUpAction: #selector(buttonUpClicked),
            buttonDownAction: #selector(buttonDownClicked),
            buttonLeftAction: #selector(buttonLeftClicked),
            buttonRightAction: #selector(buttonRightClicked),
            buttonReleasedAction: #selector(buttonReleased),
            target: self)
        
        arGameView.addCountDownViewDelegate(delegate: self)
    }
    
    func setUpARConstructionView() {
        arConstructionView = ARConstructionView(frame: self.view.frame)
        arView.addSubview(arConstructionView)
        
        arConstructionView.setUpConstraints()
        
        arConstructionView.allArrowButtonsView.addButtonsAction(
            buttonUpAction: #selector(buttonUpClicked),
            buttonDownAction: #selector(buttonDownClicked),
            buttonLeftAction: #selector(buttonLeftClicked),
            buttonRightAction: #selector(buttonRightClicked),
            buttonReleasedAction: #selector(buttonReleased),
            target: self)
        
        arConstructionView.addClassifyButtonTarget(target: self, action: #selector(startClassify))
    }
    
    func setUpSubscription() {
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackTerminated.self) { (event) in
            guard let movingEntity = event.playbackController.entity as? GeometryEntity else { return }
            
            for entity in self.board.entities {
                for match in EntityProperties.shared.mapMatches[movingEntity.type]! {
                    if entity.type == match && entity != movingEntity {
                        if self.board.didCombine(movingEntity: movingEntity, staticEntity: entity) {
                            
                            self.selectedEntity = nil
                            self.hideOrientationEntity()
                            self.constructionManager?.change(to: .looking)
                            
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
    
    func setUpModelClassifier() {
        modelClassifier = ModelClassifier()
        modelClassifier.delegate = self
    }
    
    // MARK: - Actions
    
    func resetToInitialConfiguration() {
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        resetWidgets()
    }
    
    func gameWidgetsIsHidden(_ isHidden: Bool) {
        arGameView.timerIsHidden(isHidden)
        
        arGameView.allArrowButtonsView.buttonsIsHidden(isHidden)
        
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
        
        DispatchQueue.main.async {
            self.orientationAnchorEntity?.setPosition(position, relativeTo: nil)
            self.arView.scene.addAnchor(self.orientationAnchorEntity)
        }
    }
    
    func hideOrientationEntity() {
        orientationAnchorEntity?.removeFromParent()
    }
    
    func updateOrientationEntityRotation() {
        orientationAnchorEntity?.setOrientation(cameraAnchor.orientation(relativeTo: cameraAnchor), relativeTo: cameraAnchor)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        let size = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addEntity(of type: GeometryType) -> GeometryEntity? {
        DispatchQueue.main.sync {
            let location = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
            
            guard let result = self.arView.raycast(from: location,
                                                   allowing: .existingPlaneGeometry,
                                                   alignment: .horizontal).first
                else {
                    print("Nao achei nenhum plano")
                    return nil
            }
            
            let arAnchor = ARAnchor(name: "New Anchor", transform: result.worldTransform)
            let anchorEntity = AnchorEntity(world: arAnchor.transform)
            return self.constructionManager?.board.createEntity(in: anchorEntity, type)
        }
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
    func startClassify() {
        guard let canvas = arConstructionView.drawGeometryView.canvas else { return }
        
        let renderer = UIGraphicsImageRenderer(size: canvas.bounds.size)
        let image = renderer.image { rendererContext in
            canvas.layer.render(in: rendererContext.cgContext)
        }
        
        guard let classifyImage = resizeImage(image: image, newWidth: 200.0) else { return }
        
        modelClassifier.updateClassifications(for: classifyImage)
        
        arConstructionView.classify()
    }
    
    @objc
    private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        guard let constructionManager = constructionManager else { return }
        guard constructionManager.current == .looking ||  constructionManager.current == .constructing else {
            return
        }
        
        let swipeLocation = recognizer.location(in: arView)
        
        let hits = arView.hitTest(swipeLocation)
        debugPrint(type(of:self), #function)
        for hit in hits {
            if hit.entity is GeometryEntity {
                let entity = hit.entity as! GeometryEntity
                guard let type = entity.type.next(), let reference = board.getReference() else { return }
                print("Entrou aqui com \(type), \(entity.position(relativeTo: reference))")
                let anchorEntity = AnchorEntity(world: entity.position(relativeTo: reference))
                let newEntity = board.createEntity(in: anchorEntity, type)
                board.removeEntity(entity)
                
                guard let _ = selectedEntity else { return }
                
                selectedEntity = newEntity
                
                return
            }
        }
    }
    
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)
        
        if let _ = gameManager {
            gameHandleTap(location: tapLocation)
        } else if let _ = constructionManager {
            constructionHandleTap(location: tapLocation)
        }
    }
    
    func gameHandleTap(location: CGPoint) {
        guard let gameManager = gameManager else { return }
        
        switch gameManager.current {
        case .placing:
            handleTapGamePlacing(location: location)
        case .playing:
            handleTapGamePlaying(location: location)
        default:
            break
        }
    }
    
    func handleTapGamePlacing(location: CGPoint) {
        guard let result = arView.raycast(from: location,
                                          allowing: .existingPlaneGeometry,
                                          alignment: .horizontal).first else { return }
        
        let arAnchor = ARAnchor(name: "Anchor for cube", transform: result.worldTransform)
        
        arView.session.add(anchor: arAnchor)
        gameManager?.board.addPoint(to: arAnchor)
    }
    
    func handleTapGamePlaying(location: CGPoint) {
        let hits = arView.hitTest(location)
        
        for hit in hits {
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                showOrientationEntity()
                return
            }
        }
    }
    
    func constructionHandleTap(location: CGPoint) {
        guard let constructionManager = constructionManager else { return }
        
        switch constructionManager.current {
        case .placing:
            handleTapConstructionPlacing(location: location)
        case .constructing, .looking:
            handleTapConstructing(location: location)
        default:
            break
        }
    }
    
    func handleTapConstructionPlacing(location: CGPoint) {
        guard let constructionManager = constructionManager else { return }
        
        if !board.haveReference() {
            guard let result = arView.raycast(from: location,
                                              allowing: .existingPlaneGeometry,
                                              alignment: .horizontal).first else { return }
            
            let arAnchor = ARAnchor(name: "Reference", transform: result.worldTransform)

            constructionManager.board.decode(map: construction!.map,
                                             reference:AnchorEntity(anchor: arAnchor))
            constructionManager.change(to: .looking)
        }
    }
    
    func handleTapConstructing(location: CGPoint) {
        guard let constructionManager = constructionManager else { return }

        let hits = arView.hitTest(location)
        
        for hit in hits {
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                showOrientationEntity()
                constructionManager.change(to: .constructing)
                return
            }
        }
    }
    
    func goHome() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Game Delegate

extension ARViewController: GameDelegate {
    func waitingToWaiting() {
        goHome()
    }
    
    func waitingToPlacing() {
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
        resetWidgets()
    }
    
    func startingToWaiting() {
        desappearWidgets()
        coachingView?.removeFromSuperview()
        goHome()
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
    
    func finishedToCounting() {
        coachingView?.removeFromSuperview()
        selectedEntity = nil
    }
    
    func finishedToWaiting() {
        desappearWidgets()
        coachingView?.removeFromSuperview()
        goHome()
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
    func initializingToPlacing() {
        addCoachingView()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func placingToLooking() {
        arConstructionView.looking()
        setUpOrientationEntity()
    }
    
    func lookingToAdding() {}
    
    func lookingToConstructing() {
        arConstructionView.constructing()
    }
    
    func lookingToLeaving() {}
    
    func addingToLooking() {}
    
    // TODO: send to ml
    func addingToClassifying() {
        
    }
    
    func constructingToLooking() {
        selectedEntity = nil
        hideOrientationEntity()
        arConstructionView.looking()
    }
    
    func constructingToLeaving() {
        selectedEntity = nil
        hideOrientationEntity()
    }
    
    // TODO: draw the result
    func classifyingToConstructing() {
        arConstructionView.constructing()
    }
    
    func classifyingToAdding() {
        arConstructionView.addingAgain()
    }
    
    func leavingToInitializing() {
        coachingView?.removeFromSuperview()
        board.restart()
        goHome()
    }
    
    func leavingToLooking() {}
    
    func removeSelectedEntity() {
        board.removeEntity(selectedEntity!)
    }
    
    func saveProgress() {
        arView.snapshot(saveToHDR: false) { (image) in
            if let imageReceived = image {
                self.construction!.image = Image(withImage: imageReceived)
            }
            self.construction!.map = self.constructionManager!.board.encode()
            
            Sandbox.shared.add(self.construction!)
            self.arConstructionView.leave()
        }
    }
}

extension ARViewController: MLDelegate {
    func result(identifier: String, confidence: Float) {
        if EntityProperties.shared.mapFaceToTypes[identifier] != nil && confidence > 0.75 {
            let faces = EntityProperties.shared.mapFaceToTypes[identifier]
            let randomFace = Int.random(in: 0..<faces!.count)
            
            if let entity = addEntity(of: faces![randomFace]) {
                selectedEntity = entity
                showOrientationEntity()
                constructionManager?.change(to: .constructing)
                return
            }
        }
        
        constructionManager?.change(to: .adding)
    }
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
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        if constructionManager != nil && constructionManager?.current == .placing {
            arConstructionView.showFeedBackView()
        }
    }
}

// MARK:- AR Session Delegate

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !isRunningAnimation {
            updateOrientationEntityRotation()
        }
    }
}
