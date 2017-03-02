//
//  NativeLocationViewCtl.m
//  LocationDemo
//
//  Created by Monster on 2017/3/1.
//  Copyright © 2017年 Monster. All rights reserved.
//

#import "NativeLocationViewCtl.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CLLocation+Sino.h"

@interface NativeLocationViewCtl ()
<CLLocationManagerDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) MKMapView * mapView;

@property (nonatomic, strong) UILabel * label;

@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation NativeLocationViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备未开启定位服务，请在iPhone的“设置-隐私-定位服务”选项中确认打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UI
- (void)layoutUI
{
    
    UIButton * start = [[UIButton alloc] init];
    [self.view addSubview:start];
    [start setTitle:@"开始定位" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [start addTarget:self action:@selector(startLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(HEIGHT_STATUS_AND_NAV);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@40);
        make.width.equalTo(@(SCREEN_WIDTH/2.0));
    }];
    
    
    UIButton * stop = [[UIButton alloc] init];
    [self.view addSubview:stop];
    [stop setTitle:@"结束定位" forState:UIControlStateNormal];
    [stop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(stopLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [stop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(HEIGHT_STATUS_AND_NAV);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@40);
        make.width.equalTo(@(SCREEN_WIDTH/2.0));
    }];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUS_AND_NAV + 40, SCREEN_WIDTH, HEIGHT_NO_STATUS_NAV - 40)];
    [self.view addSubview:self.mapView];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor blackColor];
    self.label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
}

- (void)startLocation:(UIButton *)sender
{
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocation:(UIButton *)sender
{
    [self.locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    CLLocation *location = [locations lastObject];
    
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval locateTimeInterval = [location.timestamp timeIntervalSince1970];
    double timeInterval = ABS(currentTimeInterval-locateTimeInterval);
    
    //精度为0~100米，且时间为5分钟以内返回正确的定位位置
    if (location.horizontalAccuracy > 0 &&location.horizontalAccuracy<=100.0&&timeInterval<300)
    {
        [self stopLocation:nil];
        [self successLocateLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    [self stopLocation:nil];
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备未开启定位服务，请在iPhone的“设置-隐私-定位服务”选项中确认打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        [self.locationManager performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
    }
}

- (void)successLocateLatitude:(double)latitude andLongitude:(double)longitude
{
    CLLocation *earthLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *marsLocation = [earthLocation locationMarsFromEarth];
    CLLocation *bearPawLocation = [marsLocation locationBearPawFromMars];
    
    NSLog(@"火星坐标：%f,%f,百度坐标:%f,%f",marsLocation.coordinate.longitude,marsLocation.coordinate.latitude,bearPawLocation.coordinate.longitude,bearPawLocation.coordinate.latitude);
    self.label.text = [NSString stringWithFormat:@"纬度是：%f ；经度是：%f",bearPawLocation.coordinate.latitude,bearPawLocation.coordinate.longitude];
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
