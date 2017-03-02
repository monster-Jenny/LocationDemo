//
//  BaiDuLocationViewCtl.m
//  LocationDemo
//
//  Created by Monster on 2017/3/1.
//  Copyright © 2017年 Monster. All rights reserved.
//

#import "BaiDuLocationViewCtl.h"
#import <Masonry/View+MASShorthandAdditions.h>

@interface BaiDuLocationViewCtl ()
<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKLocationService * locationService;

@property (nonatomic, strong) BMKMapView * mapView;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) UILabel * horizontalAccuracyLabel;

@property (nonatomic, strong) UILabel * verticalAccuracyLabel;

@property (nonatomic, strong) UILabel * altitudeLabel;

@end

@implementation BaiDuLocationViewCtl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.locationService.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
    
    
////    self.mapView.delegate = self;
//    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(HEIGHT_STATUS_AND_NAV + 40);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//    self.mapView.showsUserLocation = NO;
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
//    self.mapView.showsUserLocation = YES;
    
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    self.locationService.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationService startUserLocationService];
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
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUS_AND_NAV + 40, SCREEN_WIDTH, HEIGHT_NO_STATUS_NAV - 40)];
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
    
    self.horizontalAccuracyLabel = [[UILabel alloc] init];
    self.horizontalAccuracyLabel.textColor = [UIColor redColor];
    self.horizontalAccuracyLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.horizontalAccuracyLabel];
    [self.horizontalAccuracyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.label.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH / 2.0));
        make.height.equalTo(@30);
    }];
    
    self.verticalAccuracyLabel = [[UILabel alloc] init];
    self.verticalAccuracyLabel.textColor = [UIColor redColor];
    self.verticalAccuracyLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.verticalAccuracyLabel];
    [self.verticalAccuracyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.label.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH / 2.0));
        make.height.equalTo(@30);
    }];
    
    self.altitudeLabel = [[UILabel alloc] init];
    self.altitudeLabel.textColor = [UIColor blackColor];
    self.altitudeLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.altitudeLabel];
    [self.altitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.horizontalAccuracyLabel.mas_top);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
}

- (void)startLocation:(UIButton *)sender
{
    [self.locationService startUserLocationService];
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
}

- (void)stopLocation:(UIButton *)sender
{
    [self.locationService stopUserLocationService];
}

#pragma mark - Delegate

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"willStartLocatingUser");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"didStopLocatingUser");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"didUpdateUserHeadingheading is %@",userLocation.heading);

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateBMKUserLocation");
    NSLog(@"当前位置信息：didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.label.text = [NSString stringWithFormat:@"纬度是：%f ；经度是：%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
    self.horizontalAccuracyLabel.text = [NSString stringWithFormat:@"horizontal：%f",userLocation.location.horizontalAccuracy];
    self.verticalAccuracyLabel.text = [NSString stringWithFormat:@"vertical：%f",userLocation.location.verticalAccuracy];
    self.altitudeLabel.text = [NSString stringWithFormat:@"altitude：%f",userLocation.location.altitude];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError");
    [self stopLocation:nil];
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备未开启定位服务，请在iPhone的“设置-隐私-定位服务”选项中确认打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [self.locationService performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        [self.locationService performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
