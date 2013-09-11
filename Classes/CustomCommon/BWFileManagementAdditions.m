//
//  NSFileManager+myBWFileManagementAdditions.m
//  Premise
//
//  Created by Renato Casanova on 5/4/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "BWFileManagementAdditions.h"
#import "AlertStrings.h"
#import "URLConst.h"

@implementation NSFileManager (myBWFileManagementAdditions)
-(void)resetLocalizedFactory
{


    NSFileManager *fileMngr = [NSFileManager defaultManager];
    NSError *error;

    NSString * locStr = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSURL *_library_Factory = [NSURL URLsetUpFrom:urlLibaryFactory];
    NSURL *_libary_locFactory =[[NSURL URLsetUpFrom:urlLibary] URLByAppendingPathComponent:[locStr stringByAppendingString:urlFactory]];

    [fileMngr removeItemAtURL:_library_Factory error:nil];

    NSString * locFactory = [locStr stringByAppendingString:urlFactory];
    NSURL * _bundle_locFactory=  [[NSBundle mainBundle]URLForResource:locFactory withExtension:nil];

    if ([fileMngr copyItemAtURL:_bundle_locFactory toURL:_libary_locFactory error:&error])
        if (error) {
            NSLog(@"%@",error);
        }
    [fileMngr moveItemAtURL:_libary_locFactory toURL:_library_Factory error:nil];

}

-(void)resetLocalizedDataBase
{

    NSString * locStr = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSError *error;
    NSURL *_documents = [NSURL URLsetUpFrom:urlDocuments];

    NSURL *_documents_Database = [NSURL URLsetUpFrom:[urlDocuments stringByAppendingString:kDatabase]];
    NSString *locDatabse = [locStr stringByAppendingString:kDatabase];
    NSURL * _documents_LocDatabse = [_documents URLByAppendingPathComponent:locDatabse isDirectory:YES];

    //Remove words arch
    [self removeItemAtURL:_documents_LocDatabse error:&error];
    [self removeItemAtURL:_documents_Database error:&error];
    
    
    [[NSFileManager defaultManager] iterateThroughRootHierarchyWhileUpdatingRootArchives:[NSURL URLsetUpFrom:urlDocuments] WithDepth:[NSMutableArray arrayWithObject:@0] AndDelegate:nil];
    
    NSURL * _bundle_locDatabase =  [[NSBundle mainBundle]URLForResource:locDatabse withExtension:nil];
    [self copyItemAtURL:_bundle_locDatabase toURL:_documents_LocDatabse error:&error];
    if (error) {
        NSLog(@"%@",error);
    }

    [self moveItemAtURL:_documents_LocDatabse toURL:_documents_Database error:nil];
    

}
-(NSMutableArray*)enumerateDirectoryComponentsFromURL:(NSURL*)url
{
    
    NSMutableArray * mArray=[NSMutableArray array];

    NSDirectoryEnumerator * enumerator =[[NSFileManager defaultManager]enumeratorAtURL:url includingPropertiesForKeys:@[NSURLIsDirectoryKey,NSURLLocalizedNameKey] options:(NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsSubdirectoryDescendants) errorHandler:^(NSURL *url, NSError *error) {

        if (error) 
        NSLog(@"Error at loading text from Directory:  %@",[url lastPathComponent]);
        return YES;
    }];

    
    for (NSURL *temp in  enumerator) {
        if ([temp class] != [NSURL class]) {
            continue;
        }

        NSNumber *isDirectory = nil;
        [temp getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        if ([isDirectory boolValue]) {

            NSString *localizedName = nil;
            [temp getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];



            [mArray addObject:@[@0,localizedName,[NSMutableArray array]]];

        }
        else

        {
            NSString *localizedName = nil;
            [temp getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
                    

            if ([localizedName hasSuffix:kTextSuffix]) {
                [mArray addObject:@[@1,[localizedName stringByDeletingPathExtension],@0]];
            }
           
        }


    }

    return mArray;
    
}
-(NSMutableArray *)parseTextFileAt:(NSURL*)url
{
    
    NSError * error;
    NSString * content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return [NSMutableArray array];
        NSLog(@"Error at parsing text file: %@. With error: %@",[url lastPathComponent],[error description]);
    }
    NSArray *parsed = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    NSMutableArray* parsedM = [NSMutableArray arrayWithArray:parsed];
    NSMutableArray *deleteThis =[NSMutableArray arrayWithCapacity:parsedM.count];



    for (int i = 0; i <parsedM.count; i++) {



        parsedM[i] = [parsedM[i]capitalizedString];
        NSString *str =parsedM[i];
        

        


        if ([str isEqualToString:kEmptyText]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str hasPrefix:@" "]) {
            for (int b = 0; b < str.length; b++) {
                if ([str hasPrefix:@" "]) {
                    str = [str substringFromIndex:1];
                    parsedM[i] = str;
                }
                else
                {
                    break;
                }
            }
        }
        
        
        if ([str hasPrefix:@"("]) {
            if ( [str length] > 0)
            str = [str substringToIndex:1];
            parsedM[i] = str;

        }
        //Quitar la, el, los, ellos, whatever.
        if ([str hasPrefix:@"La "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:2];
            parsedM[i] = str;

        }
        if ([str hasPrefix:@"En "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:2];
            parsedM[i] = str;

        }
        if ([str hasPrefix:@"El "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:2];
            parsedM[i] = str;

        }
        if ([str hasPrefix:@"Una "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:3];
            parsedM[i] = str;

        }
        if ([str hasPrefix:@"Unos "]) {
            if ( [str length] > 0)
                str = [str substringFromIndex:4];
            parsedM[i] = str;

        }
        

        if ([str hasSuffix:@")"]) {
            if ( [str length] > 0)
                str = [str substringToIndex:[str length]-1];
            parsedM[i] = str;

        }
        if ([str isEqualToString:@"(to"]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str isEqualToString:@"("]) {
            [deleteThis addObject:str];

            continue;
        }

        if ([str isEqualToString:@"to"]) {
            [deleteThis addObject:str];
            continue;
        }

        if ([str isEqualToString:@"to)"]) {
            [deleteThis addObject:str];
            continue;
        }

        if ([str isEqualToString:@";"]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str isEqualToString:@"_"]) {
            [deleteThis addObject:str];
            continue;
        }
        if ([str isEqualToString:@"-"]) {
            [deleteThis addObject:str];
            continue;
        }
        
    }
    [parsedM removeObjectsInArray:deleteThis];

    return parsedM;
}


