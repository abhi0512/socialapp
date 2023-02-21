//
//  DbHandler.m
//  Bible
//
//  Created by MaDdy on 19/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DbHandler.h"



@implementation DbHandler

static sqlite3 *database = nil;

#pragma mark - DB Setup Functions -

+(void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"see >>>%@",[paths objectAtIndex:0]);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DbName];
    NSLog(@"%@",writableDBPath);
    success = [fileManager fileExistsAtPath:writableDBPath];
     if (success) {
		NSLog(@"Database file already exist, so returning...");
        [DbHandler openDatabase];
		return;
	}
    
	NSLog(@"CREATING A NEW COPY OF THE DATABASE...");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DbName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
		//Some serious problem...
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    [DbHandler openDatabase];
}

+(NSString *) dataFilePath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:path];
}

+(NSString *)GetId:(NSString *)strqry
{
    NSString *result2 = @"";
    
    if (database != nil)
    {
        NSString *selectSql =strqry;
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                result2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    
    return result2 ;
}

+(NSString *)getstringvalue:(NSString *)strqry
{
    NSString *result2;
    
    if (database != nil)
    {
        NSString *selectSql =strqry;
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                result2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    
    return result2 ;
}


+(void)openDatabase
{
	NSString *dbpath = [DbHandler dataFilePath:DbName];
    
	if (sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK)
	{
        NSLog(@"Databse opened");
    }
}
+(void)closeDatabase
{
    sqlite3_close(database);
}
+(BOOL)isDatabaseOpened
{
    return (database != nil);
}

+(NSMutableArray *)FetchCountry
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT country_name from countrymaster"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *winetype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [result2 addObject:[NSString stringWithFormat:@"%@", winetype]];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}


+(BOOL)deleteDatafromtable:(NSString *)query
{
    BOOL  result = NO;
    if (database != nil)
    {
        NSString *selectSql = query;
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Data deleted from table");
                result = YES;
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
        
    }
    else
    {
        NSLog(@"Database not opening");
    }
    return result;
}

+(BOOL)updatenotificationcount:(NSString *)_userid  count:(NSString *)_count

{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tbluser set notificationcount='%@' where memberid='%@'",_count,_userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"count updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)updateprice:(NSString *)_prdid  price:(NSString *)_price
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tblcart set price='%@' where productid='%@'",_price,_prdid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(BOOL)Insertcart:(NSString *)_productid productname:(NSString *)_productname productprice:(NSString *)_productprice productsize:(NSString *)_productsize productimage:(NSString *)_productimage productqty:(NSString *)_productqty productvariantid:(NSString *)_productvariantid totalprice:(NSString *)_totalprice
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        NSString *name = [_productname stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    
        selectSql = [NSString stringWithFormat:@"INSERT INTO tblcart (productid, productname, productprice, productsize, productimage, productqty, productvariantid, totalprice) values ('%@','%@','%@','%@','%@','%@','%@','%@')",_productid, name, _productprice, _productsize, _productimage, _productqty, _productvariantid, _totalprice];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(NSString *)checkCartProductExist:(NSString *)_productvariantid
{
    NSString *userid = @"";
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select count(id) as cnt from tblcart where productvariantid='%@'",_productvariantid];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}


+(BOOL)Insertuser:(NSString *)_userid firstname:(NSString *)_firstname lastname:(NSString *)_lastname email:(NSString *)_email profileimage:(NSString *)_profileimage password:(NSString *)_password
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        NSString *name = [_firstname stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    
        selectSql = [NSString stringWithFormat:@"INSERT INTO tbluser (userid, firstname, lastname, email, profileimage, password) values ('%@','%@','%@','%@','%@','%@')", _userid, name, _lastname, _email, _profileimage, _password];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else  
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)InsertService:(NSString *)_serviceid servicename:(NSString *)_servicename serviceprice:(NSString *)_serviceprice addon:(NSString *)_addon
         addonprice:(NSString *)_addonprice totalprice:(NSString *)_totalprice servicedate:(NSString *)_servicedate servicetime:(NSString *)_servicetime SubCategoryName:(NSString *)_SubCategoryName SubCategoryID:(NSString *)_SubCategoryID
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        NSString *name = [_servicename stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    
        selectSql = [NSString stringWithFormat:@"INSERT INTO tblservice (serviceid, servicename, serviceprice, addon, addonprice, totalprice ,servicedate ,servicetime,SubCategoryName,SubCategoryID) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",_serviceid, name, _serviceprice, _addon, _addonprice, _totalprice , _servicedate , _servicetime, _SubCategoryName ,_SubCategoryID ];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(NSMutableArray *)FetchServiceDetails
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];

    if (database != nil)
    {

        NSString *selectSql=[NSString stringWithFormat:@"select id,serviceid, servicename, serviceprice, addon, addonprice, totalprice ,servicedate ,servicetime,SubCategoryName,SubCategoryID from tblservice "];

        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];

                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"serviceid"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"servicename"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"serviceprice"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"addon"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"addonprice"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"totalprice"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"servicedate"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"servicetime"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"SubCategoryName"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"SubCategoryID"];
                
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    return result2 ;
}
+(BOOL)deleteServiceInCart:(NSString *)_id
{
    BOOL  result = NO;
    if (database != nil)
    {
        NSString *selectSql = [NSString stringWithFormat:@"delete from tblservice where id='%@'",_id];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Data deleted from table");
                result = YES;
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    return result;
}

+(NSString *)sumofServiceCart
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select ifnull(sum(addonprice),0)as total from tblservice"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}
+(NSString *)sumofServiceCartAddon
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select ifnull(sum(serviceprice),0)as total from tblservice"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}
+(BOOL)updateservicrtimedate:(NSString *)_id servicedate:(NSString *)_servicedate servicetime:(NSString *)_servicetime
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tblservice set servicedate='%@', servicetime='%@' where Id='%@'",_servicedate,_servicetime,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(NSString *)checkServiceCartProductExist:(NSString *)_serviceid
{
    NSString *userid = @"";
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select count(id) as cnt from tblservice where serviceid='%@'",_serviceid];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}


+(BOOL)InsertCourse:(NSString *)_course_id course_name:(NSString *)_course_name course_image:(NSString *)_course_image course_start_date:(NSString *)_course_start_date course_instructor_image:(NSString *)_course_instructor_image course_fees:(NSString *)_course_fees course_qty:(NSString *)_course_qty course_instructor_name:(NSString *)_course_instructor_name dateid:(NSString *)_dateid
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        NSString *name = [_course_name stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    
        selectSql = [NSString stringWithFormat:@"INSERT INTO tblcourse (course_id, course_name, course_image, course_start_date, course_instructor_image, course_fees, course_qty, course_instructor_name, dateid ) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",_course_id, name, _course_image, _course_start_date, _course_instructor_image, _course_fees, _course_qty, _course_instructor_name, _dateid] ;
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(NSString *)sumCourseCart
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select ifnull(count(id),0) from tblcourse"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}
+(NSString *)sumServiceCart
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select ifnull(count(id),0) from tblservice"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}
+(NSString *)sumofProductCart
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select ifnull(count(id),0) from tblcart"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}

+(NSString *)sumofCourseCart
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select  ifnull(sum(course_fees),0)as total from tblcourse"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}
+(NSMutableArray *)FetchCourseDetails
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];

    if (database != nil)
    {

        NSString *selectSql=[NSString stringWithFormat:@"select id,course_id, course_name, course_image, course_start_date, course_instructor_image, course_fees, course_qty, course_instructor_name, dateid from tblcourse"];

        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];

                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"course_id"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"course_name"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"course_image"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"course_start_date"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"course_instructor_image"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"course_fees"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"course_qty"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"course_instructor_name"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"dateid"];
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);

    return result2 ;
}


+(NSString *)checkCourseExist:(NSString *)_course_id
{
    NSString *userid = @"";
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select count(id) as cnt from tblcourse where course_id='%@'",_course_id];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}
+(BOOL)updateuser:(NSString *)userid firstname:(NSString *)_firstname lastname:(NSString *)_lastname gender:(NSString *)_gender profileimage:(NSString *)_profileimage mobile:(NSString *)_mobile
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        NSString *name = [_firstname stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    
        
        selectSql= [NSString stringWithFormat:@"update tbluser set profileimage='%@',  firstname='%@', lastname='%@', gender='%@', mobile='%@' where userid='%@'",_profileimage,name, _lastname,_gender,_mobile,userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(BOOL)updateuseremail:(NSString *)_userid  email:(NSString *)_email

{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tbluser set email='%@' where userid='%@'",_email,_userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)updateuserpoint:(NSString *)_userid  walletpoint:(NSString *)_walletpoint
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tbluser set walletpoints='%@' where _userid='%@'",_walletpoint,_userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)updateusertype:(NSString *)_userid  utype:(NSString *)_utype

{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tbluser set utype='%@' where memberid='%@'",_utype,_userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(BOOL)updatepassword:(NSString *)_userid  password:(NSString *)_password
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
    //memberid, username, email,phone,password,isemailverified,token,profilepicture,countrycode
        
        selectSql= [NSString stringWithFormat:@"update tbluser set password='%@' where memberid='%@'",_password,_userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(BOOL)updateuserimage:(NSString *)_userid  image:(NSString *)_image fname:(NSString *)_fname
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
    
        selectSql= [NSString stringWithFormat:@"update tbluser set profileimage='%@',fullname='%@' where memberid='%@'",_image,_fname,_userid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}


+(NSMutableArray *)Fetchuserdetail
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql=[NSString stringWithFormat:@"select userid, firstname, lastname, email, profileimage, password from tbluser"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"userid"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"firstname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"lastname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"email"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"profileimage"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"password"];
                
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}
+(NSMutableArray *)fetchnotification
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql =[NSString stringWithFormat:@"SELECT * from tblnotification order by id desc"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"propertyname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"priority"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"title"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"type"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"typename"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"mid"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"name"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"houseno"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"email"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"mobile"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)] forKey:@"message"];
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSString *)applycount
{
    NSString *applycount;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select applycount from tbluser"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                applycount=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                if([applycount  isEqual: @"0"])
                {
                    applycount = @"";
                }
                if(applycount.length > 2)
                {
                    applycount = @"9+";
                }
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return applycount;
}
+(NSString *)cartitemcount
{
    NSString *notificationcount;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select ifnull(sum(productqty),0) as total from tblcart"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                notificationcount=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                if([notificationcount  isEqual: @"0"])
                {
                    notificationcount = @"";
                }
                else
                {
                    notificationcount = notificationcount;
                }
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return notificationcount;
}

+(NSString *)checkusertype
{
    NSString *usertype;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select membertype from tbluser"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                usertype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return usertype;
}

+(NSMutableArray *)Fetchusertoken
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql=[NSString stringWithFormat:@"select membertype, token from tbluser"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"membertype"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"token"];
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(NSString *)checkuserexist
{
    NSString *userid = @"";
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select userid from tbluser"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}


+(BOOL)updatestepeleven:(NSString *)_streetaddress address2:(NSString *)_address2 city:(NSString *)_city state:(NSString *)_state zipcode:(NSString *)_zipcode cityname:(NSString *)_cityname statename:(NSString *)_statename
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tblloan set streetaddress='%@' , address2='%@',city='%@',state='%@',zipcode='%@',cityname='%@',statename='%@'  ",_streetaddress ,_address2,_city,_state,_zipcode,_cityname,_statename];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(BOOL)updatesteptewlve:(NSString *)_firstname lastname:(NSString *)_lastname dob:(NSString *)_dob email:(NSString *)_email phonenumber:(NSString *)_phonenumber 
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tblloan set firstname='%@' , lastname='%@',dob='%@',email='%@',phonenumber='%@'",_firstname ,_lastname,_dob,_email,_phonenumber];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(NSMutableArray *)FetchCartItems
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        
        NSString *selectSql=[NSString stringWithFormat:@"select id,productid,productname,productprice,productsize,productimage,productqty,productvariantid,totalprice from tblcart"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"productid"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"productname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"productprice"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"productsize"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"productimage"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"productqty"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"productvariantid"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"totalprice"];
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(BOOL)Insertcart:(NSString *)_service_id service_name:(NSString *)_service_name service_price:(NSString *)_service_price service_qty:(NSString *)_service_qty service_image:(NSString *)_service_img totalprice:(NSString *)_totalprice vendorid:(NSString *)_vendorid businessname:(NSString *)_businessname vendorcity:(NSString *)_vendorcity vendorlat:(NSString *)_vendorlat vendorlng:(NSString *)_vendorlng gstpercent:(NSString *)_gstpercent gstamount:(NSString *)_gstamount servicerating:(NSString *)_servicerating servicetypeid:(NSString *)_servicetypeid
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql = [NSString stringWithFormat:@"INSERT INTO tblcart (service_id,service_name,service_price,service_quantity,service_image,totalprice,vendorid,businessname, vendorcity,vendorlat,vendorlng,gstpercent,gstamount,servicerating,servicetypeid)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",_service_id,_service_name,_service_price,_service_qty,_service_img,_totalprice,_vendorid,_businessname,_vendorcity,_vendorlat,_vendorlng,_gstpercent,_gstamount,_servicerating,_servicetypeid];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user inserted successful");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}

+(NSString *)checkserviceexist:(NSString *)_serviceid
{
    NSString *userid = @"";
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select count(id) as cnt from tblcart where service_id='%@'",_serviceid];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}
+(BOOL)deleteCourseInCart:(NSString *)_id
{
    BOOL  result = NO;
    if (database != nil)
    {
        NSString *selectSql = [NSString stringWithFormat:@"delete from tblcourse where id='%@'",_id];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Data deleted from table");
                result = YES;
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
        
    }
    else
    {
        NSLog(@"Database not opening");
    }
    return result;
}
+(BOOL)deletecartitem:(NSString *)_id
{
    BOOL  result = NO;
    if (database != nil)
    {
        NSString *selectSql = [NSString stringWithFormat:@"delete from tblcart where id='%@'",_id];
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Data deleted from table");
                result = YES;
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
        
    }
    else
    {
        NSLog(@"Database not opening");
    }
    return result;
}

+(NSMutableArray *)FetchCart
{
    NSMutableArray *result2=[[NSMutableArray alloc] init];
    
    if (database != nil)
    {
        NSString *selectSql=[NSString stringWithFormat:@"select id,service_id,service_name,service_price,service_quantity,service_image,totalprice,vendorid,businessname, vendorcity,vendorlat,vendorlng,gstpercent,gstamount,servicerating,servicetypeid from tblcart limit 1"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"service_id"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"service_name"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"service_price"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"service_quantity"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"service_image"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"totalprice"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"vendorid"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"businessname"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"vendorcity"];
                [result  setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"vendorlat"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)] forKey:@"vendorlng"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)] forKey:@"gstpercent"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)] forKey:@"gstamount"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)] forKey:@"servicerating"];
                [result setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)] forKey:@"servicetypeid"];
                [result2 addObject:result];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error While Fetching  Data");
        }
    }
    else
    {
        NSLog(@"Database not opening");
    }
    //NSLog(@"%d",[result2 count]);
    
    return result2 ;
}

