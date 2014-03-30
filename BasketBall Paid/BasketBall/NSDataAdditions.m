// Created by khammond on Mon Oct 29 2001.
// Formatted by Timothy Hatcher on Sun Jul 4 2004.
// Copyright (c) 2001 Kyle Hammond. All rights reserved.
// Original development by Dave Winer.

/*
 *                             EDIT HISTORY FOR MODULE
 *
 * when       who              what, where, why
 * ---------- ---------------- ---------------------------------------------
 * 2012-05-22 FPT DatNT8       DMS_1689516, Line170, handle invalid UTF8 character, prevent app crash
 */


#import "NSDataAdditions.h"

static char encodingTable[64] = {
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
		'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
		'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
		'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

@implementation NSData (NSDataAdditions)
+ (NSData *) dataWithBase64EncodedString:(NSString *) string {
	return [[[NSData alloc] initWithBase64EncodedString:string] autorelease];
}

- (id) initWithBase64EncodedString:(NSString *) string {
	NSMutableData *mutableData = nil;

	if( string ) {
		unsigned long ixtext = 0;
		unsigned long lentext = 0;
		unsigned char ch = 0;
		unsigned char inbuf[4] =  { 0, 0, 0, 0 }, outbuf[3] = { 0, 0, 0 };
		short i = 0, ixinbuf = 0;
		BOOL flignore = NO;
		BOOL flendtext = NO;
		NSData *base64Data = nil;
		const unsigned char *base64Bytes = nil;

		// Convert the string to ASCII data.
		base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
		base64Bytes = [base64Data bytes];
		mutableData = [NSMutableData dataWithCapacity:base64Data.length];
		lentext = base64Data.length;

		while( YES ) {
			if( ixtext >= lentext ) break;
			ch = base64Bytes[ixtext++];
			flignore = NO;

			if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
			else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
			else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
			else if( ch == '+' ) ch = 62;
			else if( ch == '=' ) flendtext = YES;
			else if( ch == '/' ) ch = 63;
			else flignore = YES;

			if( ! flignore ) {
				short ctcharsinbuf = 3;
				BOOL flbreak = NO;

				if( flendtext ) {
					if( ! ixinbuf ) break;
					if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
					else ctcharsinbuf = 2;
					ixinbuf = 3;
					flbreak = YES;
				}

				inbuf [ixinbuf++] = ch;

				if( ixinbuf == 4 ) {
					ixinbuf = 0;
					outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
					outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
					outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );

					for( i = 0; i < ctcharsinbuf; i++ )
						[mutableData appendBytes:&outbuf[i] length:1];
				}

				if( flbreak )  break;
			}
		}
	}

	self = [self initWithData:mutableData];
	return self;
}

#pragma mark -

- (NSString *) base64Encoding {
	return [self base64EncodingWithLineLength:0];
}

- (NSString *) base64EncodingWithLineLength:(NSUInteger) lineLength {
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:self.length];
	unsigned long ixtext = 0;
	unsigned long lentext = self.length;
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;

	while( YES ) {
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;

		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}

		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;

		switch( ctremaining ) {
		case 1:
			ctcopy = 2;
			break;
		case 2:
			ctcopy = 3;
			break;
		}

		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];

		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];

		ixtext += 3;
		charsonline += 4;

		if( lineLength > 0 ) {
			if( charsonline >= lineLength ) {
				charsonline = 0;
				[result appendString:@"\n"];
			}
		}
	}

	return [NSString stringWithString:result];
}

#pragma mark -

- (BOOL) hasPrefixBytes:(const void *) prefix length:(NSUInteger) length {
	if( ! prefix || ! length || self.length < length ) return NO;
	return ( memcmp( [self bytes], prefix, length ) == 0 );
}

- (BOOL) hasSuffixBytes:(const void *) suffix length:(NSUInteger) length {
	if( ! suffix || ! length || self.length < length ) return NO;
	return ( memcmp( ((const char *)[self bytes] + (self.length - length)), suffix, length ) == 0 );
}


