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

@interface BGCMapViewController () <CLLocationManagerDelegate, GoogleRouteDelegate> {
    GMSMapView *mapView_;
}
@property (strong, nonatomic) CLLocationManager * locationManager;

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
    
    self.view = mapView_;
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

    self.locationManager = manager;
    
    NSString * waypointCurrent = [NSString stringWithFormat:@"%f,%f", manager.location.coordinate.latitude, manager.location.coordinate.longitude];
    NSString * waypointHome = @"41.783714,-87.597426";
    
    GoogleRoute * route = [[GoogleRoute alloc] initWithWaypoints:@[waypointCurrent, waypointHome] sensorStatus:YES andDelegate:self];
    
    [route goWithTransportationType:kTransportationTypeDriving];
    
    [manager stopUpdatingLocation];
    
}

-(void) routeWithPolyline:(GMSPolyline *)polyline{
    polyline.map = mapView_;
}

-(void) directionsFromServer:(NSDictionary *)directionsDictionary{
    NSDictionary * routesDictionary = directionsDictionary[@"routes"][0];
    NSDictionary * legsDictionary = routesDictionary[@"legs"][0];
    
    
}

#pragma mark - boiler plate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
