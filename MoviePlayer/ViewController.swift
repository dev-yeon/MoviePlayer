//
//  ViewController.swift
//  MoviePlayer
//
//  Created by yeon I on 10/27/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPlayerInternalMovie(_ sender: UIButton) {
        //내부파일 mp4
        guard  let filePath:String? = Bundle.main.path(forResource: "waterFall", ofType: "mp4") else {
            self.view.showToast(message: "파일을 찾을수가 없네요.")
            return
        }
        let url = NSURL(fileURLWithPath: filePath!)
        playVideo(url: url)
    }
    
    @IBAction func btnPlayExternalMovie(_ sender: UIButton) {
        //외부파일 mp4
        guard let url = NSURL(string: "https://www.dropbox.com/scl/fi/uwdmlbr05jrx0m750qdaj/2023.-10.-27.-3-54-52.mp4?rlkey=iqaip10eya3d5us4ipsaemdma&dl=0") else {
            self.view.showToast(message: "URL이 유효하지 않습니다.")
            return
        }
        //https://www.dropbox.com/scl/fi/uwdmlbr05jrx0m750qdaj/2023.-10.-27.-3-54-52.mp4?rlkey=iqaip10eya3d5us4ipsaemdma&dl=0
   
        playVideo(url: url)
    }
    //url을 이용해서 비디오를 재생하는 함수
    private func playVideo(url : NSURL) {
        let playerController =  AVPlayerViewController()
        let player =  AVPlayer(url: url as URL)
        playerController.player = player
        
        self.present(playerController, animated: true) {
            player.play()
            DispatchQueue.main.async {
                self.view.showToast(message: "동영상을 재생합니다.")
            }
        }
    }
}
extension UIView {
    private struct ToastFlag {
        static var isToastShowing = false // 토스트 표시 여부를 추적하는 플래그
    }

    func showToast(message: String, duration: TimeInterval = 3.0) {
        guard !ToastFlag.isToastShowing else { return } // 토스트가 이미 표시되고 있지 않은 경우에만 계속 진행
        ToastFlag.isToastShowing = true // 토스트를 표시하기 시작하면 플래그를 true로 설정

        let toastLabel = UILabel()
        // ... 기존 토스트 설정 코드 ...

        // 토스트 레이블을 뷰에 추가하고 맨 앞으로 가져오기
        self.addSubview(toastLabel)
        self.bringSubviewToFront(toastLabel)

        // 오토레이아웃 설정
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastLabel.widthAnchor.constraint(equalToConstant: 300),
            toastLabel.heightAnchor.constraint(equalToConstant: 35)
        ])

        // 토스트 사라지는 애니메이션
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
            ToastFlag.isToastShowing = false // 토스트가 사라지면 플래그를 false로 설정
        })
    }
}