- (NSMutableArray *)iterateThroughTreeWhileParsingSelectedTextFiles:(NSArray*)currentBranch AtDepth:(NSURL*)depth
{
    
    //    NSMutableArray* root;
    NSMutableArray * masterListOfConepts =[NSMutableArray array];
    static BOOL haveOneSelectedList = NO;
    if (!currentBranch) {
        return nil;
    }
    for (int i = 0; i< currentBranch.count; i++) {


        NSArray* kind = currentBranch[i];
        
        id isSelectedList = kind[2];

        if (![kind[0]boolValue] )

        {

            //FOLDER
            NSArray *upcomingConcepts = [[NSFileManager defaultManager]   iterateThroughTreeWhileParsingSelectedTextFiles:kind[2] AtDepth:[depth URLByAppendingPathComponent:kind[1] isDirectory:YES]];
            if (upcomingConcepts == nil) {
                haveOneSelectedList =NO;
            }
            else
            {
                haveOneSelectedList =YES;
            [masterListOfConepts insertObjects:upcomingConcepts atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(masterListOfConepts.count, upcomingConcepts.count)]];
            }

        }
        else
            //LISTA
        {

            if ([isSelectedList boolValue]){//selecionada
                haveOneSelectedList =YES;
                NSArray * parsedText = [[NSFileManager defaultManager]  parseTextFileAt:[[depth URLByAppendingPathComponent:kind[1]] URLByAppendingPathExtension:kTextSuffix]];
                [masterListOfConepts insertObjects:parsedText atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, parsedText.count)]];
            }
        }
        
    }
    if (!haveOneSelectedList) {
    
        return nil;
    }
    else
    {
        haveOneSelectedList =NO;
    return masterListOfConepts;
    }

}



