//
//  ConstructViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 14/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit
import ARKit
import RealityKit
import Combine

class ConstructViewController: UIViewController {
    // MARK: - Properties
    var initialConstruction: Construction! {
        didSet {
            loadConstruction()
        }
    }

    private var construction: Construction!
    
    var entities: [GeometryEntity] = []
    
    var selectedEntity: GeometryEntity?
    
    var orientationAnchorEntity: AnchorEntity!
    
    var animation: Cancellable!
    
    var currentAnimationSelectedEntity: AnimationPlaybackController!
    
    var currentAnimationOrientationAnchor: AnimationPlaybackController!
    
    var isRunningAnimation: Bool! = false
    
    var configuration: ARWorldTrackingConfiguration!
        
    var generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    var matchFormSound: AVAudioPlayer!
    
    var moveDuration: TimeInterval! = 120
    
    var moveDistance: Float! = 40
    
    var board: ConstructionBoard!
    
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
        
    var backButton: BackHomeView!
    
    var addButton: AddGeometryView!
    
    var removeButton: RemoveGeometryView!
    
    var closeButton: CloseView!
    
    var coachingView: ARCoachingOverlayView!
    
    var buttonUp: ArrowButtonView!
    
    var buttonDown: ArrowButtonView!
    
    var buttonRight: ArrowButtonView!
    
    var buttonLeft: ArrowButtonView!
    
    var leaveConstructionView: LeaveConstructionView!
    
    var drawGeometryView: DrawGeometryView!
    
    var loadingView: LoadView!
    
    var feedbackView: FeedbackView!
    
    // MARK:- Life Cicle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(type(of:self), #function)
        // Create a new ARView
        self.arView = ARView(frame: UIScreen.main.bounds, cameraMode: .ar, automaticallyConfigureSession: true)

        // Add the ARView to the view
        self.view.addSubview(arView)
        
        self.arView.session.delegate = self
        
        self.arView.scene.addAnchor(cameraAnchor)
        
        self.arView.addGestureRecognizer(tapRecognizer)
        
