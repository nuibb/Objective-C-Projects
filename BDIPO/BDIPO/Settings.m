//
//  Settings.m
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (id)init
{
    self = [super init];
    if (self) {
        _hostName = @"http://test.bdipo.com";
        //_hostName = @"http://192.168.1.183:3000";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
            _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        }
    }
    return self;
}

-(NSString *) getLogInUrl {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/users/sign_in.json"];
}

-(NSString *) getSignUpUrl {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/users/sign_up.json"];
}

-(NSString *) getSignUpUrlForTrialUser {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/users/sign_up_trial.json"];
}

-(NSString *) getCategoriesForSearch {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/companies/load_categories.json"];
}

-(NSString *) getAllNews {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/messages/news_update.json"];
}

-(NSString *) getIPOResultsList {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/companies/ipo_result.json"];
}

-(NSString *)checkAuthorization:(NSString *)companyId {
    return [NSString stringWithFormat:@"%@%@%@%@%@", _hostName, @"/api/v1/companies/authorize_to_see_search_result.json?company_id=", companyId, @"&auth_token=", _token];
}

-(NSString *) getBankListForSearch {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/companies/load_banks.json"];
}

-(NSString *) getBranchListForSearch {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/companies/load_branches.json"];
}

-(NSString *) getSearchIPOResult {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/companies/search_ipo_result"];
}

-(NSString *) getUpcomingIPO {
    return _token ? [NSString stringWithFormat:@"%@%@%@", _hostName, @"/api/v1/companies/upcoming_ipo.json?auth_token=", _token] : [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/companies/upcoming_ipo.json"];
}

-(NSString *) isForgetPassword:(NSString *)email {
    return [NSString stringWithFormat:@"%@%@%@", _hostName, @"/api/v1/users/reset_forgot_password.json?email=", email];
}

-(NSString *) getForumUrl {
    return @"http://www.bdipo.com/blog/faq/";
}

-(NSString *) getPaymentUrlWithInvoice:(NSString *)invoiceId methodName:(NSString *)method{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@", _hostName, @"/api/v1/payments/new.json?invoice_id=", invoiceId, @"&method=", [method isEqualToString:@"online"] ? @"dbbl-ecommerce" : method, @"&auth_token=", _token];
}

-(NSString *) getDBBLpaymentGateway {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/payments/dbbl_transaction.json"];
}

-(NSString *) checkDBBLPayment:(NSString *) transectionId {
    return [NSString stringWithFormat:@"%@%@%@", _hostName, @"/api/v1/payments/get_payment_status_for_dbbl_ecommerce.json?dbbl_transaction_id=", transectionId];
}

-(NSString *) getbKashPaymentUrl {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/payments/bkash_create.json"];
}

-(NSString *) getManualPaymentUrl {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/payments.json"];
}

-(NSString *) getUserAccount {
    return [NSString stringWithFormat:@"%@%@%@", _hostName, @"/api/v1/users/get_user_account_details.json?auth_token=", _token];
}

-(NSString *) getUserProfile {
    return [NSString stringWithFormat:@"%@%@%@", _hostName, @"/api/v1/users/get_user_profile_details.json?auth_token=", _token];
}

-(NSString *) updateUserProfile {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/api/v1/users/update_user_profile_details.json"];
}

@end
