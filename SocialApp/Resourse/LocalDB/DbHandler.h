//
//  DbHandler.h
//  Bible
//
//  Created by MaDdy on 19/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DbName @"SocialApp.sqlite"

@interface DbHandler : NSObject {
    
}
+(void)createEditableCopyOfDatabaseIfNeeded;
+(NSString *) dataFilePath:(NSString *)path;
+(void)openDatabase;
+(BOOL)deletenotification:(NSString *)rid;
+(void)closeDatabase;
+(BOOL)isDatabaseOpened;
+(NSMutableArray *)fetchnotification;
+(BOOL)deleteDatafromtable:(NSString *)query;
+(NSMutableArray *)Fetchtempuserdetail;
+(BOOL)Insertuser:(NSString *)_userid firstname:(NSString *)_firstname lastname:(NSString *)_lastname email:(NSString *)_email profileimage:(NSString *)_profileimage password:(NSString *)_password;
+(BOOL)updateuser:(NSString *)memberid firstname:(NSString *)_firstname lastname:(NSString *)_lastname gender:(NSString *)_gender profileimage:(NSString *)_profileimage mobile:(NSString *)_mobile;
+(NSString *)checkuserexist;
+(NSString *)checkusertype;
+(NSMutableArray *)Fetchusertoken;
+(BOOL)Insertnotification:(NSString *)_propertyname priority:(int)_priority  title:(NSString *)_title type:(int )_type typename:(NSString *)_typename mid:(int)_mid  name:(NSString *)_name houseno:(NSString *)_houseno email:(NSString *)_email mobile:(NSString *)_mobile message:(NSString *)_message;
+(NSString *)GetId:(NSString *)strqry;
+(NSMutableArray *)Fetchuserdetail;
+(BOOL)updateuseremail:(NSString *)_userid  email:(NSString *)_email;
+(BOOL)updateuserimage:(NSString *)_userid  image:(NSString *)_image fname:(NSString *)_fname lname:(NSString *)_lname midname:(NSString *)_midname;
+(NSString *)getstringvalue:(NSString *)strqry;
+(BOOL)updatejobstatus:(NSString *)userid jobstatus:(NSString *)_jobstatus;
+(BOOL)Insertlocation:(NSString *)_lat lng:(NSString *)_lng datetime:(NSString *)_datetime;
+(BOOL)updatepassword:(NSString *)_userid  password:(NSString *)_password;
+(BOOL)updateuserimage:(NSString *)_userid  image:(NSString *)_image fname:(NSString *)_fname;
+(BOOL)updatestepeleven:(NSString *)_streetaddress address2:(NSString *)_address2 city:(NSString *)_city state:(NSString *)_state zipcode:(NSString *)_zipcode cityname:(NSString *)_cityname statename:(NSString *)_statename;
+(BOOL)updatesteptewlve:(NSString *)_firstname lastname:(NSString *)_lastname dob:(NSString *)_dob email:(NSString *)_email phonenumber:(NSString *)_phonenumber ;
+(BOOL)updateuserpoint:(NSString *)_userid  walletpoint:(NSString *)_walletpoint;
+(BOOL)Insertcart:(NSString *)_productid productname:(NSString *)_productname productprice:(NSString *)_productprice productsize:(NSString *)_productsize productimage:(NSString *)_productimage productqty:(NSString *)_productqty productvariantid:(NSString *)_productvariantid totalprice:(NSString *)_totalprice;
+(NSString *)checkCartProductExist:(NSString *)_productvariantid;
+(NSString *)cartitemcount;
+(NSString *)checkserviceexist:(NSString *)_serviceid;
+(NSMutableArray *)FetchCartItems;
+(BOOL)deletecartitem:(NSString *)_productid;
+(NSString *)sumcart;
+(NSMutableArray *)FetchCart;
+(BOOL)updatecartqty:(NSString *)_id productqty:(NSString *)_productqty totalprice:(NSString *)_totalprice;
+(NSString*)getcartqty:(NSString *)_id;
+(NSString*)Deleteitemfromcart:(NSString *)_id;
+(BOOL)updateuser:(NSString *)memberid fullname:(NSString *)_fullname profileimage:(NSString *)_profileimage profileimagethumb:(NSString *)_profileimagethumb mobile:(NSString *)_mobile;

+(BOOL)InsertCourse:(NSString *)_course_id course_name:(NSString *)_course_name course_image:(NSString *)_course_image course_start_date:(NSString *)_course_start_date course_instructor_image:(NSString *)_course_instructor_image course_fees:(NSString *)_course_fees course_qty:(NSString *)_course_qty course_instructor_name:(NSString *)_course_instructor_name dateid:(NSString *)_dateid;
+(NSMutableArray *)FetchCourseDetails;
+(NSString *)sumofCourseCart;
+(NSString *)sumofProductCart;
+(NSString *)sumServiceCart;
+(NSString*)getCourseCartQty:(NSString *)_id;
+(BOOL)updateCourseCartQty:(NSString *)_id course_qty:(NSString *)_course_qty course_fees:(NSString *)_course_fees;
+(NSString *)sumCourseCart;
+(NSString *)checkCourseExist:(NSString *)_course_id;
+(BOOL)deleteCourseInCart:(NSString *)_id;
+(BOOL)InsertService:(NSString *)_serviceid servicename:(NSString *)_servicename serviceprice:(NSString *)_serviceprice addon:(NSString *)_addon
         addonprice:(NSString *)_addonprice totalprice:(NSString *)_totalprice servicedate:(NSString *)_servicedate servicetime:(NSString *)_servicetime SubCategoryName:(NSString *)_SubCategoryName SubCategoryID:(NSString *)_SubCategoryID;
+(NSMutableArray *)FetchServiceDetails;
+(NSString *)checkServiceCartProductExist:(NSString *)_serviceid;
+(NSString *)sumofServiceCart;
+(NSString *)sumofServiceCartAddon;
+(BOOL)updateservicrtimedate:(NSString *)_id servicedate:(NSString *)_servicedate servicetime:(NSString *)_servicetime;
+(BOOL)deleteServiceInCart:(NSString *)_id;
@end