        self.setUpConfigurations()
        self.createBoard()
        self.setUpArrowButtons()
        self.setUpBackButton()
        self.setUpAddButton()
        self.setUpRemoveButton()
        self.setUpCloseButton()
        self.setUpLeaveConstructionView()
        self.setUpDrawGeometryView()
        self.setUpLoadingView()
        self.setUpFeedbackView()
        self.setUpConstructOrientationEntity()
        self.setUpConstructCoachingView()
    }
    
    // MARK:- Set ups
    
    func setUpConfigurations() {
        self.configuration = ARWorldTrackingConfiguration()
        self.configuration.planeDetection = .horizontal
        
        // arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showPhysics]

        self.arView.session.run(self.configuration)
    }
    
    func createBoard() {
        self.board = ConstructionBoard(view: arView,
                                  entitieTypes: EntityProperties.shared.entitieTypes,
                                  colors: EntityProperties.shared.colors,
                                  mapMatches: EntityProperties.shared.mapMatches)
    }
    
    func setUpArrowButtons() {
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
    
    func setUpBackButton() {
        backButton = BackHomeView()
        view.addSubview(backButton)
        
        backButton.setUpConstraints()
        backButton.addTarget(self, action: #selector(leave), for: .touchDown)
    }
    
    func setUpAddButton() {
        addButton = AddGeometryView()
        view.addSubview(addButton)
        
        addButton.setUpConstraints()
        addButton.addTarget(self, action: #selector(startDrawing), for: .touchDown)
    }
    
    func setUpRemoveButton() {
        removeButton = RemoveGeometryView()
        view.addSubview(removeButton)
        
        removeButton.setUpConstraints()
    }
    
    func setUpCloseButton() {
        closeButton = CloseView()
        view.addSubview(closeButton)
        
        closeButton.setUpConstraints()
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
    }
    
    func setUpLeaveConstructionView() {
        leaveConstructionView = LeaveConstructionView()
        view.addSubview(leaveConstructionView)
        
        leaveConstructionView.setUpConstraints()
        
        leaveConstructionView.yesButton.addTarget(self, action: #selector(saveAndLeave), for: .touchDown)
        leaveConstructionView.noButton.addTarget(self, action: #selector(dontSaveAndLeave), for: .touchDown)
        leaveConstructionView.cancelButton.addTarget(self, action: #selector(cancelLeave), for: .touchDown)
    }
    
    func setUpDrawGeometryView() {
        drawGeometryView = DrawGeometryView()
        view.addSubview(drawGeometryView)
        
        drawGeometryView.setUpConstraints()
    }
    
    func setUpLoadingView() {
        loadingView = LoadView()
        view.addSubview(loadingView)
        
        loadingView.setUpConstraints()
    }
    
    func setUpFeedbackView() {
        feedbackView = FeedbackView()
        view.addSubview(feedbackView)
        
        feedbackView.setUpConstraints()
    }
    
    func setUpConstructOrientationEntity() {
        let oritentationEntity = OrientationEntity(size: 2 * board.getGeometriesSize())
        
        orientationAnchorEntity = AnchorEntity()
        orientationAnchorEntity.addChild(oritentationEntity)
    }
    
    // MARK: - Actions
    
    func loadConstruction() {
        print("Load construction...")
        construction = initialConstruction
        startConstruction()
    }
    
    func startConstruction() {
        addCoachingView()
        arView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func getSelectedEntityTransform() -> Transform? {
        guard let selectedEntity = selectedEntity else { return nil }
        
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        return Transform(matrix: transformMatrix)
    }
    
    func moveAnimation(to transform: Transform) {
        guard let selectedEntity = selectedEntity else { return }
        
        currentAnimationSelectedEntity = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
        
        currentAnimationOrientationAnchor = orientationAnchorEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
        
        isRunningAnimation = true
    }
    
    func stopAnimation() {
        currentAnimationSelectedEntity?.stop()
        currentAnimationOrientationAnchor?.stop()
        
        isRunningAnimation = false
    }
    
    func showOrientationEntity() {
        guard let selectedEntity = selectedEntity else { return }
        let size = 0.2
        var position = selectedEntity.position(relativeTo: nil)
        position.y += Float(size / 2)
        
        orientationAnchorEntity?.setPosition(position, relativeTo: nil)
        arView.scene.addAnchor(orientationAnchorEntity)
    }
    
    func hideOrientationEntity() {
        orientationAnchorEntity.removeFromParent()
    }
    
    func updateOrientationEntityRotation() {
        orientationAnchorEntity?.setOrientation(cameraAnchor.orientation(relativeTo: cameraAnchor), relativeTo: cameraAnchor)
    }
    
    func appearArrowButtons() {
        buttonUp.isHidden = false
        buttonDown.isHidden = false
        buttonRight.isHidden = false
        buttonLeft.isHidden = false
    }
    
    func desappearArrowButtons() {
        buttonUp.isHidden = true
        buttonDown.isHidden = true
        buttonRight.isHidden = true
        buttonLeft.isHidden = true
    }
    
    // MARK: - Objc actions
    
    @objc
    func buttonUpClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.y += moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonDownClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.y -= moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonLeftClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.x -= moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonRightClicked() {
        guard var transform = getSelectedEntityTransform() else { return }
        
        transform.translation.x += moveDistance
        
        moveAnimation(to: transform)
    }
    
    @objc
    func buttonReleased() {
        stopAnimation()
    }
    
    @objc
    func leave() {
        leaveConstructionView.isHidden = false
        
        desappearArrowButtons()
        backButton.isHidden = true
        removeButton.isHidden = true
        addButton.isHidden = true
        closeButton.isHidden = true
        selectedEntity = nil
        stopAnimation()
        
        
//        coachingView = nil
    }
    
    @objc
    func saveAndLeave() {
        leaveConstructionView.isHidden = true
        backButton.isHidden = false
        addButton.isHidden = false
        construction.map = board.encode()
        Sandbox.shared.add(construction)
        coachingView?.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func dontSaveAndLeave() {
        leaveConstructionView.isHidden = true
        backButton.isHidden = false
        addButton.isHidden = false
        coachingView?.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cancelLeave() {
        leaveConstructionView.isHidden = true
        backButton.isHidden = false
        addButton.isHidden = false
    }
    
    @objc
    func startDrawing() {
        backButton.isHidden = true
        addButton.isHidden = true
        closeButton.isHidden = false
        
        drawGeometryView.isHidden = false
        drawGeometryView.start()
    }
    
    @objc
    func close() {
        drawGeometryView.isHidden = true
        removeButton.isHidden = true
        closeButton.isHidden = true
        
        backButton.isHidden = false
        addButton.isHidden = false

        selectedEntity = nil
    }
    
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer) {
        print(">>>> TAP <<<<")
        let tapLocation = recognizer.location(in: arView)
        let hits = arView.hitTest(tapLocation)
        
        if !board.haveReference() {
            guard let result = arView.raycast(from: tapLocation,
                                              allowing: .existingPlaneGeometry,
                                              alignment: .horizontal).first
                else { return }
            
            let arAnchor = ARAnchor(name: "Reference", transform: result.worldTransform)
            board.createEntity(from: arAnchor)
            board.set(reference: AnchorEntity(anchor: arAnchor))
            print("e ai")
            return
        }
        
        for hit in hits {
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                showOrientationEntity()
                return
            }
        }
        
        print("Achou nada")
    }
}

//MARK: - AR Coaching Overlay View Delegate

extension ConstructViewController: ARCoachingOverlayViewDelegate {
    
    func setUpConstructCoachingView() {
        self.coachingView = ARCoachingOverlayView()
        
        self.coachingView.delegate = self
        self.coachingView.goal = .horizontalPlane
        self.coachingView.session = arView.session
        self.coachingView.translatesAutoresizingMaskIntoConstraints = false
        self.coachingView.activatesAutomatically = true
    }
    
    func addCoachingView() {
        self.view.addSubview(self.coachingView)
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.coachingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.coachingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.coachingView.heightAnchor.constraint(equalTo: view.heightAnchor),
            self.coachingView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        feedbackView.isHidden = false
    }
}

// MARK:- AR Session Delegate

extension ConstructViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !isRunningAnimation {
            updateOrientationEntityRotation()
        }
    }
}
