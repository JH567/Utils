/*
 @author: ideawu
 @link: https://github.com/ideawu/Objective-C-RSA
*/

#import "RSA.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>

@implementation RSA

/*
static NSString *base64_encode(NSString *str){
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	if(!data){
		return nil;
	}
	return base64_encode_data(data);
}
*/

static NSString *base64_encode_data(NSData *data){
	data = [data base64EncodedDataWithOptions:0];
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

static NSData *base64_decode(NSString *str){
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
	return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
	// Skip ASN.1 public key header
	if (d_key == nil) return(nil);
	
	unsigned long len = [d_key length];
	if (!len) return(nil);
	
	unsigned char *c_key = (unsigned char *)[d_key bytes];
	unsigned int  idx	 = 0;
	
	if (c_key[idx++] != 0x30) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	// PKCS #1 rsaEncryption szOID_RSA_RSA
	static unsigned char seqiod[] =
	{ 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
		0x01, 0x05, 0x00 };
	if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
	
	idx += 15;
	
	if (c_key[idx++] != 0x03) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	if (c_key[idx++] != '\0') return(nil);
	
	// Now make a new NSData from this buffer
	return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

//credit: http://hg.mozilla.org/services/fx-home/file/tip/Sources/NetworkAndStorage/CryptoUtils.m#l1036
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
	// Skip ASN.1 private key header
	if (d_key == nil) return(nil);

	unsigned long len = [d_key length];
	if (!len) return(nil);

	unsigned char *c_key = (unsigned char *)[d_key bytes];
	unsigned int  idx	 = 22; //magic byte at offset 22

	if (0x04 != c_key[idx++]) return nil;

	//calculate length of the key
	unsigned int c_len = c_key[idx++];
	int det = c_len & 0x80;
	if (!det) {
		c_len = c_len & 0x7f;
	} else {
		int byteCount = c_len & 0x7f;
		if (byteCount + idx > len) {
			//rsa length field longer than buffer
			return nil;
		}
		unsigned int accum = 0;
		unsigned char *ptr = &c_key[idx];
		idx += byteCount;
		while (byteCount) {
			accum = (accum << 8) + *ptr;
			ptr++;
			byteCount--;
		}
		c_len = accum;
	}

	// Now make a new NSData from this buffer
	return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
	NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
	NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
	if(spos.location != NSNotFound && epos.location != NSNotFound){
		NSUInteger s = spos.location + spos.length;
		NSUInteger e = epos.location;
		NSRange range = NSMakeRange(s, e-s);
		key = [key substringWithRange:range];
	}
	key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
	
	// This will be base64 encoded, decode it.
	NSData *data = base64_decode(key);
	data = [RSA stripPublicKeyHeader:data];
	if(!data){
		return nil;
	}

	//a tag to read/write keychain storage
	NSString *tag = @"RSAUtil_PubKey";
	NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
	
	// Delete any old lingering key with the same tag
	NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
	[publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
	SecItemDelete((__bridge CFDictionaryRef)publicKey);
	
	// Add persistent version of the key to system keychain
	[publicKey setObject:data forKey:(__bridge id)kSecValueData];
	[publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
	 kSecAttrKeyClass];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
	 kSecReturnPersistentRef];
	
	CFTypeRef persistKey = nil;
	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
	if (persistKey != nil){
		CFRelease(persistKey);
	}
	if ((status != noErr) && (status != errSecDuplicateItem)) {
		return nil;
	}

	[publicKey removeObjectForKey:(__bridge id)kSecValueData];
	[publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	
	// Now fetch the SecKeyRef version of the key
	SecKeyRef keyRef = nil;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
	if(status != noErr){
		return nil;
	}
	return keyRef;
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
	NSRange spos;
	NSRange epos;
	spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
	if(spos.length > 0){
		epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
	}else{
		spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
		epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
	}
	if(spos.location != NSNotFound && epos.location != NSNotFound){
		NSUInteger s = spos.location + spos.length;
		NSUInteger e = epos.location;
		NSRange range = NSMakeRange(s, e-s);
		key = [key substringWithRange:range];
	}
	key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

	// This will be base64 encoded, decode it.
	NSData *data = base64_decode(key);
	data = [RSA stripPrivateKeyHeader:data];
	if(!data){
		return nil;
	}

	//a tag to read/write keychain storage
	NSString *tag = @"RSAUtil_PrivKey";
	NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

	// Delete any old lingering key with the same tag
	NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
	[privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
	[privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
	SecItemDelete((__bridge CFDictionaryRef)privateKey);

	// Add persistent version of the key to system keychain
	[privateKey setObject:data forKey:(__bridge id)kSecValueData];
	[privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
	 kSecAttrKeyClass];
	[privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
	 kSecReturnPersistentRef];

	CFTypeRef persistKey = nil;
	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
	if (persistKey != nil){
		CFRelease(persistKey);
	}
	if ((status != noErr) && (status != errSecDuplicateItem)) {
		return nil;
	}

	[privateKey removeObjectForKey:(__bridge id)kSecValueData];
	[privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
	[privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	[privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

	// Now fetch the SecKeyRef version of the key
	SecKeyRef keyRef = nil;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
	if(status != noErr){
		return nil;
	}
	return keyRef;
}

/* START: Encryption & Decryption with RSA private key */

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef isSign:(BOOL)isSign {
    
    // liuyj 修改
    size_t signedHashBytesSize = SecKeyGetBlockSize(keyRef);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);

    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([data bytes], (CC_LONG)[data length], hashBytes)) {
        return nil;
    }

    NSData* signedHash = nil;

    OSStatus status = noErr;

    if (isSign) {
        status = SecKeyRawSign(keyRef,
                               kSecPaddingPKCS1SHA256,
                               hashBytes,
                               hashBytesSize,
                               signedHashBytes,
                               &signedHashBytesSize);
    } else {
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1SHA256,
                               hashBytes,
                               hashBytesSize,
                               signedHashBytes,
                               &signedHashBytesSize);
    }

    if (status != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
        signedHash = nil;
    }else{
        signedHash = [NSData dataWithBytes:signedHashBytes
                                    length:(NSUInteger)signedHashBytesSize];
    }


    if (hashBytes) {
        free(hashBytes);
    }
    if (signedHashBytes) {
        free(signedHashBytes);
    }
    CFRelease(keyRef);
    return signedHash;
}

+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey{
	NSData *data = [RSA encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] privateKey:privKey];
	NSString *ret = base64_encode_data(data);
	return ret;
}

+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey{
	if(!data || !privKey){
		return nil;
	}
	SecKeyRef keyRef = [RSA addPrivateKey:privKey];
	if(!keyRef){
		return nil;
	}
	return [RSA encryptData:data withKeyRef:keyRef isSign:YES];
}

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    
    // liuyj 修改
    size_t cipherBufferSize = SecKeyGetBlockSize(keyRef);
    size_t blockSize = cipherBufferSize;
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);

    NSMutableData *decryptedData = [[NSMutableData alloc] init];

    for (int i = 0; i < blockCount; i++) {
        unsigned long bufferSize = MIN(blockSize , [data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];

        size_t cipherLen = [buffer length];
        void *cipher = malloc(cipherLen);
        [buffer getBytes:cipher length:cipherLen];
        size_t plainLen = SecKeyGetBlockSize(keyRef);
        void *plain = malloc(plainLen);

        OSStatus status = SecKeyDecrypt(keyRef, kSecPaddingNone, cipher, cipherLen, plain, &plainLen);

        if (status != noErr) {
            return nil;
        }

        NSData *decryptedBytes = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
        [decryptedData appendData:decryptedBytes];
    }

    return decryptedData;
}


+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey{
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
	data = [RSA decryptData:data privateKey:privKey];
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
	if(!data || !privKey){
		return nil;
	}
	SecKeyRef keyRef = [RSA addPrivateKey:privKey];
	if(!keyRef){
		return nil;
	}
	return [RSA decryptData:data withKeyRef:keyRef];
}

/* END: Encryption & Decryption with RSA private key */

/* START: Encryption & Decryption with RSA public key */

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
	NSData *data = [RSA encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
	NSString *ret = base64_encode_data(data);
	return ret;
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
	if(!data || !pubKey){
		return nil;
	}
	SecKeyRef keyRef = [RSA addPublicKey:pubKey];
	if(!keyRef){
		return nil;
	}
	return [RSA encryptData:data withKeyRef:keyRef isSign:NO];
}

+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey{
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
	data = [RSA decryptData:data publicKey:pubKey];
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey{
	if(!data || !pubKey){
		return nil;
	}
	SecKeyRef keyRef = [RSA addPublicKey:pubKey];
	if(!keyRef){
		return nil;
	}
	return [RSA decryptData:data withKeyRef:keyRef];
}

/* END: Encryption & Decryption with RSA public key */

@end