+(BOOL)updatecartqty:(NSString *)_id productqty:(NSString *)_productqty totalprice:(NSString *)_totalprice
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tblcart set productqty='%@', totalprice='%@' where Id='%@'",_productqty,_totalprice,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(BOOL)updateCourseCartQty:(NSString *)_id course_qty:(NSString *)_course_qty course_fees:(NSString *)_course_fees
{
    bool result = NO;
    
    if (database != nil)
    {
        NSString *selectSql;
        sqlite3_stmt *statement1;
        
        selectSql= [NSString stringWithFormat:@"update tblcourse set course_qty='%@', course_fees='%@' where Id='%@'",_course_qty,_course_fees,_id];
        
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement1) == SQLITE_DONE)
            {
                result = YES;
                NSLog(@"user updated successfully");
            }
            sqlite3_finalize(statement1);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return result;
}
+(NSString*)getcartqty:(NSString *)_id
{
    NSString *userid = 0;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select productqty from tblcart where Id='%@'",_id];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}
+(NSString*)getCourseCartQty:(NSString *)_id
{
    NSString *userid = 0;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select course_qty from tblcourse where Id='%@'",_id];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}
+(NSString *)sumcart
{
    NSString *itemamt;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"select  ifnull(sum(totalprice),0)as total from tblcart"];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                itemamt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return itemamt;
}

+(NSString*)Deleteitemfromcart:(NSString *)_id
{
    NSString *userid = 0;
    
    if (database != nil)
    {
        NSString *selectSql;
        selectSql = [NSString stringWithFormat:@"delete from tblcart where id='%@'",_id];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database,[selectSql UTF8String] , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                userid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Sql Preparing Error");
        }
    }
    return userid;
}
@end
