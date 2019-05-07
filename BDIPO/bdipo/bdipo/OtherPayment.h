//
//  OtherPayment.h
//  bdipo
//
//  Created by Nascenia on 4/17/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherPayment : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property NSString *paymentType;
@property NSString *paymentCost;
@property NSString *invoiceId;
@end