- (NSMutableArray*)iterateThroughRootHierarchyWhileUpdatingRootArchives:(NSURL*)url WithDepth:(NSMutableArray*)depth AndDelegate:(id <FinderArchiveReferenceProtocol>)referenceDelegate
{
    NSMutableArray* root;

    NSMutableArray * masterBools =[NSMutableArray array];

    root = [[NSFileManager defaultManager] readDataOfClass:[NSMutableArray class] FromURL:[url URLByAppendingPathComponent:kDataStructure]];

    [self updateReferencesOfRootFile:root atURL:url shouldAnimateRows:nil withDepth:depth AndDelegate:referenceDelegate];

    [[NSFileManager defaultManager] saveData:root  ToURL:[url URLByAppendingPathComponent:kDataStructure]];

    for (NSArray * kind in root) {

        if (![kind[0]boolValue])//Folder
        {
            int index = [root indexOfObject:kind];
            
            NSMutableArray * nextDepthLevel = [NSMutableArray arrayWithArray:depth];
            [nextDepthLevel addObject:[NSNumber numberWithInt:index]];
            NSMutableArray *kindM = [NSMutableArray arrayWithArray:kind];
            kindM[2] =[self iterateThroughRootHierarchyWhileUpdatingRootArchives:[url URLByAppendingPathComponent:kind[1] isDirectory:YES] WithDepth:nextDepthLevel AndDelegate:referenceDelegate];
            [masterBools addObject:kindM];
            
        }
        else
        {
            [masterBools addObject:kind];
            
        }

    }

    if (depth.count == 1) {
        [[NSFileManager defaultManager]saveData:masterBools ToURL:[[NSURL URLsetUpFrom:urlDocuments] URLByAppendingPathComponent:kDataMasterBools]];

    }
    return masterBools;
    
}



-(void)updateReferencesOfRootFile:(NSMutableArray*)rootFile atURL:(NSURL*)url shouldAnimateRows:(UITableView*)tableView withDepth:(NSMutableArray*)depth AndDelegate:(id <FinderArchiveReferenceProtocol>)referenceDelegate

