//
//  CommonUtils.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




#define F_RELEASE(__p) {if(__p!=nil){[__p release]; __p=nil;}}

#define LOCALIZE(__p) NSLocalizedString(__p, @"")

#define DegreesToRadians(__p) __p * M_PI / 180
#define RadiansToDegrees(__p) __p * 180/M_PI

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define NSStringFromBOOL(aBOOL)    aBOOL? @"YES" : @"NO"
#define kNavigationBkgTag 1234

#define kCornerRadius 10

#define kPopUpParentViewTag         99999
//CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};


@interface UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)scaleToMaxWidth:(float)maxWidth 
                   maxHeight:(float) maxHeight;

- (UIImage *)roundCornerTo:(float)radius;


@end

@interface CommonUtils : NSObject <UIPrintInteractionControllerDelegate>{
    
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)path;
+ (NSString *)pathForSourceFile:(NSString *)file inDirectory:(NSString *)directory skipICloudBackup:(BOOL)skipBackup;
+ (NSString *)pathForSourceFile:(NSString *)file inDirectory:(NSString *)directory;
+ (NSString *)pathLibraryForSourceFile:(NSString *)file inDirectory:(NSString *)directory;
+ (NSString *)pathCacheForSourceFile:(NSString *)file inDirectory:(NSString *)directory;
+ (NSString *)pathTmpForSourceFile:(NSString *)file inDirectory:(NSString *)directory;
+ (void)cleanTempFolder;

+ (NSString *)fullPathFromFile:(NSString *)path;
+ (void) openURLExternalHandlerForLink: (NSString *) urlLink;
+ (void) copyFilePlistIfNeccessaryForFileName: (NSString *) filename withFileType:(NSString *)fileType;

+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle;

+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle 
              otherButtonTitles: (NSString *) otherButtonTitles, ...;

+ (void) showAlertViewWithTag: (NSInteger) tag 
                     delegate:(id) delegate 
                    withTitle: (NSString *) title 
                      message:(NSString*)msg 
            cancelButtonTitle:(NSString*)cancelTitle 
            otherButtonTitles: (NSString *) otherButtonTitles, ... ;



+ (BOOL) isDeviceSupportMultitasking;
+ (BOOL) isIOS5OrGreater;
+ (BOOL) isIOS5O1rGreater;
+ (BOOL) isIOS51rGreater;

+ (void) showNetworkIndicator;
+ (void) hideNetworkIndicator;

+ (void) startIndicatorDisableViewController: (UIViewController *) viewController ;
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController ;

+ (void) startIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable ;
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable;


+ (void)blurViewController:(UIViewController *)viewController;
+ (void)blurViewController:(UIViewController *)viewController withColor:(UIColor *)color withAlpha:(CGFloat)alpha;
+ (void)removeBlurViewController:(UIViewController *)viewController;

+ (NSString *) getBundleVersion;

+ (NSString*) loadHTMLfile: (NSString *) fileName; 


+ (UIImage*)loadLocalImage:(NSString*)fileName;

+ (NSString *)getSafeValueForKey:(NSString *)key inDictionary:(NSDictionary *)dict;

+ (NSString *)convertToDateTimeFrom:(NSInteger)value;

+ (BOOL)appCanOpenURL:(NSString *)url;



+ (BOOL)validateEmail:(NSString *)email;

+ (UIImage *)captureImageFromView:(UIView *)view;

+ (UIImage *)captureImageFromView:(UIView *)view inFrame:(CGRect )captureFrame;

+ (NSString *)applicationDocumentsDirectory;
+ (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
+ (CGFloat) distanceFromPoint:(CGPoint)src toPoint:(CGPoint)desc;
+ (BOOL) existingOfFileWithName:(NSString*)name;
+ (NSString*) documentPathForFile:(NSString*)fileName;
+ (NSString*) bundlePathWithFile:(NSString*)fileName;
+ (NSInteger) percentFrom:(NSInteger)from to:(NSInteger)to;

+ (void) printViewContent:(UIView*)view delegate:(id) printDelegate;

+ (void) printViewContent:(UIView*)view fromRect:(CGRect)rect inView:(UIView*)inView delegate:(id)delegate;

+ (void) printViewcontent:(UIView*)view fromBarButtonItem:(UIBarButtonItem*)barButton delegate:(id)delegate;

+ (NSString*) getElementValueFromWebView:(UIWebView*)webView byId:(NSString*)elementId;

+ (void) createEmailFromImageOfView:(UIView*)view matchName:(NSString*)matchName delegate:(id)delegate;

+ (void) displayOptionMenuWithFilePath:(NSString*)filePath fromRect:(CGRect)rect inView:(UIView*)view delegate:(id)delegate;

+ (void) displayOptionMenuFromBarButton:(UIBarButtonItem*)barButton filePath:(NSString*)filePath delegate:(id) delegate;

+ (NSString*) dateTimeStringWithDate:(NSDate*)date formatString:(NSString*)format;

+ (NSString*) convertFromFloat:(CGFloat)dateTime toDateTimeStringWithFormat:(NSString*)format;

+ (void) displayAlertWithTitle:(NSString*)title message:(NSString*)message cancelTitle:(NSString*)cancelTitle tag:(NSInteger)tag delegate:(id)delegate otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (void) createEmailFromImageOfView:(UIView*)view subject:(NSString*)subject matchName:(NSString*)matchName delegate:(id)delegate;
+ (void) displayPopUpWithContentView:(UIView*)contentView;
+ (void) dismissPopUpView;
+ (BOOL) canSendEmail;
@end
