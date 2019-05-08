//
//  AlertController.m
//  Meeting Mate
//
//  Created by nuibb on 8/5/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import "AlertController.h"

@implementation AlertController

-(void) downloadPdfFile {
    NSLog(@"Downloading...");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _alertController = [UIAlertController alertControllerWithTitle:@"Do you want to download this pdf file ?" message:@"something.pdf" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *download = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
            [self performSelector:@selector(downloadPdfFile) withObject:nil];
        }];
        
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [_alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [_alertController addAction:download];
        [_alertController addAction:cancel];
        
        //_actionSheetController.view.tintColor = [UIColor blackColor];
    }
    
    return self;
}

- (UIAlertController *) showAlertForPdfDownload {
    return _alertController;
}

@end
