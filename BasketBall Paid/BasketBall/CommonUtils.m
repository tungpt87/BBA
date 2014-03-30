//
//  CommonUtils.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include <sys/xattr.h>

#import "CommonUtils.h"

#import "Constants.h"
#import "BBAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@implementation UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size ;
{

	// Create a bitmap graphics context
	// This will also set it as the current context
	UIGraphicsBeginImageContext(size);
	
	// Draw the scaled image in the current context
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// Create a new image from current context
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Pop the current context from the stack
	UIGraphicsEndImageContext();
	
	// Return our new scaled image
	return scaledImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{   
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox;
    
    if (!(degrees == 180.0 || degrees == 360.0 || degrees == 0.0))
        rotatedViewBox= [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    else
        rotatedViewBox= [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.height, self.size.width)];
    
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)scaleToMaxWidth:(float)maxWidth 
                   maxHeight:(float) maxHeight
{
	if(self != nil)
	{
		CGImageRef imgRef = self.CGImage;
		CGFloat width = CGImageGetWidth(imgRef);
		CGFloat height = CGImageGetHeight(imgRef);
		UIImageOrientation    originalOrientation = self.imageOrientation;
        switch (originalOrientation) 
		{
			case UIImageOrientationUp:
			{
			}
				break;
			case UIImageOrientationDown:
			{
			}
				break;
			case UIImageOrientationLeft:
			{
				height = CGImageGetWidth(imgRef);
				width = CGImageGetHeight(imgRef);
			}
				break;
			case UIImageOrientationRight:
			{
				height = CGImageGetWidth(imgRef);
				width = CGImageGetHeight(imgRef);
			}
				break;
			case UIImageOrientationUpMirrored:
			{
			}
				break;
			case UIImageOrientationDownMirrored:
			{
			}
				break;
			case UIImageOrientationLeftMirrored:
			{
			}
				break;
			case UIImageOrientationRightMirrored:
			{
			}
				break;
			default:
			{
			}
				break;
		}
		CGRect bounds = CGRectMake(0, 0, width, height);
		
		CGFloat ratio = width/height;
		CGFloat maxRatio = maxWidth/maxHeight;
		
		if(ratio > maxRatio)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
		
		//NSLog(@"after resize:%f,%f:",bounds.size.width,bounds.size.height);
		return [self scaleToSize:bounds.size];
	}
	return nil;
}

-(UIImage *)roundCornerTo:(float)radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    imageLayer.contents = (id) self.CGImage;
    
    imageLayer.backgroundColor = [[UIColor clearColor] CGColor];
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(self.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}
//
//- (UIImage *)roundCornerTo:(float)radius;
//{
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
//    CALayer *layer = [CALayer layer];
//    layer = [imageView layer];
//    
//    layer.masksToBounds = YES;
//    layer.cornerRadius = radius;
//    
//    UIGraphicsBeginImageContext(imageView.bounds.size);
//    [layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return roundedImage;
//}


@end

#define RECT_TAG 1421
#define SPIN_TAG 4516

@implementation CommonUtils

#pragma File handler

+ (UIImage*)loadLocalImage:(NSString*)fileName{
    //TODO
    return [UIImage imageWithContentsOfFile:fileName];
}

/*
 set the document files attribute to marked "do not backup"
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)path
{
    const char* filePath = [path fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


+ (NSString *)pathForSourceFile:(NSString *)file inDirectory:(NSString *)directory skipICloudBackup:(BOOL)skipBackup
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *path = nil;
	if(directory == nil)
	{
		path = [documentsDirectory stringByAppendingPathComponent:file];
	}
	else
	{
		// if folder not exist, it will be created
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:directory];
		
		// create particular directory
		BOOL success = [fileManager createDirectoryAtPath:directoryPath
							  withIntermediateDirectories:YES
											   attributes:nil 
													error:NULL];
		
		if(success)
		{
			path = [directoryPath stringByAppendingPathComponent:file];
		}
	}
    
    if (skipBackup) {
        // Set do not backup attribute to file
        if ([CommonUtils isIOS5O1rGreater]) {
            BOOL success = [self addSkipBackupAttributeToItemAtURL:path];
            if (success) 
                NSLog(@"Marked %@", path);
            else
                NSLog(@"Can't marked %@", path);
        }
    }
    	
	return path;
}

+ (NSString *)pathForSourceFile:(NSString *)file inDirectory:(NSString *)directory
{
	return [CommonUtils pathForSourceFile:file inDirectory:directory skipICloudBackup:FALSE];
}



+ (NSString *)pathLibraryForSourceFile:(NSString *)file inDirectory:(NSString *)directory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); 
	NSString *libDirectory = [paths objectAtIndex:0]; // Get Library directory
	
	NSString *path = nil;
	if(directory == nil)
	{
		path = [libDirectory stringByAppendingPathComponent:file];
	}
	else
	{
		// if folder not exist, it will be created
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *directoryPath = [libDirectory stringByAppendingPathComponent:directory];
		
		// create particular directory
		BOOL success = [fileManager createDirectoryAtPath:directoryPath
							  withIntermediateDirectories:YES
											   attributes:nil 
													error:NULL];
		
		if(success)
		{
			path = [directoryPath stringByAppendingPathComponent:file];
		}
	}
	
	return path;
}

+ (NSString *)pathCacheForSourceFile:(NSString *)file inDirectory:(NSString *)directory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cacheDirectory = [paths objectAtIndex:0]; // Get Library directory
	
	NSString *path = nil;
	if(directory == nil)
	{
		path = [cacheDirectory stringByAppendingPathComponent:file];
	}
	else
	{
		// if folder not exist, it will be created
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *directoryPath = [cacheDirectory stringByAppendingPathComponent:directory];
		
		// create particular directory
		BOOL success = [fileManager createDirectoryAtPath:directoryPath
							  withIntermediateDirectories:YES
											   attributes:nil 
													error:NULL];
		
		if(success)
		{
			path = [directoryPath stringByAppendingPathComponent:file];
		}
	}
	
	return path;
}

+ (NSString *)pathTmpForSourceFile:(NSString *)file inDirectory:(NSString *)directory
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSTemporaryDirectory(), NSUserDomainMask, YES); 
	NSString *tempDirectory = NSTemporaryDirectory();// [paths objectAtIndex:0]; // Get Library directory
	
	NSString *path = nil;
	if(directory == nil)
	{
		path = [tempDirectory stringByAppendingPathComponent:file];
	}
	else
	{
		// if folder not exist, it will be created
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *directoryPath = [tempDirectory stringByAppendingPathComponent:directory];
		
		// create particular directory
		BOOL success = [fileManager createDirectoryAtPath:directoryPath
							  withIntermediateDirectories:YES
											   attributes:nil 
													error:NULL];
		
		if(success)
		{
			path = [directoryPath stringByAppendingPathComponent:file];
		}
	}
	
	return path;
}

+ (void)cleanTempFolder;
{
    NSLog(@"did CALL cleanTempFolder");
    //delete tmp folder
    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSTemporaryDirectory(), NSUserDomainMask, YES); 
	NSString *tempDirectory = NSTemporaryDirectory(); // [paths objectAtIndex:0]; // Get tmp directory
    if ([fileMgr fileExistsAtPath:tempDirectory isDirectory:nil]) {
        NSArray *arrContent = [fileMgr contentsOfDirectoryAtPath:tempDirectory error:nil];
        if (arrContent && [arrContent count] > 0) {
            for (int i = 0; i < [arrContent count]; i++) {
                NSString *filePath = [arrContent objectAtIndex:i];
                filePath = [tempDirectory stringByAppendingPathComponent:filePath];
                NSLog(@"remove file: %@", filePath);
                //                filePath = [CommonUtils pathForSourceFile:filePath inDirectory:kTempFolderPreview];
                [fileMgr removeItemAtPath:filePath error:nil];
            }            
        } 
    }
}


+ (NSString *)fullPathFromFile:(NSString *)path
{
	if(path)
	{
		NSArray *components = [path componentsSeparatedByString:@"."];
		
		if([components count] > 1)
		{
			NSString *resourcePath =
			[[NSBundle mainBundle] pathForResource:[components objectAtIndex:0] 
											ofType:[components objectAtIndex:1]];
			
			return resourcePath;
		}
	}
	return nil;
}


#pragma Custom methods
+ (void) openURLExternalHandlerForLink: (NSString *) urlLink;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlLink]];
}
#pragma App settings plist handler
+ (void) copyFilePlistIfNeccessaryForFileName: (NSString *) filename withFileType:(NSString *)fileType;
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.%@", filename,fileType]]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:filename ofType:fileType]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
}



#pragma -
#pragma Alertview 

// Method used to show alert view with Title, message content and cancel button title
+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle;
{
	
    UIAlertView *alertView = [[[UIAlertView alloc] 
                               initWithTitle:title 
                               message:msg 
                               delegate:self 
                               cancelButtonTitle:cancelTitle 
                               otherButtonTitles:nil] autorelease];
    [alertView show];    
}

// Method used to show alert view with Title, message content and cancel button title
+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle 
              otherButtonTitles: (NSString *) otherButtonTitles, ...
{
    // traditional alertview
    
    UIAlertView *alertView = [[[UIAlertView alloc]  init] autorelease];
    
    alertView.title = title;
    alertView.message = msg;
    alertView.delegate = self;
    
    if (cancelTitle != nil) {
        [alertView addButtonWithTitle:cancelTitle];
        alertView.cancelButtonIndex = 0;
    }
    
    if (otherButtonTitles != nil) {
        [alertView addButtonWithTitle: otherButtonTitles ];
        
        va_list args;
        va_start(args, otherButtonTitles);
        
        id arg;
        while ( nil != ( arg = va_arg( args, id ) ) ) 
        {
            if ( ![arg isKindOfClass: [NSString class] ] )
                break;
            
            [alertView addButtonWithTitle: (NSString*)arg ];
        }
        
    }
    
    [alertView show];
}

// Method used to show alert view with Title, message content and cancel button title
+ (void) showAlertViewWithTag: (NSInteger) tag 
                     delegate:(id) delegate 
                    withTitle: (NSString *) title 
                      message:(NSString*)msg 
            cancelButtonTitle:(NSString*)cancelTitle 
            otherButtonTitles: (NSString *) otherButtonTitles, ... ;
{
    // traditional alertview
    UIAlertView *alertView = [[[UIAlertView alloc]  init] autorelease];
    
    alertView.title = title;
    alertView.message = msg;
    alertView.delegate = delegate;
    alertView.tag = tag;
    
    if (cancelTitle != nil) {
        [alertView addButtonWithTitle:cancelTitle];
        alertView.cancelButtonIndex = 0;
    }
    
    if (otherButtonTitles != nil) {
        [alertView addButtonWithTitle: otherButtonTitles ];
        
        va_list args;
        va_start(args, otherButtonTitles);
        
        id arg;
        while ( nil != ( arg = va_arg( args, id ) ) ) 
        {
            if ( ![arg isKindOfClass: [NSString class] ] )
                break;
            
            [alertView addButtonWithTitle: (NSString*)arg ];
        }
        
    }
    
    [alertView show];
    
}


// Function to check if device support multitasking
// Return: TRUE if device supports multitasking, otherwise return NO
+ (BOOL) isDeviceSupportMultitasking;
{
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }
    
    //NSLog(@"support multitasking: %d ", backgroundSupported);
    return backgroundSupported;
}

+ (BOOL) isIOS5OrGreater;
{
    /* [[UIDevice currentDevice] systemVersion] returns "4.0", "3.1.3" and so on. */
    NSString* ver = [[UIDevice currentDevice] systemVersion];
    //    NSLog(@"Check ios410 %@",ver);
    /* I assume that the default iOS version will be 4.0, that is why I set this to 4.0 */
    float version = 5.0;
    
    if ([ver length]>=3)
    {
        /*
         The version string has the format major.minor.revision (eg. "3.1.3").
         I am not interested in the revision part of the version string, so I can do this.
         It will return the float value for "3.1", because substringToIndex is called first.
         */
        version = [[ver substringToIndex:3] floatValue];
    }
    return (version >= 5.0);
}

