//
//  BGCViewController.m
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleRoute.h"
#import "BGCTurnByTurnInstructions.h"
#import <MapKit/MapKit.h>
#import "BGCCrimeObject.h"

@interface BGCMapViewController () <CLLocationManagerDelegate, GoogleRouteDelegate> {
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
    [self routeFromDeviceLocationToHome];
}

#pragma mark - map view configuration methods



-(void) configureMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.8739580629 longitude:-87.6277394859 zoom:12]; // Chicago (zoomed out)
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    
    [self.view insertSubview:mapView_ atIndex:0];
}

- (void)addMarkerAtLocation:(CLLocation *)location withTitle:(NSString *)title
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location.coordinate;
    marker.title = title;
    marker.map = mapView_;
}
 

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

 
-(void) routeWithPolyline:(GMSPolyline *)polyline{
    polyline.map = mapView_;
}

-(void) directionsFromServer:(NSDictionary *)directionsDictionary{
    NSDictionary * routesDictionary = directionsDictionary[@"routes"][0];
    NSDictionary * legsDictionary = routesDictionary[@"legs"][0];
    
    self.instructions= [[BGCTurnByTurnInstructions alloc] initWithSteps: legsDictionary[@"steps"]];
    
}
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
