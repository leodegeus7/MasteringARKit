//
//  ViewController.swift
//  Hello-AR
//
//  Created by Leonardo Geus on 10/10/18.
//  Copyright © 2018 Leonardo Geus. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(self.sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        
        
        let scene = SCNScene()
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named :"brick.jpg")
        
        
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(-0.1, 0.1, -0.5)
        
        
        let sphere = SCNSphere(radius: 0.2)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.name = "Colors"
        sphereMaterial.diffuse.contents = UIImage(named :"earth.jpg")
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0.5,0.1,-1)
        
        
        scene.rootNode.addChildNode(node)
        scene.rootNode.addChildNode(sphereNode)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        sceneView.scene = scene
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Colors")
            
            material?.diffuse.contents = UIColor.random()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1)
    }
}