+ (BOOL) isIOS5O1rGreater;
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0.1"); 
}

+ (BOOL) isIOS51rGreater;
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1"); 
}


#pragma Network indicator show/hide animation
// Method used to show network indicator (top bar of device) animating while loading from server
+ (void) showNetworkIndicator;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// Method used to stop network indicator (top bar of device) animating after data is loaded successuflly
+ (void) hideNetworkIndicator;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// start indicator animation with black screen
// Edited by DatNT 07/05/2011
// Purpose: add autosizing and contentMode, to auto resizing and center indicator when displaying Loading screen
+ (void) startIndicatorDisableViewController: (UIViewController *) viewController ;
{
    CGRect parentFrame = viewController.view.frame;
    if ([viewController.view viewWithTag:RECT_TAG] != nil) {
        return;
    }
    
    UIView* blackRect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    blackRect.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blackRect.contentMode = UIViewContentModeScaleToFill;
	blackRect.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	blackRect.tag = RECT_TAG;
	[[viewController view] addSubview:blackRect];
    
	UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinny.tag = SPIN_TAG;
	spinny.center = CGPointMake(parentFrame.size.width/2,parentFrame.size.height/2);
    spinny.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    spinny.contentMode = UIViewContentModeCenter;
    [spinny startAnimating];
    [viewController.view addSubview:spinny];
    
    if (spinny) {
        [spinny release];
    }
    
    if (blackRect) {
        [blackRect release];
    }
}

