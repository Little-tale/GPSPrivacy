//
//  ViewController.swift
//  GPSPrivacy
//
//  Created by Jae hyung Kim on 1/24/24.
//

import UIKit
import MapKit
import CoreLocation // IOS 아이폰 기기의 GPS 를 받아올수 있는 프레임 워크

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        // 잠깐 테스트를 위해 여기다가
        checkDeviceLocationAuthorization()
        
        
    }
    

}
//MARK: -> 1. 내가 왜 정보가 필요하냐
// 2. 너의 디바이스가 위치를 사용하냐
// 3. 너의 깐 내 앱이 위치 권한을 주었느냐 ?
// 4.




// MARK: - 디바이스 위치서비스 활성화 여부 확인
extension ViewController {
    
    func checkDeviceLocationAuthorization() {
        // locationManager.locationServicesEnabled() XXXX
        // 타입 메서드중 Class로 선언된 함수이다.
        
        // 만약 디바이스 자체의 위치 서비스가 활성화 되어있다면, 비동기 처리해야함
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                
                // 활성화 중이니 이제 앱이 권한을 가지고 있는지 확인해야 한다.
                // 디바이스 권한 상태 값들을 가지고 있는 열거형
                let authorization: CLAuthorizationStatus // 비어있는
                
                if #available(iOS 14.0, *) {
                    // 권한상태를 넘겨준다.
                    authorization = self.locationManager.authorizationStatus
                } else {
                    // 이도 동일하지만 버전별로 다르다
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                // 받은 권한 상태값을 분기 하기 위해 넘깁니다.
                DispatchQueue.main.async {
                    
                    self.checkUserLocationAuthorization(authorizationStatus: authorization)
                    
                }
            } else { // 디바이스 자체의 위치 서비스가 활성화 되어 있지 않다면,
                DispatchQueue.main.async {
                    print("🔥🔥🔥🔥🔥🔥🔥")
                    self.goSetting()
                }
            }
            
        }
        
    }
    
}

// MARK: -  유저가 앱에 대해서 위치 권한을 주었는지 확인한다.
    // 활성화 여부 열거형 값을 전달 받는다.
extension ViewController {
    func checkUserLocationAuthorization(authorizationStatus :  CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined: // 한번도 선택을 안했거나 한번만 허용후 다시 올때
            // 이때는 앱 권한을 요청해야함
            // 1. 어느정도 정확도를 가질지 정한다.
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 2. 이정도로 추적할 거니 허락해 달라고 요청한다.
            locationManager.requestWhenInUseAuthorization()
            
        case .denied: // 거부 하였거나 후에 거부 되었을때
            // 이때는 설정으로 유인해야함
            goSetting()
        case .authorizedAlways: // 항상 허용일때
            // 이때는 위치 정보를 불러와야함
            // 위치정보 가져와 즉 시작을 해주자
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse: // 사용할 때만일때,
            // 이때도 위치 정보를 불러야함
            locationManager.startUpdatingLocation()
       default:
            print(fatalError())
        }
    }
}



// MARK: - 위치서비스 활성화가 꺼져있을경우 설정으로 보내기
extension ViewController {
    func goSetting() {
        let alert = UIAlertController(title: "위치정보필요", message: "위치를 활성화 하지 않으셔서 사용자님의 위치를 확인할수 없습니다. 설정 > 개인정보 > 위치권한 설정", preferredStyle: .alert)
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        let check = UIAlertAction(title: "이동", style: .default) { _ in
            self.openSetting()
        }
        alert.addAction(cancle)
        alert.addAction(check)
        
        present(alert, animated: true)
    }
}
// MARK: - 위치 서비스 설정 보내기 메서드
extension ViewController {
    func openSetting(){
        // MARK: 설정으로 이동시키는법
        // 어플리케이션의 오픈세팅 url을 제공하고 있어 활용합니다.
        if let settingUrl = URL(string: UIApplication.openSettingsURLString) {
            // url방식
            UIApplication.shared.open(settingUrl)
        } else {
            let alert = UIAlertController(title: "설정 이동 실패", message: "설정으로 이동하기에 실패 하였습니다. 설정 > 개인정보 > 위치권한 설정 으로 가셔서 설정 바랍니다.", preferredStyle: .alert)
            let check = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(check)
            present(alert, animated: true)
        }
    }
}

// MARK: - 위치나 권한에 따른 분기점
extension ViewController: CLLocationManagerDelegate {
    // 만약 항상 허가나 한번 허가를 해주었으면,
    // 생각할께 대략 3가지이다.
    // 1. 위치가 바뀌었을때,
    // 2. 위치를 불러오지 못할때,
    // 3. 위치권한이 변경되었을때
    
    // 1. 위치가 시작되면, 변경될때마다도 호출된다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations [] 를 통해 위치정보를 볼수있다.
        
        // CLLocation -> CLLocationCoordinate2D
        guard let location = locations.last?.coordinate else {
            locationManager.stopUpdatingLocation()
            return
        }
        //dump(location)
        setRegion(location: location)
        
        
    }
    
    // 2. 위치를 불러오지 못한다면? -> 비행기 모드, 그냥 끈걸수도 있고
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
        
    }
    
    
    // 3. 위치 권한이 변경되었다면? ->
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 변경되었더라도 다시 했을수도 있으니 체크하는 시점으로 보낸다.
        checkDeviceLocationAuthorization()
    }
    
}


extension ViewController {
    func setRegion(location : CLLocationCoordinate2D ) {
        // 위치 저장하하기
        // MKCoordinateRegion
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
        
        mapView.setRegion(region, animated: true)
    }
}
