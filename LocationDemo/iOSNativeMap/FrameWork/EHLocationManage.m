//
//  EHLocationManage.m
//  EHProject
//
//  Created by Tim on 11/8/14.
//  Copyright (c) 2014 Everhomes. All rights reserved.
//

#import "EHLocationManage.h"
#import "CLLocation+Sino.h"
//#import "EHDevice.h"
//#import "EHCommonLogger.h"
extern int CommonLogLevel;

@interface EHLocationManage ()
<CLLocationManagerDelegate,
UIAlertViewDelegate>
@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, copy) locateSuccess nowLocateSuccess;
@property (nonatomic, copy) locateFailed nowLocateFailed;
@property (nonatomic, assign) CoordinateType coordinateType;
@property (nonatomic, assign) HorizonAccuracy horizonAccuracy;

@end

@implementation EHLocationManage


+ (instancetype)shareLocateionManage{
    
    static dispatch_once_t oneToken;
    static EHLocationManage *shareManage = nil;
    dispatch_once(&oneToken, ^{
        
        shareManage = [[EHLocationManage alloc] init];
    });
    
    return shareManage;
    
}


- (id)init
{
    
    if (self = [super init]) {
        
        _locManager = [[CLLocationManager alloc] init];
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.distanceFilter = 5.0;
        _locManager.delegate = self;
        
    }
    return self;
}


- (void)getCurrentCoordinate:(CoordinateType)coordinateType
                     horizon:(HorizonAccuracy)horizonAccuracy
                     success:(locateSuccess)locateSuccess
                      failed:(locateFailed)locateFailed
{
    self.nowLocateSuccess = locateSuccess;
    self.nowLocateFailed = locateFailed;
    self.coordinateType = coordinateType;
    self.horizonAccuracy = horizonAccuracy;
    [self.locManager setDelegate:self];
    
        
    [self.locManager performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
        
    
    [self.locManager startUpdatingLocation];
    
}

- (void)successLocate:(double)lat lng :(double)lng{
    
    
    CLLocation *earthLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLLocation *resultLocation = nil;
    switch (self.coordinateType) {
        case CoordinateTypeWGS84:
        {
            resultLocation = earthLocation;
        }
            break;
        case CoordinateTypeGCJ02:
        {
            resultLocation = [earthLocation locationMarsFromEarth];
        }
            break;
        case CoordinateTypeBD09:
        {
            resultLocation = [[earthLocation locationMarsFromEarth] locationBearPawFromMars];
        }
            break;
        default:
        {
            resultLocation = [[earthLocation locationMarsFromEarth] locationBearPawFromMars];
        }
            break;
    }

    if (!self.nowLocateSuccess) return ;
    
    
    if (self.nowLocateSuccess) {
        self.nowLocateSuccess(resultLocation.coordinate.latitude, resultLocation.coordinate.longitude);
        self.nowLocateSuccess = nil;
        self.nowLocateFailed = nil;
    }
    
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
//    CommonLogVerbose(@"long = %f latitude = %f" , newLocation.coordinate.longitude , newLocation.coordinate.latitude);
    [_locManager stopUpdatingLocation];
    _locManager.delegate = nil;
    [self successLocate:newLocation.coordinate.latitude lng:newLocation.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations lastObject];
    
    [_locManager stopUpdatingLocation];
    _locManager.delegate = nil ;
//    CommonLogVerbose(@"long = %f latitude = %f" , location.coordinate.longitude , location.coordinate.latitude);
    [self successLocate:location.coordinate.latitude lng:location.coordinate.longitude];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (_nowLocateFailed)
    {
        _nowLocateFailed(error);
        _nowLocateSuccess = nil;
        _nowLocateFailed = nil;
    }
    if (_needShowMessage)
    {
        if (![CLLocationManager locationServicesEnabled])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备未开启定位服务，请在iPhone的“设置-隐私-定位服务”选项中确认打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
        {
            [_locManager performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
        }
        else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备未开启定位服务，请手动打开" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"去设置", nil];
                [alertView show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
@end
