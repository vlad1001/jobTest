//vlad B

//short explanation - i created all the bases for the project is contains a map and a text filed in which i can change every second the text 
//according to the distance, and weather or not im in the polygon. i used a built in class called UIBezierPath() in the contains method, 
//which is not being used because i could not open the kml properly and show the polygon on the map, instead i just took 2 coordinated from 

//google maps for you to see my algorithm of sitance in action(all forumals were taken from wikipedia).

//i used stackoverflow/Wikipedia/youtube to create this program (the algroithm was written completly by me.
//Thanks you
import UIKit
import MapKit
import CoreLocation
import Darwin //Math library


class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myTextView: UITextView!
    
    var gameTimer: Timer! //to change distance every second
    var locationManager = CLLocationManager() //get user location
    
    var userLongtitude: Double = 0 //to keep track where is the user
    var userLatitude: Double = 0 //to keep track where is the user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = CLLocation(latitude: 32.062702, longitude: 34.790663) // set initial location in Nirim 1 st. Tel-Aviv

        //points = getPointsFromKml(); //did not succeed
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLoacation), userInfo: nil, repeats: true)//run update loaction every 1 second and show if User is inside the polygon or the shotest distance to it.
    }
    
   
    func locateUser() { //load user position
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //tracking doesnt stops
        
        myMapView.showsUserLocation = true
        
    }
    
    //init location services and keep track of coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        userLatitude = userLocation.coordinate.latitude; //get user coordinate
        userLongtitude = userLocation.coordinate.longitude; //get user coordinate
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        
        myMapView.setRegion(region, animated: true)
        
    }
    
    func updateLoacation() {
        
        locateUser()
        let point: CGPoint = CGPoint(x:userLongtitude, y:userLatitude)

        let p1 = Point(x: 32.145148, y: 34.845780) // some place in Ramat Hasharon
        let p2 = Point(x: 32.062702, y: 34.790663)// Nirim 1 st. just for distance test

        //var isInside: Bool = contains(polygonFromKml) //could not load kml file so couldnt check polygon
        let tmpDistance:Double = round(getDistanceBetweenTwoPoints(somePoint: p1, myPoint: p2)*1000/10)
        myTextView.text = "Welcome, \n The user coordinate are: \(point) \n Distance is : \(tmpDistance) km"

    }
    
    //check if user is inside of a polygon -> copied completely from stackoverflow
    func contains(polygon: [CGPoint], test: CGPoint) -> Bool {
        if polygon.count <= 1 {
            return false //or if first point = test -> return true
        }
        
        let p = UIBezierPath()
        let firstPoint = polygon[0] as CGPoint
        
        p.move(to: firstPoint)
        
        for index in 1...polygon.count-1 {
            p.addLine(to: polygon[index] as CGPoint)
        }
        
        p.close()
        
        return p.contains(test)
    }
    

    //searches for the 2 closest points to the current location, the closest point will be somewhere between them
    func findNearsetPoints(pointsArray: [Point] , myPoint: Point )-> Array <Point>{
        
    var twoPoint = [Point]()
    var minDist1:Double = DBL_MAX;
    var minDist2:Double = DBL_MAX;
    var distance:Double = 0
    
    for element in pointsArray{
        distance = getDistanceBetweenTwoPoints(somePoint: element, myPoint : myPoint );
        if (distance < minDist1) {
            minDist1 = distance;
            twoPoint[1] = twoPoint[0];
            twoPoint[0] = element;
        }
        else if (distance < minDist2) {
            minDist2 = distance;
            twoPoint[1] = element;
        }
    }
    
    return twoPoint;
    }
    
    //line distance equation (2 points)
    func getDistanceBetweenTwoPoints(somePoint:Point , myPoint:Point )->Double{
        return sqrt(pow(somePoint.x - myPoint.x, 2) + pow(somePoint.y - myPoint.y, 2));
    }
    
    
    //shortest distance between a point and a line
    func findNearsetDistanceFromLine(twoPoints: [Point] , myPoint: Point )->Double {
        return abs( ((twoPoints[1].y - twoPoints[0].y)*myPoint.x) - ((twoPoints[1].x - twoPoints[0].x)*myPoint.y) + (twoPoints[1].x*twoPoints[0].y) - (twoPoints[1].y*twoPoints[0].x) )
            / sqrt(pow(twoPoints[1].y-twoPoints[0].y, 2) + pow(twoPoints[1].x-twoPoints[0].x, 2));
        
    }
    
    
    class Point{
        var x: Double
        var y: Double
        
        init() {
            self.x = 0.0
            self.y = 0.0
        }

        
        init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }
    }
}