// stop indicator animation with black screen
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController ;
{
    UIView *spinny = [viewController.view viewWithTag:SPIN_TAG];
    [spinny removeFromSuperview];
    UIView *blk = [viewController.view viewWithTag:RECT_TAG];
    [blk removeFromSuperview];
}

+ (void) startIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable ;
{
    UIView *mainView = (disable) ? viewController.navigationController.view : viewController.view;
    CGRect parentFrame = mainView.frame;
    if ([mainView viewWithTag:RECT_TAG] != nil) {
        return;
    }
    
    UIView* blackRect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    blackRect.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blackRect.contentMode = UIViewContentModeScaleToFill;
	blackRect.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	blackRect.tag = RECT_TAG;
	[mainView addSubview:blackRect];
    
	UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinny.tag = SPIN_TAG;
	spinny.center = CGPointMake(parentFrame.size.width/2,parentFrame.size.height/2);
    spinny.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    spinny.contentMode = UIViewContentModeCenter;
    [spinny startAnimating];
    [mainView addSubview:spinny];
    
    if (spinny) {
        [spinny release];
    }
    
    if (blackRect) {
        [blackRect release];
    }
}

// stop indicator animation with black screen
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable;
{
    UIView *mainView = (disable) ? viewController.navigationController.view : viewController.view;
    
    UIView *spinny = [mainView viewWithTag:SPIN_TAG];
    [spinny removeFromSuperview];
    UIView *blk = [mainView viewWithTag:RECT_TAG];
    [blk removeFromSuperview];
}