{
    //Archives new/delete REFERENCES shall be manipulated from here.
    
    NSArray * directoryFile = [[NSFileManager defaultManager]enumerateDirectoryComponentsFromURL:url];

    NSMutableArray *toCreate;
    toCreate = [NSMutableArray objectsFrom:directoryFile thatAintHere:rootFile];
    
    if (toCreate.count > 0) {
        for (NSArray *kind in toCreate) {
            [rootFile insertObject:kind atIndex:0];
            if (referenceDelegate && [referenceDelegate respondsToSelector:@selector(finderControllerWantsToCreateNewArchiveReference:AtDepth:)])
                [referenceDelegate finderControllerWantsToCreateNewArchiveReference:kind AtDepth:depth];
            
            if (tableView)
                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    if (referenceDelegate && [referenceDelegate respondsToSelector:@selector(finderControllerWantsToCorroborateNewArchivesAtDepth:ComparedWithArchiveReferences:)] )
        [referenceDelegate finderControllerWantsToCorroborateNewArchivesAtDepth:depth ComparedWithArchiveReferences:rootFile];
        

    
    NSMutableArray *toDeleteIndexPaths = [NSMutableArray indexesOfObjectsFrom:directoryFile thatAintHere:rootFile];
    if (toDeleteIndexPaths.count > 0) {

        NSMutableArray *toDelete = [NSMutableArray array];
        for (int  i = 0;  i < toDeleteIndexPaths.count ; i++) {
            NSIndexPath * path = [toDeleteIndexPaths objectAtIndex:i];
            id kindToDelete = [rootFile objectAtIndex:path.row];
            [toDelete addObject:kindToDelete];
        }
        [rootFile removeObjectsInArray:toDelete];
        if (referenceDelegate && [referenceDelegate respondsToSelector:@selector(finderControllerWantsToDeleteArchiveReferences:AtDepth:)])
            [referenceDelegate finderControllerWantsToDeleteArchiveReferences:toDeleteIndexPaths AtDepth:depth];
        if (tableView)
            [tableView deleteRowsAtIndexPaths:toDeleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];

    }
        
    if (referenceDelegate && [referenceDelegate respondsToSelector:@selector(finderControllerWantsToCorroborateDeletedArchivesAtDepth:ComparedWithArchiveReferences:)])
        [referenceDelegate finderControllerWantsToCorroborateDeletedArchivesAtDepth:depth ComparedWithArchiveReferences:rootFile];
    
}
-(NSMutableArray* )iterateForBranchInTree:(NSMutableArray*)branchOfBools atDepthLevel:(NSArray*)depth
{

    //Considering One Object per index, else is folder.


    if (![branchOfBools respondsToSelector:@selector(insertObject:atIndex:)])
        return nil;
    
    if (depth.count == 1)
    {
        return [NSMutableArray arrayWithArray:branchOfBools];
    }
    

    NSMutableArray* currentDepth = [NSMutableArray arrayWithArray:depth];
    NSMutableArray *nextObject = [NSMutableArray array];
   nextObject =[branchOfBools objectAtIndex:[depth[1] integerValue]];

    //CUANO PONGA PREMISEDATA; quitar ésta linea de codigo.
    NSMutableArray * nextBranch = [nextObject objectAtIndex:2];
    
    [currentDepth removeObjectAtIndex:1];

    return [self iterateForBranchInTree:nextBranch atDepthLevel:currentDepth];
}

-(NSMutableArray* )iterateBoolsTree:(NSMutableArray*)branchOfBools ToUpdateBranch:(NSMutableArray*)newBranch  atDepthLevel:(NSArray*)depth
{
//    if (newBranch == nil) {
//        return [NSMutableArray array];
//    }

    if (depth.count == 1) {
        return newBranch;
    }
    NSNumber*  index = [depth lastObject];
    NSMutableArray *currentDepth = [NSMutableArray arrayWithArray:depth];
    [currentDepth removeLastObject];
    NSMutableArray * nextObject = [self iterateForBranchInTree:branchOfBools atDepthLevel:currentDepth];
   
    
    NSMutableArray *nextBranch= [NSMutableArray array];
    nextBranch = [nextObject objectAtIndex:[index integerValue]];
    nextBranch = [NSMutableArray arrayWithArray:nextBranch];
    [nextBranch replaceObjectAtIndex:2 withObject:newBranch];
    [nextObject replaceObjectAtIndex:[index integerValue] withObject:nextBranch];

    //When appying premiseData.
    // Return form iteration is nextBranch not NextObject
//    [nextBranch replaceObjectAtIndex:[index integerValue] withObject:newBranch];

    
    return [self iterateBoolsTree:branchOfBools ToUpdateBranch:nextObject atDepthLevel:currentDepth];
}

-(id)readDataOfClass:(Class)class FromURL:(NSURL*)url
{
    NSData *readArchive = [NSData  dataWithContentsOfURL:url];
    if (readArchive == NULL) {

        id data = [[class alloc]init];
        
        
        return data;
        
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:readArchive];
}
-(BOOL)saveData:(id)data ToURL:(NSURL*)url
{
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:data];
    return [archive writeToURL:url atomically:YES];
}
@end



@implementation NSURL (myBWFileManagementAdditions)

+(NSURL*)URLsetUpFrom:(NSString*)afterBundle

{

    NSURL* url =[[[[NSBundle mainBundle]bundleURL] URLByDeletingLastPathComponent]URLByAppendingPathComponent:afterBundle];

    NSFileManager *manager= [NSFileManager defaultManager];
    NSError *error;

    [manager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        //Hanlde error
        NSLog(@"Error at creating directories at %@",url);
    }
    return url;
}

@end
@implementation NSMutableDictionary (KeyManipulation)

-(void)exchangeOldKey:(NSString*)oldKey WithNewKey:(NSString*)newKey
{
    id value = [self objectForKey:oldKey];
    [self removeObjectForKey:oldKey];
    [self setValue:value forKey:newKey];
}

@end

@implementation NSMutableArray (differenceBetweenArrays)

+(NSMutableArray*)indexesOfObjectsFrom:(NSArray *)directoryFile thatAintHere:(NSMutableArray *)rootFile
{
    NSMutableArray * indexesToDelete = [NSMutableArray array];
    for (NSArray* rootKind in rootFile) {
        BOOL inDirectoryFile =NO;
        for (NSArray* directoryKind in directoryFile) {


            if ([directoryKind[0]isEqual:rootKind[0]])
            if ([directoryKind[1] isEqualToString:rootKind[1]]) {
                inDirectoryFile =YES;
                break;
            }
        }
        if (!inDirectoryFile) {

            NSIndexPath * path = [NSIndexPath  indexPathForItem:[rootFile indexOfObject:rootKind] inSection:0];
            [indexesToDelete addObject:path];
            
        }
    }
    return indexesToDelete;
}
+ (NSMutableArray *)objectsFrom:(NSArray *)directoryFile thatAintHere:(NSMutableArray *)rootFile
{
    NSMutableArray *toCreate = [NSMutableArray array];

    for (NSArray* directoryCurrentKind in directoryFile) {

        BOOL isThisNew = YES;
        for (NSArray* arrayCurrentKind in rootFile)
        {

            if ([arrayCurrentKind[0]isEqual:directoryCurrentKind[0]]) 
            if ([arrayCurrentKind[1] isEqualToString:directoryCurrentKind[1]]) {
                isThisNew = NO;
                break;
            }
        }
        if (isThisNew) {
            [toCreate addObject:directoryCurrentKind];

        }
    }
    return toCreate;
}
@end