//
//  BNRImageStore.m
//  Homepwner
//
//  Created by manit on 30/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore()

@property (nonatomic, strong) NSMutableDictionary * dictionary;
-(NSString *)imagePathForKey:(NSString *)key;
@end

@implementation BNRImageStore

+(instancetype)sharedStore
{
    static BNRImageStore * sharedStore = nil;
    
    // singletons
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// No one should call init
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [BNRItemImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter * nc = [[NSNotificationCenter alloc] init];
        [nc addObserver:self
               selector:@selector(clearCaches:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    
    //Shorthand syntax
    self.dictionary[key] = image;
    //NSLog(@"Set Image -> %@", self.dictionary[key]);
    
    // Create full path for image
    NSString * imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    
    // Wirte it to full path
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    //return [self.dictionary objectForKey:key];
    
    //Shorthand syntax
    //NSLog(@"ImageForKey -> %@", key);
    //return self.dictionary[key];
    
    // If possible, get it from the directory
    UIImage * result = self.dictionary[key];
    
    if (!result) {
        NSString * imagePath = [self imagePathForKey:key];
        
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // If we found image on the file system, place it into the cache
        if (result) {
            self.dictionary[key] = result;
        }else{
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

-(void)deleteImageForKey:(NSString *)key
{
    if(!key){
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString * imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask, YES);
    NSString * documenDirectory = [documentDirectories firstObject];
    return [documenDirectory stringByAppendingPathComponent:key];
}

-(void)clearCaches:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}
@end