+ (void)blurViewController:(UIViewController *)viewController;
{
    UIView *blurview = (UIView *)[viewController.navigationController.view viewWithTag:123];
    if (blurview == nil) {
        blurview = [[[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]]autorelease];
        blurview.tag = 123;
        blurview.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.7f];
        
        [viewController.navigationController.view addSubview:blurview];
    }
}

+ (void)blurViewController:(UIViewController *)viewController withColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    UIView *blurview = (UIView *)[viewController.navigationController.view viewWithTag:123];
    if (blurview == nil) {
        blurview = [[[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]]autorelease];
        blurview.tag = 123;
        blurview.backgroundColor = color;
        blurview.alpha = alpha;
        
        [viewController.navigationController.view addSubview:blurview];
    }
    
}

+ (void)removeBlurViewController:(UIViewController *)viewController
{
    UIView *blurview = (UIView *)[viewController.navigationController.view viewWithTag:123];
    if (blurview != nil) {
        [blurview removeFromSuperview];
    }
}

+ (NSString *) getBundleVersion;
{
    return [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}


// Method used to get app setting value by setting key
+ (NSString*) loadHTMLfile: (NSString *) fileName; 
{
    NSString *path = [CommonUtils fullPathFromFile:[NSString stringWithFormat: @"%@", fileName]];
    
    NSError *error;
    NSString * value = [[NSString alloc] initWithContentsOfFile:path 
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    
    return [value autorelease];
    // End DatNT8
    
}

+ (void) changeNagBarFor:(UIViewController *)viewController bkgImage: (NSString *)img
{
    //load navbar background  
    UIImageView *bkgNav = (UIImageView *)[viewController.navigationController.navigationBar viewWithTag:kNavigationBkgTag];
    
    if (bkgNav != nil) {
        [bkgNav removeFromSuperview];
    }
    
    bkgNav = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:img]] autorelease];
    
    bkgNav.tag = kNavigationBkgTag;
    [viewController.navigationController.navigationBar insertSubview:bkgNav atIndex:([CommonUtils isIOS5OrGreater]) ? 1 : 0];
}