/* Prismy_DMS_1689516 2012-05-22 add Start */
- (NSString*) UTF8String
{
    // First we try strict decoding to avoid iconv overhead when not needed (majority of cases).
    NSString* str = [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
    if (!str)
    {
        // Here data contains invalid characters, so we'll try to clean them up.
        return [[[NSString alloc] initWithData:[self dataByHealingUTF8Stream] encoding:NSUTF8StringEncoding] autorelease];
    }
    return str;
}

// Replaces all broken sequences by � character and returns NSData with valid UTF-8 bytes.

- (NSData*) dataByHealingUTF8Stream
{
    NSUInteger length = [self length];
    
    if (length == 0) return self;
    
#if DEBUG
    int warningsCounter = 10;
#endif
    
    //  bits
    //  7   	U+007F      0xxxxxxx
    //  11   	U+07FF      110xxxxx	10xxxxxx
    //  16  	U+FFFF      1110xxxx	10xxxxxx	10xxxxxx
    //  21  	U+1FFFFF    11110xxx	10xxxxxx	10xxxxxx	10xxxxxx
    //  26  	U+3FFFFFF   111110xx	10xxxxxx	10xxxxxx	10xxxxxx	10xxxxxx
    //  31  	U+7FFFFFFF  1111110x	10xxxxxx	10xxxxxx	10xxxxxx	10xxxxxx	10xxxxxx
    
#define b00000000 0x00
#define b10000000 0x80
#define b11000000 0xc0
#define b11100000 0xe0
#define b11110000 0xf0
#define b11111000 0xf8
#define b11111100 0xfc
#define b11111110 0xfe
    
    static NSString* replacementCharacter = @"�";
    NSData* replacementCharacterData = [replacementCharacter dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData* resultData = [NSMutableData dataWithCapacity:[self length]];
    
    const char *bytes = [self bytes];
    
    
    static const NSUInteger bufferMaxSize = 1024;
    char buffer[bufferMaxSize]; // not initialized, but will be filled in completely before copying to resultData
    NSUInteger bufferIndex = 0;
    
#define FlushBuffer() if (bufferIndex > 0) { \
[resultData appendBytes:buffer length:bufferIndex]; \
bufferIndex = 0; \
}
#define CheckBuffer() if ((bufferIndex+5) >= bufferMaxSize) { \
[resultData appendBytes:buffer length:bufferIndex]; \
bufferIndex = 0; \
}
    
    NSUInteger byteIndex = 0;
    BOOL invalidByte = NO;
    while (byteIndex < length)
    {
        char byte = bytes[byteIndex];
        
        // ASCII character is always a UTF-8 character
        if ((byte & b10000000) == b00000000) // 0xxxxxxx
        {
            CheckBuffer();
            buffer[bufferIndex++] = byte;
        }
        else if ((byte & b11100000) == b11000000) // 110xxxxx 10xxxxxx
        {
            if (byteIndex+1 >= length) {
                FlushBuffer();
                return resultData;
            }
            char byte2 = bytes[++byteIndex];
            if ((byte2 & b11000000) == b10000000)
            {
                // This 2-byte character still can be invalid. Check if we can create a string with it.
                unsigned char tuple[] = {byte, byte2};
                CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 2, kCFStringEncodingUTF8, false);
                if (cfstr)
                {
                    CFRelease(cfstr);
                    CheckBuffer();
                    buffer[bufferIndex++] = byte;
                    buffer[bufferIndex++] = byte2;
                }
                else
                {
                    invalidByte = YES;
                }
            }
            else
            {
                invalidByte = YES;
            }
        }
        else if ((byte & b11110000) == b11100000) // 1110xxxx 10xxxxxx 10xxxxxx
        {
            if (byteIndex+2 >= length) {
                FlushBuffer();
                return resultData;
            }
            char byte2 = bytes[++byteIndex];
            char byte3 = bytes[++byteIndex];
            if ((byte2 & b11000000) == b10000000 && 
                (byte3 & b11000000) == b10000000)
            {
                // This 3-byte character still can be invalid. Check if we can create a string with it.
                unsigned char tuple[] = {byte, byte2, byte3};
                CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 3, kCFStringEncodingUTF8, false);
                if (cfstr)
                {
                    CFRelease(cfstr);
                    CheckBuffer();
                    buffer[bufferIndex++] = byte;
                    buffer[bufferIndex++] = byte2;
                    buffer[bufferIndex++] = byte3;
                }
                else
                {
                    invalidByte = YES;
                }
            }
            else
            {
                invalidByte = YES;
            }
        }
        else if ((byte & b11111000) == b11110000) // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
        {
            if (byteIndex+3 >= length) {
                FlushBuffer();
                return resultData;
            }
            char byte2 = bytes[++byteIndex];
            char byte3 = bytes[++byteIndex];
            char byte4 = bytes[++byteIndex];
            if ((byte2 & b11000000) == b10000000 && 
                (byte3 & b11000000) == b10000000 && 
                (byte4 & b11000000) == b10000000)
            {
                // This 4-byte character still can be invalid. Check if we can create a string with it.
                unsigned char tuple[] = {byte, byte2, byte3, byte4};
                CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 4, kCFStringEncodingUTF8, false);
                if (cfstr)
                {
                    CFRelease(cfstr);
                    CheckBuffer();
                    buffer[bufferIndex++] = byte;
                    buffer[bufferIndex++] = byte2;
                    buffer[bufferIndex++] = byte3;
                    buffer[bufferIndex++] = byte4;
                }
                else
                {
                    invalidByte = YES;
                }
            }
            else
            {
                invalidByte = YES;
            }
        }
        else if ((byte & b11111100) == b11111000) // 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
        {
            if (byteIndex+4 >= length) {
                FlushBuffer();
                return resultData;
            }
            char byte2 = bytes[++byteIndex];
            char byte3 = bytes[++byteIndex];
            char byte4 = bytes[++byteIndex];
            char byte5 = bytes[++byteIndex];
            if ((byte2 & b11000000) == b10000000 && 
                (byte3 & b11000000) == b10000000 && 
                (byte4 & b11000000) == b10000000 && 
                (byte5 & b11000000) == b10000000)
            {
                // This 5-byte character still can be invalid. Check if we can create a string with it.
                unsigned char tuple[] = {byte, byte2, byte3, byte4, byte5};
                CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 5, kCFStringEncodingUTF8, false);
                if (cfstr)
                {
                    CFRelease(cfstr);
                    CheckBuffer();
                    buffer[bufferIndex++] = byte;
                    buffer[bufferIndex++] = byte2;
                    buffer[bufferIndex++] = byte3;
                    buffer[bufferIndex++] = byte4;
                    buffer[bufferIndex++] = byte5;
                }
                else
                {
                    invalidByte = YES;
                }
            }
            else
            {
                invalidByte = YES;
            }
        }
        else if ((byte & b11111110) == b11111100) // 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
        {
            if (byteIndex+5 >= length) {
                FlushBuffer();
                return resultData;
            }
            char byte2 = bytes[++byteIndex];
            char byte3 = bytes[++byteIndex];
            char byte4 = bytes[++byteIndex];
            char byte5 = bytes[++byteIndex];
            char byte6 = bytes[++byteIndex];
            if ((byte2 & b11000000) == b10000000 && 
                (byte3 & b11000000) == b10000000 && 
                (byte4 & b11000000) == b10000000 && 
                (byte5 & b11000000) == b10000000 &&
                (byte6 & b11000000) == b10000000)
            {
                // This 6-byte character still can be invalid. Check if we can create a string with it.
                unsigned char tuple[] = {byte, byte2, byte3, byte4, byte5, byte6};
                CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 6, kCFStringEncodingUTF8, false);
                if (cfstr)
                {
                    CFRelease(cfstr);
                    CheckBuffer();
                    buffer[bufferIndex++] = byte;
                    buffer[bufferIndex++] = byte2;
                    buffer[bufferIndex++] = byte3;
                    buffer[bufferIndex++] = byte4;
                    buffer[bufferIndex++] = byte5;
                    buffer[bufferIndex++] = byte6;
                }
                else
                {
                    invalidByte = YES;
                }
                
            }
            else
            {
                invalidByte = YES;
            }
        }
        else
        {
            invalidByte = YES;
        }
        
        if (invalidByte)
        {
#if DEBUG
            if (warningsCounter)
            {
                warningsCounter--;
                //NSLog(@"NSData dataByHealingUTF8Stream: broken byte encountered at index %d", byteIndex);
            }
#endif
            invalidByte = NO;
            FlushBuffer();
            [resultData appendData:replacementCharacterData];
        }
        
        byteIndex++;
    }
    FlushBuffer();
    return resultData;
}

/* Prismy_DMS_1689516 2012-05-22 add End */



@end
