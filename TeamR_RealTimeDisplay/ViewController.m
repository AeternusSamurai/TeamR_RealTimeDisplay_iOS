//
//  ViewController.m
//  TeamR_RealTimeDisplay
//
//  Created by Darin McCarren on 1/21/16.
//  Copyright © 2016 Darin McCarren. All rights reserved.
//

//#define JSON_URL  @"http://groupq.cs.wright.edu/test.php"

#import "ViewController.h"
#import "CBAutoScrollLabel.h"
#import "SWRevealViewController.h"
#import "settingViewController.h"
#import "assetModel.h"
@import GoogleMaps;
#import "HUD.h"
#import "AppDelegate.h"


@interface ViewController ()

@property (nonatomic, strong) settingViewController *setViewController;




@end

@implementation ViewController
@synthesize indexPath;
@synthesize numberForCase;


- (void)viewDidLoad {
    [super viewDidLoad];
    ////////////////////////////////////////////////////////////////////
    //DATABASE
    //Assets ( ID Location(gps) Type title Department group status goal)
    ////////////////////////////////////////////////////////////////////
    // Do any additional setup after loading the view, typically from a nib.
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self checkNetwork];
    _setViewController.url.text = @"http://groupq.cs.wright.edu/test.php";
    [HUD showUIBlockingIndicatorWithText:@"Fetching Data"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self fetchAssestData];
    [HUD hideUIBlockingIndicator];
    [HUD showUIBlockingIndicatorWithText:@"Populating map"];
    // Call to initialize map
    [self googleMapsInit];
    // Code to make text scroll in the urgent message when message is to long
    [self scrollText];
    // Call custom Setup for the top of the application
    [self customSetup];
    [HUD hideUIBlockingIndicator];
    if (appDelegate.isPressed1 == true || appDelegate.isPressed2 == true || appDelegate.isPressed3 == true || appDelegate.isPressed4 == true || appDelegate.isPressed5 == true || appDelegate.isPressed6 == true)
    {
        [_mapView clear];
    }
        if (appDelegate.isPressed1 == true)
        {
            numberForCase = appDelegate.numPressed1;
            appDelegate.isPressed1 = false;
            appDelegate.isPressed2 = false;
            appDelegate.isPressed3 = false;
            appDelegate.isPressed4 = false;
            appDelegate.isPressed5 = false;
            appDelegate.isPressed6 = false;
            [self assetFilter];
        }
    
    
        if (appDelegate.isPressed2 == true)
        {
            numberForCase = appDelegate.numPressed2;
            [self assetFilter];
        }
    
    
        if (appDelegate.isPressed3 == true)
        {
            numberForCase = appDelegate.numPressed3;
            [self assetFilter];
        }
    
   
        if (appDelegate.isPressed4 == true)
        {
            numberForCase = appDelegate.numPressed4;
            [self assetFilter];
        }
    
    
        if (appDelegate.isPressed5 == true)
        {
            numberForCase = appDelegate.numPressed5;
            [self assetFilter];
        }
    
        if (appDelegate.isPressed6 == true)
        {
            numberForCase = appDelegate.numPressed6;
        [self assetFilter];
        }

    

   
    if (_myTimer == nil)
    {
        __weak NSObject *weakSelf = self;
        _myTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target:weakSelf selector: @selector(googleMapsUpdate:) userInfo: nil repeats: YES];
    }
    
   

    
}