+ (NSString *)getSafeValueForKey:(NSString *)key inDictionary:(NSDictionary *)dict;
{
    NSString *string = @"";
    if (dict != nil) {
        NSString *value = [dict objectForKey:key];
        if (value != nil) {
            string = value;
        }
    }
    
    return string;
}

+ (NSString *)convertToDateTimeFrom:(NSInteger)value;
{
    int newValue = (int) value;
    int minutes = newValue / 60;
    int seconds = newValue - minutes * 60;
    
    NSString *string = [NSString stringWithFormat:@"%.02d:%.02d", minutes, seconds];
    
    return string;
}


+ (BOOL)appCanOpenURL:(NSString *)url;
{
    return [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]];
}



+ (BOOL)validateEmail:(NSString *)email;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";   
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];   
    return [emailTest evaluateWithObject:email];  
}

+ (UIImage *)captureImageFromView:(UIView *)view;
{
    UIGraphicsBeginImageContext(view.frame.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
//	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    return viewImage;
}


/*
 Icon512.png - 512px - 89.825
 Icon.png - 57px - 10
 Icon@2x.png - 114px - 20
 Icon-72.png - 72px - 12.632
 Icon-72@2x.png - 144px - 25.263
 Icon-Small.png - 29px - 5.088
 Icon-Small@2x.png - 58px - 10.175
 */
+ (UIImage *)captureImageFromView:(UIView *)view inFrame:(CGRect )captureFrame;
{
    CGFloat cornerRadius = kCornerRadius;
    
    CALayer *layer;
    layer = view.layer;
    
//    layer.masksToBounds = YES;
//    layer.cornerRadius = cornerRadius;
    
    UIGraphicsBeginImageContext(captureFrame.size); 

//    CGContextRef currentRef = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), captureFrame.origin.x, captureFrame.origin.y + captureFrame.size.height);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -captureFrame.origin.x, -captureFrame.origin.y);
    
    CGContextClipToRect (UIGraphicsGetCurrentContext(), captureFrame);
//    CGContextRotateCTM(UIGraphicsGetCurrentContext(), DegreesToRadians(180.0f));


    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    screenImage = [screenImage roundCornerTo:cornerRadius];
    
    NSLog(@"image size: %f, %f", screenImage.size.width, screenImage.size.height);
    
    UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, NULL);
    
    return screenImage;

}


+ (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}


+ (CGFloat) distanceFromPoint:(CGPoint)src toPoint:(CGPoint)desc{
    CGFloat distance = sqrtf((src.x - desc.x)*(src.x - desc.x) + (src.y - desc.y)*(src.y - desc.y));
    return distance;
}

+ (BOOL) existingOfFileWithName:(NSString*)name{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }    
    return NO;
}

+ (NSString*) documentPathForFile:(NSString*)fileName{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[CommonUtils applicationDocumentsDirectory],fileName];
    return path;
}

+ (NSString*) bundlePathWithFile:(NSString*)fileName{
    return [[NSBundle mainBundle] pathForResource:fileName 
                                           ofType:nil];
}

+ (NSInteger) percentFrom:(NSInteger)from to:(NSInteger)to{
    if (to != 0 ) {
        return round(((CGFloat)from/(CGFloat)to)*100);
    }
    return 0;
}

+ (void) printViewContent:(UIView*)view delegate:(id) printDelegate{
    UIImage *image = [self captureImageFromView:view];
    
    NSData *myData = UIImageJPEGRepresentation(image, 1);
    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: myData] ) {
        
        pic.delegate = printDelegate;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jpg";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            //self.content = nil;
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            } 
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
    }	
        
}

+ (void) printViewContent:(UIView*)view fromRect:(CGRect)rect inView:(UIView*)inView delegate:(id)delegate{
    UIImage *image = [self captureImageFromView:view];
    
    NSData *myData = UIImageJPEGRepresentation(image, 1);
    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: myData] ) {
        
        pic.delegate = delegate;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jpg";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            //self.content = nil;
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            } 
        };
        
        [pic presentFromRect:rect
                      inView:inView
                    animated:YES
           completionHandler:completionHandler];

    }	

}
 
