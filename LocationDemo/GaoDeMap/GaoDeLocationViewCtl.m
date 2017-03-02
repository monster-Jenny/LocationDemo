//
//  GaoDeLocationViewCtl.m
//  LocationDemo
//
//  Created by Monster on 2017/3/1.
//  Copyright © 2017年 Monster. All rights reserved.
//

#import "GaoDeLocationViewCtl.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface GaoDeLocationViewCtl ()
<AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) UILabel * label;

@end

@implementation GaoDeLocationViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
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
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUS_AND_NAV + 40, SCREEN_WIDTH, HEIGHT_NO_STATUS_NAV - 40)];
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
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocation:(UIButton *)sender
{
    [self.locationManager startUpdatingLocation];
}


#pragma mark - Delegate
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
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

/**
 *  @brief 连续定位回调函数.注意：本方法已被废弃，如果实现了amapLocationManager:didUpdateLocation:reGeocode:方法，则本方法将不会回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{

}

/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.label.text = [NSString stringWithFormat:@"纬度是：%f ；经度是：%f",location.coordinate.latitude,location.coordinate.longitude];
}

/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{

}

/**
 *  @brief 开始监控region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 开始监控的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region{

}

/**
 *  @brief 进入region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 进入的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region{

}

/**
 *  @brief 离开region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 离开的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region{

}

/**
 *  @brief 查询region状态回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param state 查询的region的状态。
 *  @param region 查询的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didDetermineState:(AMapLocationRegionState)state forRegion:(AMapLocationRegion *)region{

}

/**
 *  @brief 监控region失败回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 失败的region。
 *  @param error 错误信息，参考 AMapLocationErrorCode 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager monitoringDidFailForRegion:(AMapLocationRegion *)region withError:(NSError *)error
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
