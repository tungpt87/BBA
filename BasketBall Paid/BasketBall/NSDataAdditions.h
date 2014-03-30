// Created by khammond on Mon Oct 29 2001.
// Formatted by Timothy Hatcher on Sun Jul 4 2004.
// Copyright (c) 2001 Kyle Hammond. All rights reserved.
// Original development by Dave Winer.


/*
 *                             EDIT HISTORY FOR MODULE
 *
 * when       who              what, where, why
 * ---------- ---------------- ---------------------------------------------
 * 2012-05-22 FPT DatNT8       DMS_1689516, Line30, handle invalid UTF8 character, prevent app crash
 */



@interface NSData (NSDataAdditions)
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(NSUInteger) lineLength;

- (BOOL) hasPrefixBytes:(const void *) prefix length:(NSUInteger) length;
- (BOOL) hasSuffixBytes:(const void *) suffix length:(NSUInteger) length;

/* Prismy_DMS_1689516 2012-05-22 add Start */
- (NSData*) dataByHealingUTF8Stream;
- (NSString*) UTF8String;
/* Prismy_DMS_1689516 2012-05-22 add End */

@end