+ (void) printViewcontent:(UIView*)view fromBarButtonItem:(UIBarButtonItem*)barButton delegate:(id)delegate{
    UIImage *image = [self captureImageFromView:view];
    
    NSData *myData = UIImageJPEGRepresentation(image, 1);
    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: myData] ) {
        
        pic.delegate = delegate;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"jpg";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            //self.content = nil;
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            } 
        };
        [pic presentFromBarButtonItem:barButton
                             animated:YES
                    completionHandler:completionHandler];
    }
        
}
+ (NSString*) getElementValueFromWebView:(UIWebView*)webView byId:(NSString*)elementId{
    NSString *value = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"%@\").value",elementId]];
    
    return value;
}

+ (void) createEmailFromImageOfView:(UIView*)view matchName:(NSString*)matchName delegate:(id)delegate{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    UIImage *image = [CommonUtils captureImageFromView:view];
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString *base64 = [imgData base64Encoding];
    controller.mailComposeDelegate = delegate;
    [controller setMessageBody:[NSString stringWithFormat:@"Match Name: %@<br/><br/><img src=\"data:image/jpg;base64,%@\"/>\n\nGenerated by Assist Apps. www.assistapps.com.au",matchName,base64] isHTML:YES]; 

    [(UIViewController*)delegate presentModalViewController:controller animated:YES];
    [controller release];

}
+ (void) createEmailFromImageOfView:(UIView*)view subject:(NSString*)subject matchName:(NSString*)matchName delegate:(id)delegate{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    UIImage *image = [CommonUtils captureImageFromView:view];
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString *base64 = [imgData base64Encoding];
    controller.mailComposeDelegate = delegate;
    [controller setSubject:subject];
    [controller setMessageBody:[NSString stringWithFormat:@"Match Name: %@<br/><br/><img src=\"data:image/jpg;base64,%@\"/>\n\nGenerated by Assist Apps. www.assistapps.com.au",matchName,base64] isHTML:YES];
    
    [(UIViewController*)delegate presentModalViewController:controller animated:YES];
    [controller release];
    
}

+ (void) displayOptionMenuWithFilePath:(NSString*)filePath fromRect:(CGRect)rect inView:(UIView*)view delegate:(id)delegate{
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    UIDocumentInteractionController *documentInteractionController = [[UIDocumentInteractionController interactionControllerWithURL:url] retain];
    [documentInteractionController setDelegate:delegate];
    [documentInteractionController presentOptionsMenuFromRect:rect
                                                       inView:view
                                                     animated:YES];


}

+ (void) displayOptionMenuFromBarButton:(UIBarButtonItem*)barButton filePath:(NSString*)filePath delegate:(id) delegate{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    UIDocumentInteractionController *documentInteractionController = [[UIDocumentInteractionController interactionControllerWithURL:url] retain];
    [documentInteractionController setDelegate:delegate];
    [documentInteractionController presentOptionsMenuFromBarButtonItem:barButton
                                                              animated:YES];
}

+ (NSString*) dateTimeStringWithDate:(NSDate*)date formatString:(NSString*)format{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*) convertFromFloat:(CGFloat)dateTime toDateTimeStringWithFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTime];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (void) displayAlertWithTitle:(NSString*)title message:(NSString*)message cancelTitle:(NSString*)cancelTitle tag:(NSInteger)tag delegate:(id)delegate otherButtonTitles:(NSString *)otherButtonTitles, ...{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:otherButtonTitles, nil];
    [alert setTag:tag];
    [alert show];
    [alert release];
}
+ (void) displayPopUpWithContentView:(UIView*)contentView{
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
    [parentView setBackgroundColor:[UIColor clearColor]];
    [parentView setUserInteractionEnabled:YES];
    [parentView setTag:kPopUpParentViewTag];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:parentView];
    [contentView setCenter:parentView.center];
    CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
    [parentView addSubview:contentView];
    [contentView setTransform:transform];
    transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.15
                     animations:^{
                         [parentView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                         [contentView setTransform:transform];
                     } completion:^(BOOL finished) {
                         CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              [contentView setTransform:transform];
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [contentView setUserInteractionEnabled:YES];
    [parentView release];
}
+ (void) dismissPopUpView{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *parentView = [window viewWithTag:kPopUpParentViewTag];
    if (parentView) {
        [UIView animateWithDuration:0.15
                         animations:^{
                             [parentView setAlpha:0];
                         } completion:^(BOOL finished) {
                             [parentView removeFromSuperview];
                         }];
    }
}

+ (BOOL) canSendEmail{
    return [MFMailComposeViewController canSendMail];
}
@end



