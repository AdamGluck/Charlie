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
}
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) BGCTurnByTurnInstructions * instructions;

@end

@implementation BGCMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureMapView];
    //[self routeFromDeviceLocationToHome];
    
    BGCCrimeDataAccess * data = [[BGCCrimeDataAccess alloc] init];
    data.delegate = self;
    [data fillCrimeDataFromServerASynchrouslyForBeat:1];
}

#pragma mark - BGCrimeDataAccessDelegate 

-(void) crimeDataFillComplete:(NSArray *)crimeData{
    
    // note to self: self.beat should be getting beat data... using it here for testing
    NSArray * localMidnightCrimes = crimeData[self.beat];
    
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

-(void) configureNavBar{
    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 31)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 7;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = [NSArray
                                              arrayWithObjects:negativeSpacer, leftButtonItem, nil];
}

-(void) back{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void) routeFromDeviceLocationToHome{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
}
// 41.783714,-87.597426
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    CLLocationCoordinate2D currentLocation = manager.location.coordinate;
    
    CLLocationCoordinate2D homeLocation = CLLocationCoordinate2DMake(41.783714, -87.597426);
    
    GoogleRoute * route = [[GoogleRoute alloc] initWithWaypoints:@[[NSString stringWithFormat:@"%f,%f", currentLocation.latitude, currentLocation.longitude], [NSString stringWithFormat:@"%f,%f", homeLocation.latitude, homeLocation.longitude]] sensorStatus:YES andDelegate:self];

    
    [route goWithTransportationType:kTransportationTypeDriving];
    
    [manager stopUpdatingLocation];
    
}


-(void) routeBetweenCrimeObjects: (NSArray *) crimeObjects{
    
    NSLog(@"crime objects count == %i", [crimeObjects count]);
    
    BGCCrimeObject * firstHotSpot = crimeObjects[0];
    NSString * firstLocation = [NSString stringWithFormat:@"%f,%f", firstHotSpot.location.coordinate.latitude, firstHotSpot.location.coordinate.longitude];
    
    NSMutableArray * routes = [[NSMutableArray alloc] init];
    
    for (BGCCrimeObject * hotSpot in crimeObjects){
        NSString * location = [NSString stringWithFormat:@"%f, %f", hotSpot.location.coordinate.latitude, hotSpot.location.coordinate.longitude];
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
    
    NSLog( @"%@", [self.instructions next]);
}
 

#pragma mark - boiler plate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
