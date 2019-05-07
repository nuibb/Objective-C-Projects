//
//  SearchIPOResult.h
//  bdipo
//
//  Created by Nascenia on 3/9/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowIPOResult.h"

@interface SearchIPOResult : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSString *cName;
@property (nonatomic, strong) NSString *companyId;
@end