-(void)checkNetwork
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        NSLog(@"Device is connected to the Internet");
    else
    {
        NSLog(@"Device is not connected to the Internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable"
                                                        message:@"App content may be limited without a network connection. Please check connection"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    
    
    if (revealViewController)
    {
        [self.barButton setTarget: self.revealViewController];
        [self.barButton setAction: @selector(revealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
}

- (void)assetFilter
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    switch (numberForCase)
    {
        case 1:
            [_mapView clear];
            [self googleMapsInit];
            break;
            
        case 2:
            if (appDelegate.isPressed6 == true || appDelegate.isPressed3 == true || appDelegate.isPressed4 == true || appDelegate.isPressed5 == true)
            {
                for (int i = 0; i < _assetData.count; i++)
                {
                    _assets = [_assetData objectAtIndex:i];
                    NSNumber* lat = [_assets objectForKey:@"Latitude"];
                    double xlat = [lat doubleValue];
                    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                    double xlongitude = [longitude doubleValue];
                    NSString *name = [_assets objectForKey:@"Name"];
                    NSString *depart = [_assets objectForKey:@"Department"];
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    // if to change color of markers according to the department type
                    if([depart  containsString: @"Fire"])
                    {
                        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                        marker.map = self.mapView;
                        marker.title = name;
                        marker.snippet = depart;
                        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                    }
                }

            }
            else
            {
                [_mapView clear];
                for (int i = 0; i < _assetData.count; i++)
                {
                    _assets = [_assetData objectAtIndex:i];
                    NSNumber* lat = [_assets objectForKey:@"Latitude"];
                    double xlat = [lat doubleValue];
                    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                    double xlongitude = [longitude doubleValue];
                    NSString *name = [_assets objectForKey:@"Name"];
                    NSString *depart = [_assets objectForKey:@"Department"];
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    // if to change color of markers according to the department type
                    if([depart  containsString: @"Fire"])
                    {
                        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                        marker.map = self.mapView;
                        marker.title = name;
                        marker.snippet = depart;
                        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                    }
                }
    
            }
            
            
            break;
            case 3:
            if (appDelegate.isPressed6 == true || appDelegate.isPressed2 == true || appDelegate.isPressed4 == true || appDelegate.isPressed5 == true)
            {
            for (int i = 0; i < _assetData.count; i++)
            {
                _assets = [_assetData objectAtIndex:i];
                NSNumber* lat = [_assets objectForKey:@"Latitude"];
                double xlat = [lat doubleValue];
                NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                double xlongitude = [longitude doubleValue];
                NSString *name = [_assets objectForKey:@"Name"];
                NSString *depart = [_assets objectForKey:@"Department"];
                GMSMarker *marker = [[GMSMarker alloc] init];
                // if to change color of markers according to the department type
                if([depart  containsString: @"Police"])
                {
                    marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                    marker.map = self.mapView;
                    marker.title = name;
                    marker.snippet = depart;
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
                }
            }
            }
            else
            {
                [_mapView clear];
                for (int i = 0; i < _assetData.count; i++)
                {
                    _assets = [_assetData objectAtIndex:i];
                    NSNumber* lat = [_assets objectForKey:@"Latitude"];
                    double xlat = [lat doubleValue];
                    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                    double xlongitude = [longitude doubleValue];
                    NSString *name = [_assets objectForKey:@"Name"];
                    NSString *depart = [_assets objectForKey:@"Department"];
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    // if to change color of markers according to the department type
                    if([depart  containsString: @"Police"])
                    {
                        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                        marker.map = self.mapView;
                        marker.title = name;
                        marker.snippet = depart;
                        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
                    }
                }

            }
            break;
            case 4:
            if (appDelegate.isPressed6 == true || appDelegate.isPressed3 == true || appDelegate.isPressed2 == true || appDelegate.isPressed5 == true)
            {
            for (int i = 0; i < _assetData.count; i++)
            {
                _assets = [_assetData objectAtIndex:i];
                NSNumber* lat = [_assets objectForKey:@"Latitude"];
                double xlat = [lat doubleValue];
                NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                double xlongitude = [longitude doubleValue];
                NSString *name = [_assets objectForKey:@"Name"];
                NSString *depart = [_assets objectForKey:@"Department"];
                GMSMarker *marker = [[GMSMarker alloc] init];
                // if to change color of markers according to the department type
                if([depart  containsString: @"FBI"])
                {
                    marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                    marker.map = self.mapView;
                    marker.title = name;
                    marker.snippet = depart;
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
                }
            }
            }
            else
            {
                [_mapView clear];
                for (int i = 0; i < _assetData.count; i++)
                {
                    _assets = [_assetData objectAtIndex:i];
                    NSNumber* lat = [_assets objectForKey:@"Latitude"];
                    double xlat = [lat doubleValue];
                    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                    double xlongitude = [longitude doubleValue];
                    NSString *name = [_assets objectForKey:@"Name"];
                    NSString *depart = [_assets objectForKey:@"Department"];
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    // if to change color of markers according to the department type
                    if([depart  containsString: @"FBI"])
                    {
                        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                        marker.map = self.mapView;
                        marker.title = name;
                        marker.snippet = depart;
                        marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
                    }
                }
            }
            break;
            case 5:
            if (appDelegate.isPressed6 == true || appDelegate.isPressed3 == true || appDelegate.isPressed2 == true || appDelegate.isPressed4 == true)
            {

            for (int i = 0; i < _assetData.count; i++)
            {
                _assets = [_assetData objectAtIndex:i];
                NSNumber* lat = [_assets objectForKey:@"Latitude"];
                double xlat = [lat doubleValue];
                NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                double xlongitude = [longitude doubleValue];
                NSString *name = [_assets objectForKey:@"Name"];
                NSString *depart = [_assets objectForKey:@"Department"];
                GMSMarker *marker = [[GMSMarker alloc] init];
                // if to change color of markers according to the department type
                if([depart  containsString: @"EMS"])
                {
                    marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                    marker.map = self.mapView;
                    marker.title = name;
                    marker.snippet = depart;
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                }
            }
            }
            else
            {
                [_mapView clear];
                for (int i = 0; i < _assetData.count; i++)
                {
                    _assets = [_assetData objectAtIndex:i];
                    NSNumber* lat = [_assets objectForKey:@"Latitude"];
                    double xlat = [lat doubleValue];
                    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                    double xlongitude = [longitude doubleValue];
                    NSString *name = [_assets objectForKey:@"Name"];
                    NSString *depart = [_assets objectForKey:@"Department"];
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    // if to change color of markers according to the department type
                    if([depart  containsString: @"EMS"])
                    {
                        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                        marker.map = self.mapView;
                        marker.title = name;
                        marker.snippet = depart;
                        marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                    }
                }

            }
            break;
            case 6:
            if (appDelegate.isPressed5 == true || appDelegate.isPressed3 == true || appDelegate.isPressed2 == true || appDelegate.isPressed4 == true)
            {
            for (int i = 0; i < _assetData.count; i++)
            {
                _assets = [_assetData objectAtIndex:i];
                NSNumber* lat = [_assets objectForKey:@"Latitude"];
                double xlat = [lat doubleValue];
                NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                double xlongitude = [longitude doubleValue];
                NSString *name = [_assets objectForKey:@"Name"];
                NSString *depart = [_assets objectForKey:@"Department"];
                GMSMarker *marker = [[GMSMarker alloc] init];
                // if to change color of markers according to the department type
                if([depart  containsString: @"EPA"])
                {
                    marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                    marker.map = self.mapView;
                    marker.title = name;
                    marker.snippet = depart;
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
                }
            }
            }
            else
            {
                [_mapView clear];
                for (int i = 0; i < _assetData.count; i++)
                {
                    _assets = [_assetData objectAtIndex:i];
                    NSNumber* lat = [_assets objectForKey:@"Latitude"];
                    double xlat = [lat doubleValue];
                    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
                    double xlongitude = [longitude doubleValue];
                    NSString *name = [_assets objectForKey:@"Name"];
                    NSString *depart = [_assets objectForKey:@"Department"];
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    // if to change color of markers according to the department type
                    if([depart  containsString: @"EPA"])
                    {
                        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
                        marker.map = self.mapView;
                        marker.title = name;
                        marker.snippet = depart;
                        marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
                    }
                }

            }
            break;
        
            
        default:
            break;
    }


}

-(NSMutableArray *)objectHolderArray{
    if(!_assetData) _assetData = [[NSMutableArray alloc]init];
    return _assetData;
}
#pragma Fetch

-(void)fetchAssestData
{
    
    NSLog(@"Url Text box %@",_setViewController.url.text);
    
    NSString *url = @"http://groupq.cs.wright.edu/test.php";
;
    //http://groupq.cs.wright.edu/test.php
    NSError *error = nil;
    NSURL *assestURL = [NSURL URLWithString:url];
    NSData *jsonData = [NSData dataWithContentsOfURL:assestURL];
    
    if(jsonData != nil)
    {
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if ([dataDictionary isKindOfClass:[NSDictionary class]])
        {
            // Process the object as a dictionary
            _assetData = [dataDictionary objectForKey:@"assets"];
        }
        
        else
        {
            //Do nothing
        }
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable"
                                                        message:@"App content may be limited without a network connection. Please Check Connection."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    

    
    NSLog(@"Fetched Data");
    
}

//////////////////////////////////////////////////////////////////////////
// Code to make text scroll in the urgent message when message is to long
//////////////////////////////////////////////////////////////////////////
- (void)scrollText
{
    self.urgentMessage.textColor = [UIColor blackColor];
    self.urgentMessage.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.urgentMessage.textAlignment = NSTextAlignmentCenter;
    self.urgentMessage.font = [UIFont boldSystemFontOfSize:18];
    self.urgentMessage.pauseInterval = 1.2;
    self.urgentMessage.fadeLength = 0;
    self.urgentMessage.text = @"Urgent Messages: This is a test to verify that auto scrolling is working correctly";
    [self.urgentMessage observeApplicationNotifications];
}

- (void)googleMapsInit
{
       //get inital position of assests
    _assets = [_assetData objectAtIndex:0 + 2];
    NSNumber* lat = [_assets objectForKey:@"Latitude"];
    double xlat = [lat doubleValue];
    NSNumber* longitude = [_assets objectForKey:@"Longitude"];
    double xlongitude = [longitude doubleValue];
    
    int zoom = 10;
    
    if(_assetData.count <= 100)
    {
         zoom = 15;
          NSLog(@"Less than 100 assets");
    }
    else if (_assetData.count >= 100)
    {
         zoom = 12;
        NSLog(@"More than 100 assets");
    }
    else if (_assetData.count >= 500)
    {
         zoom = 8;
        NSLog(@"More than 500 assets");
    }

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:xlat longitude:xlongitude zoom:zoom];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    NSLog(@"User's location: %@", self.mapView.myLocation);
    self.mapView.mapType = kGMSTypeHybrid;
    self.view = self.mapView;
    
    //Red fire
    //Blue police
    //white ems
    //black fbi
    for (int i = 0; i < _assetData.count; i++)
    {
        _assets = [_assetData objectAtIndex:i];
        NSNumber* lat = [_assets objectForKey:@"Latitude"];
        double xlat = [lat doubleValue];
        NSNumber* longitude = [_assets objectForKey:@"Longitude"];
        double xlongitude = [longitude doubleValue];
        NSString *name = [_assets objectForKey:@"Name"];
        NSString *depart = [_assets objectForKey:@"Department"];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
        marker.map = self.mapView;
        marker.title = name;
        marker.snippet = depart;
        // if to change color of markers according to the department type
        if([depart containsString: @"Fire"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        }
        else if ([depart containsString: @"Police"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        }
        else if ([depart containsString: @"EMS"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        }
        else if ([depart containsString: @"FBI"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
        }
        else
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
        }
        
    }
    
}


- (void)googleMapsUpdate:(NSTimer*) t
{
    
    [_mapView clear];
    [self fetchAssestData];
    
    for (int i = 0; i < _assetData.count; i++)
    {
        _assets = [_assetData objectAtIndex:i];
        NSNumber* lat = [_assets objectForKey:@"Latitude"];
        double xlat = [lat doubleValue];
        NSNumber* longitude = [_assets objectForKey:@"Longitude"];
        double xlongitude = [longitude doubleValue];
        NSString *name = [_assets objectForKey:@"Name"];
        NSString *depart = [_assets objectForKey:@"Department"];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(xlat , xlongitude);
        marker.map = self.mapView;
        marker.title = name;
        marker.snippet = depart;
        // if to change color of markers according to the department type
        if([depart  containsString: @"Fire"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        }
        else if ([depart  containsString: @"Police"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        }
        else if ([depart  containsString: @"EMS"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        }
        else if ([depart  containsString: @"FBI"])
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
        }
        else
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
        }

        
    }
    
    NSLog(@"Updated the map");
    
    
    
}


- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView {
       NSLog(@"Hello");
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
