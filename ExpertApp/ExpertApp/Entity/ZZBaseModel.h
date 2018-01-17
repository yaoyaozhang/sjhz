//
//  ZZBaseModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZZEditControlType) {
    ZZEditControlTypeTextField       = 1,
    ZZEditControlTypeDoubleTextField = 2,
    ZZEditControlTypeTextView        = 3,
    ZZEditControlTypeButton          = 4,
    ZZEditControlTypeChoose          = 5,
    ZZEditControlTypeSex             = 6,
    ZZEditControlTypeDelImag         = 7,
    ZZEditControlTypeAddPic          = 8,
};



@interface ZZBaseModel : NSObject

-(id)initWithMyDict:(NSDictionary *) dict;

@end
