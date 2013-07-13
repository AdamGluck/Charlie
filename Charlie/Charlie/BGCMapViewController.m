//
//  BGCViewController.m
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "GoogleRoute.h"
#import "BGCTurnByTurnInstructions.h"
#import "BGCCrimeDataAccess.h"

@interface BGCMapViewController () <CLLocationManagerDelegate, GoogleRouteDelegate, BGCCrimeDataAccessDelegate> {
    GMSMapView * mapView_;
    BOOL routing;
}
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) BGCTurnByTurnInstructions * instructions;

@end

@implementation BGCMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSDateComponents * hourComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    hourComponents.timeZone = [NSTimeZone systemTimeZone];
    self.time = [hourComponents hour];
    routing = false;
    
    [self configureNavBar];
    [self configureMapView];
    [self fillData];
    
}

#pragma mark - BGCrimeDataAccessDelegate 

-(void) crimeDataFillComplete:(NSArray *)crimeData{
    
    // note to self: self.beat should be getting beat data... using it here for testing
    NSArray * localMidnightCrimes = crimeData[self.time];
    
    int toIndex;
    int crimeCount = [localMidnightCrimes count];
    
    if (crimeCount >= 10)
        toIndex = 9;
    else
        toIndex = crimeCount - 1;
    
    NSArray * topTenHotSpots = [[NSArray alloc] initWithArray:[localMidnightCrimes objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, toIndex)] ] ];
    
    [self routeBetweenCrimeObjects:topTenHotSpots];
    [self configureNavBar];
    
}

#pragma mark - UINavigationBar customization

// this code is going to be repetitive, don't have time to write a custom class
-(void) configureLeftBarButtonItem{
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 11.5, 15)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = [NSArray
                                              arrayWithObjects:negativeSpacer, leftButtonItem, nil];
}

-(void) configureRightBarButtonItem{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"customplus"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(segue) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    
    self.navigationItem.rightBarButtonItems = [NSArray
                                               arrayWithObjects:negativeSpacer, rightButtonItem, nil];
    
    
}

-(void) configureNavBar{
    
    [self configureLeftBarButtonItem];
    [self configureRightBarButtonItem];
   
}

-(void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) segue{
    [self performSegueWithIdentifier:@"optionsSegue" sender:self];
}

#pragma mark - map view configuration methods


-(void) configureMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.8739580629 longitude:-87.6277394859 zoom:12]; // Chicago (zoomed out)
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    
    [self.view insertSubview:mapView_ atIndex:0];
}

- (void)addMarkerAtLocation:(CLLocation *) location withTitle:(NSString *)title
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location.coordinate;
    marker.title = title;
    marker.map = mapView_;
}


#pragma mark - routing functions



// 41.783714,-87.597426
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.locationManager = manager;
    
    
}


-(void) routeBetweenCrimeObjects: (NSArray *) crimeObjects{
        
    BGCCrimeObject * firstHotSpot = crimeObjects[0];
    NSString * firstLocation = [NSString stringWithFormat:@"%f,%f", firstHotSpot.location.coordinate.latitude, firstHotSpot.location.coordinate.longitude];
    
    NSMutableArray * routes = [[NSMutableArray alloc] init];
    
    for (BGCCrimeObject * hotSpot in crimeObjects){
        NSString * location = [NSString stringWithFormat:@"%f, %f", hotSpot.location.coordinate.latitude, hotSpot.location.coordinate.longitude];
        [self addMarkerAtLocation:hotSpot.location withTitle: [NSString stringWithFormat:@"%.02f", hotSpot.probability * 100]];
        [routes addObject:location];
    }

    [routes addObject:firstLocation]; // so it cirlces
    GoogleRoute * route = [[GoogleRoute alloc] initWithWaypoints:[routes copy] sensorStatus:YES andDelegate:self];
    [route goWithTransportationType:kTransportationTypeDriving];

    
}



-(void) routeWithPolyline:(GMSPolyline *)polyline{
    polyline.map = mapView_;

}

-(void) directionsFromServer:(NSDictionary *)directionsDictionary{
    //NSDictionary * routesDictionary = directionsDictionary[@"routes"][0];
    //NSDictionary * legsDictionary = routesDictionary[@"legs"][0];
    
    //self.instructions= [[BGCTurnByTurnInstructions alloc] initWithSteps: legsDictionary[@"steps"]];
    
}

#pragma mark - actions 
- (IBAction)navigate:(id)sender {
    NSDateComponents * hourComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    hourComponents.timeZone = [NSTimeZone systemTimeZone];
    self.time = [hourComponents hour];
    
    [self fillData];
    
    routing = YES;
    
    NSLog(@"location manager = %@", self.locationManager);
    GMSCameraPosition * cameraPosition = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude zoom:17];
    [mapView_ animateToCameraPosition:cameraPosition];
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateCamera:)
                                                     userInfo:nil
                                                     repeats:YES];
}

-(void) fillData{
    BGCCrimeDataAccess * data = [[BGCCrimeDataAccess alloc] init];
    data.delegate = self;
    [data fillCrimeDataFromServerASynchrouslyForBeat:self.beat];
}
 
-(void) updateCamera: (NSTimer *) timer{
    if (routing)
        [mapView_ animateToLocation:self.locationManager.location.coordinate];
    
}


#pragma mark - initialization method

-(CLLocationManager *) locationManager{
    if (!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    }
    
    return _locationManager;
}

#pragma mark - boiler plate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
