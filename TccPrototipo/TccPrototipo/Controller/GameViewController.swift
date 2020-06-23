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
    
    var arView: ARView!
    
    var coachingView: ARCoachingOverlayView!
    
    var floor: FloorEntity!
    
    var anchorEntityFloor: AnchorEntity!
    
    var anchorEntityForms: [AnchorEntity] = []
    
    var entities: [GeometryEntity] = []
    
    var entitieTypes: [GeometryType] = []
    
    var mapMatches: [GeometryType:[GeometryType]] = [:]
    
    var selectedEntity: GeometryEntity!
    
    var planeAnchor: ARPlaneAnchor? = nil
    
    var animation: Cancellable!
    
    var currentAnimation: AnimationPlaybackController!
    
    var isTouching: Bool! = false
    
    var moveDuration: TimeInterval = 30
    
    var moveDistance: Float = 10
    
    var timerView: TimerView!
    
    var pointsView: PointsView!
    
    var points: Int = 0
    
    var placeBoardView: PlaceBoardView!
    
    var startGameView: StartGameView!
    
    var endGameView: EndGameView!
    
    var configuration: ARWorldTrackingConfiguration!
    
    var game: Game!
    
    var board: Board!
    
    var countDownView: CountDownView!
    
    var buttonUp: ArrowButtonView!
    
    var buttonDown: ArrowButtonView!
    
    var buttonRight: ArrowButtonView!
    
    var buttonLeft: ArrowButtonView!
    
    var colors: [UIColor] = [.blue, .red, .yellow]
    
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
    
    // MARK:- UI Views
    
    
    // MARK:- Life Cicle
    
    override func loadView() {
        let view = ARView(frame: UIScreen.main.bounds)
        
        self.view = view
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>oi")
        super.viewDidLoad()
        
        arView = self.view as? ARView
        
        arView.session.delegate = self
        arView.scene.addAnchor(cameraAnchor)
        
        floor = FloorEntity(color: .clear)
        
        arView.addGestureRecognizer(tapRecognizer)
        
        game = Game(viewController: self)
        
        setUpConfigurations()
        createBoard()
        setUpButtons()
        setUpTimer()
        setUpPoints()
        setUpPlaceBoard()
        setUpCountDown()
        setUpStartGame()
        setUpEndGame()
        setUpSubscription()
        setUpMatches()
        setUpEntitiesTypes()
    }
    
    // MARK:- Set ups
    
    func setUpConfigurations() {
        configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
//        arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showPhysics]
        arView.session.run(configuration)
    }
    
    func createBoard() {
        board = Board(view: arView)
        board!.delegate = self
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
    
    func setUpTimer() {
        timerView = TimerView(frame: .zero, duration: game.duration)
        view.addSubview(timerView)
        
        timerView.setUpConstraints()
    }
    
    func setUpPoints() {
        pointsView = PointsView(frame: .zero)
        view.addSubview(pointsView)
        
        pointsView.setUpConstraints()
    }
    
    func setUpEndGame() {
        endGameView = EndGameView(frame: .zero)
        view.addSubview(endGameView)
        
        endGameView.setUpConstraints()
        
        endGameView.playButton.addTarget(self, action: #selector(playAgain), for: .touchDown)
        endGameView.homeButton.addTarget(self, action: #selector(goHome), for: .touchDown)
    }
    
    func setUpStartGame() {
        startGameView = StartGameView(frame: .zero)
        view.addSubview(startGameView)
        
        startGameView.setUpConstraints()
        
        startGameView.playButton.addTarget(self, action: #selector(start), for: .touchDown)
        startGameView.homeButton.addTarget(self, action: #selector(goHome), for: .touchDown)
    }
    
    func setUpPlaceBoard() {
        placeBoardView = PlaceBoardView(frame: .zero)
        view.addSubview(placeBoardView)
        
        placeBoardView.setUpConstraints()
        
        placeBoardView.placeButton.addTarget(self, action: #selector(place), for: .touchDown)
        placeBoardView.homeButton.addTarget(self, action: #selector(goHome), for: .touchDown)
    }
    
    func setUpCountDown() {
        countDownView = CountDownView()
        view.addSubview(countDownView)
        
        countDownView.setUpConstraints()
        
        countDownView.delegate = self
    }
    
    func setUpSubscription() {
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackTerminated.self) { (event) in
            guard let movingEntity = event.playbackController.entity as? GeometryEntity else { return }
            for entity in self.entities {
                for match in self.mapMatches[movingEntity.type]! {
                    if entity.type == match && entity != movingEntity {
                        self.calculateDistance(movingEntity: movingEntity, staticEntity: entity)
                    }
                }
                //                print("MAPMATCHES[", movingEntity,"] = ", self.mapMatches[movingEntity.type] ?? [])
                //                if mapMatches[movingEntity]
                //
            }
        }
    }
    
    func setUpEntities(size: Double) {
        entities.append(CubeEntity(color: .red, size: size))
        entities.append(QuadrilateralPyramidEntity(color: .blue, size: size))
        entities.append(TriangularPrismEntity(color: .cyan, size: size))
        entities.append(SemiSphereEntity(color: .green, size: size))
        entities.append(CylinderEntity(color: .magenta, size: size))
        entities.append(PentagonalPrismEntity(color: .orange, size: size))
        entities.append(TetrahedronEntity(color: .yellow, size: size))
        entities.append(ConeEntity(color: .systemPink, size: size))
        entities.append(PentagonalPyramidEntity(color: .white, size: size))
        
        selectedEntity = entities.first!
    }
    
    func setUpEntitiesTypes() {
        entitieTypes.append(.Cube)
        entitieTypes.append(.QuadrilateralPyramid)
        entitieTypes.append(.TriangularPrism)
        entitieTypes.append(.SemiSphere)
        entitieTypes.append(.Cylinder)
        entitieTypes.append(.PentagonalPrism)
        entitieTypes.append(.Tetrahedron)
        entitieTypes.append(.Cone)
        entitieTypes.append(.PentagonalPyramid)
    }
    
    func setUpMatches() {
        mapMatches[.Cube] = [.Cube]
        mapMatches[.QuadrilateralPyramid] = [.Cube]
        mapMatches[.TriangularPrism] = [.TriangularPrism]
        mapMatches[.SemiSphere] = [.Cylinder]
        mapMatches[.Cylinder] = [.Cylinder]
        mapMatches[.PentagonalPrism] = [.PentagonalPrism]
        mapMatches[.Tetrahedron] = [.TriangularPrism]
        mapMatches[.Cone] = [.Cylinder]
        mapMatches[.PentagonalPyramid] = [.PentagonalPrism]
    }
    
    func addEntities() {
        guard
            let result = arView.raycast(from: self.view.center, allowing: .existingPlaneGeometry, alignment: .horizontal).first,
            let anchor = result.anchor as! ARPlaneAnchor?
            else {
                resetToInitialConfiguration()
                return
        }
        
        print("EXTENT:: ", anchor.extent)
        
        let x = result.worldTransform.columns.3.x
        let y = result.worldTransform.columns.3.y
        let z = result.worldTransform.columns.3.z
        
        var n: Double = 0
        for entity in entities {
            entity.generateCollisionShapes(recursive: false)
            
            let anchorEntity = AnchorEntity()
            anchorEntity.position = [x + Float(n*0.4), y, z]
            
            entity.position = [0, 0, 0]
            anchorEntity.addChild(entity)
            
            arView.scene.addAnchor(anchorEntity)
            
            entity.addCollision()
            n += 1
        }
        
        //        anchorEntityFloor = AnchorEntity()
        //        anchorEntityFloor.position = [x, y, z]
        //        anchorEntityFloor.addChild(floor)
        //
        //        arView.scene.addAnchor(anchorEntityFloor)
    }
    
    // MARK: - Actions
    
    func calculateDistance(movingEntity: GeometryEntity, staticEntity: GeometryEntity) {
        let staticPosition = staticEntity.position(relativeTo: nil)
        let movingPosition = movingEntity.position(relativeTo: nil)
        print("static position: ", staticPosition)
        print("moving position: ", movingPosition)
        var goalPosition = staticPosition
        goalPosition.y += 0.2
        let dist = distance(staticPosition, movingPosition)
        print("DIST (static: ", staticEntity, " - moving: ", movingEntity, ") = ", dist)
        //        let minDist = staticEntity.model!.mesh.bounds.max.y
        if dist < 0.22 && staticPosition.y - movingPosition.y > -0.22 {
            
            movingEntity.setPosition(goalPosition, relativeTo: nil)
            movingEntity.cancelCollision()
            staticEntity.cancelCollision()
            let alert = UIAlertController(title: "Você ganhou!!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Jogar de novo", style: .cancel, handler: { (alert) in
                //                        self.staticEntity.removeFromParent()
                //                        self.movingEntity.removeFromParent()
                //                        self.anchorEntityFloor.removeFromParent()
                // self.reset()
                //                movingEntity.cancelCollision()
                //                staticEntity.cancelCollision()
            }))
            
            self.present(alert, animated: true)
            points += 10
            pointsView.update(points)
        }
    }
    
    func resetToInitialConfiguration() {
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        planeAnchor = nil
        timerView.restart()
        points = 0
        pointsView.update(points)
        coachingView.activatesAutomatically = true
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
    
    //MARK: - Objc actions
    
    @objc
    func buttonUpClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.y += moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonDownClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.y -= moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonLeftClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.x -= moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonRightClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.x += moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonReleased() {
        currentAnimation.stop()
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
        
        let arAnchor = ARAnchor(name: "Anchor for sphere", transform: result.worldTransform)
        
        arView.session.add(anchor: arAnchor)
        board.addPoint(to: arAnchor)
        print("Botou")
    }
    
    func handleTapPlaying(location: CGPoint) {
        let hits = arView.hitTest(location)
        
        for hit in hits {
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                print("SELECTED ENTITY IS:::: ", selectedEntity as Any)
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
//        setUpCoachingView()
//        resetToInitialConfiguration()
//        startGameView.isHidden = true
    }
    
    @objc
    func playAgain() {
        game.change(to: .starting)
        start()
    }
    
    @objc
    func goHome() {
        coachingView?.removeFromSuperview()
        coachingView = nil
        startGameView.isHidden = false
        endGameView.isHidden = false
        game.change(to: .waiting)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Game actions
    
    func waitingToWaiting() {}

    func waitingToPlacing() {
        placeBoardView.isHidden = true
        setUpCoachingView()
        resetToInitialConfiguration()
        desappearWidgets()
    }
    
    func placingToStarting() {
        startGameView.isHidden = false
    }
    
    func startingToCounting() {
        startGameView.isHidden = true
        countDownView.start()
    }
    
    func countingToPlaying() {
        board.randomizeInitialBoard(entitieTypes: entitieTypes, colors: colors)
        appearWidgets()
        DispatchQueue.main.async { [unowned self] in
            self.timerView.startClock() {
                self.played()
            }
        }
    }
    
    func playingToFinished() {
        desappearWidgets()
        endGameView.present()
    }
    
    func finishedToStarting() {
        for entity in entities {
            entity.anchor?.removeFromParent()
        }
        
        coachingView?.removeFromSuperview()
        coachingView = nil
        entities.removeAll()
        selectedEntity = nil
        endGameView.isHidden = true
    }
    
    func finishedToWaiting() {}
}

//MARK: - Game Delegate

extension GameViewController: GameDelegate {
    func placed(_ board: Board, anchors: [AnchorEntity]) {
        game.change(to: .starting)
    }
    
    func counted() {
        game.change(to: .playing)
    }

    func played() {
        game.change(to: .finished)
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
        print("ta funcionando desativei", coachingOverlayView)
        coachingView.activatesAutomatically = false
        
//        DispatchQueue.main.async { [unowned self] in
//            self.timerView.startClock() {
//                self.endGameView.present()
//            }
//
//            self.addEntities()
//        }
    }
}

// MARK:- AR Session Delegate

extension GameViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor, planeAnchor == nil {
                print("PLANOOOO")
                planeAnchor = anchor as? ARPlaneAnchor
                print(planeAnchor!)
            }
        }
    }
}
