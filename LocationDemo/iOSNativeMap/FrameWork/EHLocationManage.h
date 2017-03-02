//
//  EHLocationManage.h
//  EHProject
//
//  Created by Tim on 11/8/14.
//  Copyright (c) 2014 Everhomes. All rights reserved.
//

#import <Foundation/Foundation.h>

//坐标系类型
typedef NS_ENUM(NSInteger, CoordinateType) {
    CoordinateTypeWGS84,//国际标准，GPS坐标（Google Earth使用、或者GPS模块）
    CoordinateTypeGCJ02,//中国坐标偏移标准，Google Map、高德、腾讯使用
    CoordinateTypeBD09,//百度坐标偏移标准，Baidu Map使用
};

//水平精度等级
typedef NS_ENUM(NSInteger, HorizonAccuracy) {
    HorizonAccuracy100,
    HorizonAccuracy2000,
    HorizonAccuracyAll,
};

//垂直精度等级
typedef NS_ENUM(NSInteger, VerticalAccuracy) {
    VerticalAccuracy100,
    VerticalAccuracy2000,
    VerticalAccuracyAlll,
};

typedef void(^locateSuccess)(double lat ,double lng);
typedef void(^locateFailed)();

@interface EHLocationManage : NSObject
@property (nonatomic, assign) BOOL needShowMessage;
+ (instancetype)shareLocateionManage;

///获取制定坐标系，精度的当前坐标
- (void)getCurrentCoordinate:(CoordinateType)coordinateType
                     horizon:(HorizonAccuracy)horizonAccuracy
                     success:(locateSuccess)locateSuccess
                      failed:(locateFailed)locateFailed;
@end
