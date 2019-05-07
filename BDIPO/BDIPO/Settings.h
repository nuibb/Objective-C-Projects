//
//  Settings.h
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
@property NSString *hostName;
@property NSString *token;
-(NSString *) getLogInUrl;
-(NSString *) getSignUpUrl;
-(NSString *) getSignUpUrlForTrialUser;
-(NSString *) getAllNews;
-(NSString *) getIPOResultsList;
-(NSString *) checkAuthorization:(NSString *)companyId;
-(NSString *) getCategoriesForSearch;
-(NSString *) getBankListForSearch;
-(NSString *) getBranchListForSearch;
-(NSString *) getSearchIPOResult;
-(NSString *) getUpcomingIPO;
-(NSString *) isForgetPassword:(NSString *)email;
-(NSString *) getForumUrl;
-(NSString *) getPaymentUrlWithInvoice:(NSString *)invoiceId methodName:(NSString *)method;
-(NSString *) getDBBLpaymentGateway;
-(NSString *) checkDBBLPayment:(NSString *) transectionId;
-(NSString *) getbKashPaymentUrl;
-(NSString *) getManualPaymentUrl;
-(NSString *) getUserAccount;
-(NSString *) getUserProfile;
-(NSString *) updateUserProfile;
@end
