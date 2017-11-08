//
//  NYTPhotosDataSource.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "NYTPhotosDataSource.h"
#import "NYTPhoto.h"

@interface NYTPhotosDataSource ()

@property (nonatomic, copy) NSArray *photos;

@end

@implementation NYTPhotosDataSource

#pragma mark - NSObject

-(void)dealloc {
    [self stopObservingPhotos];
}

- (instancetype)init {
    return [self initWithPhotos:nil];
}

#pragma mark - NYTPhotosDataSource

- (instancetype)initWithPhotos:(NSArray *)photos {
    self = [super init];
    
    if (self) {
        _photos = photos;
        [self startObservingPhotos];
    }
    
    return self;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)length {
    return [self.photos countByEnumeratingWithState:state objects:buffer count:length];
}

#pragma mark - NYTPhotosViewControllerDataSource

- (NSUInteger)numberOfPhotos {
    return self.photos.count;
}

- (id <NYTPhoto>)photoAtIndex:(NSUInteger)photoIndex {
    if (photoIndex < self.photos.count) {
        return self.photos[photoIndex];
    }
    
    return nil;
}

- (NSUInteger)indexOfPhoto:(id <NYTPhoto>)photo {
    return [self.photos indexOfObject:photo];
}

- (BOOL)containsPhoto:(id <NYTPhoto>)photo {
    return [self.photos containsObject:photo];
}

- (id <NYTPhoto>)objectAtIndexedSubscript:(NSUInteger)photoIndex {
    return [self photoAtIndex:photoIndex];
}

#pragma mark Observing

-(void)startObservingPhotos {
    for (id <NYTPhoto> photo in _photos) {
        NSObject<NYTPhoto> *photoObject = (NSObject<NYTPhoto> *)photo;
        [photoObject addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void)stopObservingPhotos {
    for (id <NYTPhoto> photo in _photos) {
        NSObject<NYTPhoto> *photoObject = (NSObject<NYTPhoto> *)photo;
        [photoObject removeObserver:self forKeyPath:@"image"];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object conformsToProtocol:@protocol(NYTPhoto)]) {
        id <NYTPhoto> photo = (id <NYTPhoto>)object;
        if (self.photoChangeHandler) {
            self.photoChangeHandler(photo);
        }
    }
}

@end
