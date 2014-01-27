<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@ page import='com.eos.b2c.ui.*,
				 com.eos.accounts.UserManagerFilter,
				 com.eos.accounts.data.User,
				 com.eos.gds.util.FareCalendar,
				 com.eos.b2c.ui.B2cContext,
				 java.text.SimpleDateFormat,
				 java.text.NumberFormat,
                 java.util.List,
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelerTipType"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.model.StayConfig"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.TravelTip"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.ui.SessionManager"%>
<link href="/static/css/themes/touroperator4/css/master.css" rel="stylesheet" type="text/css">
<%@ page session="true" %>
<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
	List<PackageConfigData> packages = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	List<TravelTip> tips = (List<TravelTip>) request.getAttribute(Attributes.TRAVEL_TIPS.toString());
	UserProfileData profile = (UserProfileData)request.getAttribute(Attributes.USER_PROFILE_DATA.toString());
	List<TravelServicesType> services = profile.getTravelServices();
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	User user = SessionManager.getUser(request);
	SimpleDateFormat df = new SimpleDateFormat("dd MMM yyyy");
	User partnerUser = null;
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
	}	
%>
<html>
<head>
<TITLE><%=title%></TITLE>
<!--  featured_search_results, /hotel/includes/featured_hotel_details -->
<meta name="keywords" content="<%=keywords%>" />
<meta name="description" content="<%=description%>" />
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body class="home page">
<div class="body-outer-wrapper">
	<div class="body-wrapper">
		<jsp:include page="/common/includes/viacom/header_new.jsp" />
		
		
		
		<div class="row-fluid slider">
		<div class="span12">
          <div class="carousel slide max_width_1600" id="myCarousel" onmouseover="return nav_show()" onmouseout="return nav_hide()">
              <div class="carousel-inner" style="margin-top: 98px;">
					
					
						<%
							int count = 0;
							for(PackageConfigData packageConfiguration : packages) { 
									List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
									String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
									String imageUrl = packageConfiguration.getImageURL(request); 
									Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
									PackageOptionalConfig dealConfig = null;
									if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
											dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
									}
                        %>
						<% count = count + 1;
							if (count == 1) { %>
							<div class="item active slider_holder">
						<%	} else { %>
							<div class="item">
						<%  } %>
						
                           <!--<img alt="" class="lazy" src="<%=imageUrl%>" data-original="<%=imageUrl%>" style="display: block;"> -->
                           <img alt="" class="lazy" src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" data-original="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" style="display: block;height:387px;width:1300px"> 
                           <div class="slider_content" onmouseover="size_show()">
                           <img src="/static/css/themes/touroperator4/images/camera.png">
                           <div class="slider_text size_show" onmouseout="size_hide()"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 25)%><a href="<%=pkgDetailUrl%>"> Know more</a></div>
                          </div>
                          </div>
						
						<% }%>
               </div>
               <a class="left carousel-control" data-slide="prev" href="http://hammockholidays.com/#myCarousel" style="display: none;" id="right_link"><img src="/static/css/themes/touroperator4/images/slider_arrow_left.png" width="31" height="46"></a>
               <a class="right carousel-control" data-slide="next" href="http://hammockholidays.com/#myCarousel" style="display: none;" id="left_link"><img src="/static/css/themes/touroperator4/images/slider_arrow_right.png" width="31" height="46"></a>
               </div></div></div>   






<div class="row-fluid margin_top15">
  <div class="span12">
    <div class="container wrapper">
    <!-------------------------- span4 -------------------------->
    
      <div class="span4 clearfix">
        <div class="row-fluid">
          <div class="span12">
          	<div class="header1">
              <div class="row-fluid">
              </div>
              <div class="row-fluid">
                <div class="span12">
                
                  <div class="btn-group">
               
                     <button class="btn btn-inverse dropdown-toggle dropdown" data-toggle="dropdown" data-hover="dropdown">Special packages. 
                     <span class="caret"></span></button>
                        <ul class="dropdown-menu">

							<%
							for(PackageConfigData packageConfiguration : packages) { 
								String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
							%>
								<li><a href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></a></li>
							<% } %>
                         </ul>
                  </div>

                  
                </div>
              </div>
            </div>
              
            <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
              </div>
            </div>
            <div id="content_1" class="content_1 mCustomScrollbar _mCS_1"><div class="mCustomScrollBox mCS-light" id="mCSB_1" style="position:relative; height:100%; overflow:hidden; max-width:100%;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;">
                     <div class="row-fluid new_thumbnail">
                        <div class="span12">
                        
                        
                        
						<%
						int countPackage = 0;
						for(PackageConfigData packageConfiguration : packages) { 
								countPackage++;
								List<Integer> cities = packageConfiguration.getDestinationCities();
								String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
								String imageUrl = packageConfiguration.getImageURL(request); 
								String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
								String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
								Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
								List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
								List<ExtraOptionConfig> extraOptions = packageConfiguration.getExtraOptions();
								PackageOptionalConfig dealConfig = null;
								if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
										dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
								}
						%>
                        
                        
                        <% if(countPackage == 3) { %>
                        
                                                
                        <div class="plan_your_trip_form">
                                         <h1>Contact us to plan your trip</h1>
                                             <span id="enq_error"></span>   
						<form name="contact" class="bs-docs-example form-horizontal plan_a_tour" action="http://hammockholidays.com/main/contactform_sendmail" method="post">
						<div class="plan_your_trip">
                                                  <input type="hidden" name="hidden_val" id="hidden_val">
                                              <input type="hidden" name="source" value="plan_a_tour">  
                                                    <table width="100%" border="0" cellpadding="0">        
                                    			<tbody><tr>
                                                 <td><label for="inputEmail" class="control-label">Name*</label></td>
                                               </tr>
                                                <tr>
						<td><input type="text" id="inputEmail" name="name" pattern="[a-zA-Z ]+" title="Please Enter only letters of the alphabet" value="" required="">
                                                    <p class="err-msg"></p>
													</td>
                                           		</tr>
                                      
                                            	<tr>
                                                <td>
                                               <label for="inputEmail" class="control-label">Email*</label>
                                              		
                                                   <input type="email" id="inputEmail" required="" title="Please Enter Valid Email ID" name="email" value="">
                                                   <p class="err-msg"></p>
												   </td>
                                             	</tr>
                                  
                                             <tr><td>
                                               <label for="inputPassword" class="control-label">Mobile*</label>
                                            	
                                                 <input type="text" id="inputPassword" name="mobile" pattern="[0-9+ ]+" title="Please Enter only Numbers" value="" required="">
                                                 <p class="err-msg"></p>
												</td>
                                           	 </tr>   
                                   	
                                             <tr><td>
                                               <label for="inputPassword" class="control-label">How can i help you?</label>
                                                
                                                 <textarea id="inputEmail" name="message"></textarea>
                                                </td>    
                                          	 </tr> 
                                         	<tr>
                                                <td> <button class="btn2" type="submit" name="submit" value="Submit">Submit</button></td>  
											</tr> 
                                            </tbody></table>
											</div>
                                        </form>
                                    </div>
                        
                        
                        <% } %>
                        
                        <div class="thumbnail">
								  <div class="row-fluid">
								  <div class="span12 gradient_holder share_hover">
								   <a href="<%=pkgDetailUrl%>">
									 <img class="lazy" src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" data-original="<%=imageUrlComplete%>" style="display: inline;height:209px;width:370px">
									   <div class="gradient"></div>
									   <div class="tourimg_content3 offset1">
									   
										   
									</div>
							<div class="prize_tag" style="top:190px">

								<% if(dealConfig != null) { %>
												<div class="tag_text1" style="font-size:15px" ><%=PackageDataBean.getPackageDealPricePerPerson(request, packageConfiguration, dealConfig, false)%></div>
										<% } else { %>
												<div class="tag_text1" style="font-size:15px"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></div>
								<% } %>

							</div>
                            <div class="deal_text1"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></div>
                            <div class="deal_text2"></div>
									 </a>
									 </div></div>
								 <div class="caption_new"></div>
								 </div>

                        
                        
                        <% } %>

                       <a href="/tours/packages"><button type="button" class="btn btn-success view-all">View All Packages</button></a></div>
                    </div>
                    </div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
            </div>
        </div>
      </div>              
    <!-------------------------- span4 Ends -------------------------->


    <!-------------------------- span3 Starts-------------------------->
    
      <div class="span3 clearfix">
        <div class="row-fluid">
          <div class="span12">
          	<div class="header1">
              <div class="row-fluid">
              </div>
              <div class="row-fluid">
                <div class="span12">
                
                  <div class="btn-group">
               
                     <button class="btn btn-inverse dropdown-toggle dropdown" data-toggle="dropdown" data-hover="dropdown">Special packages. 
                     <span class="caret"></span></button>
                        <ul class="dropdown-menu">

						<%
						for(PackageConfigData packageConfiguration : packages) { 
								String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
						%>
                        <li><a href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></a></li>
						
						<% } %>
   
                        </ul>
                  </div>

                  
                </div>
              </div>
            </div>
              
            <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
              </div>
            </div>
            <div id="content_1" class="content_1 mCustomScrollbar _mCS_1"><div class="mCustomScrollBox mCS-light" id="mCSB_1" style="position:relative; height:100%; overflow:hidden; max-width:100%;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;">
                     <div class="row-fluid new_thumbnail">
                        <div class="span12">
                        
                        
                        
						<%
						for(PackageConfigData packageConfiguration : packages) { 
								List<Integer> cities = packageConfiguration.getDestinationCities();
								String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
								String imageUrl = packageConfiguration.getImageURL(request); 
								String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
								String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
								Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
								List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
								List<ExtraOptionConfig> extraOptions = packageConfiguration.getExtraOptions();
								PackageOptionalConfig dealConfig = null;
								if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
										dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
								}
						%>
                        
                        <div class="thumbnail">
								  <div class="row-fluid">
								  <div class="span12 gradient_holder share_hover">
								   <a href="<%=pkgDetailUrl%>">
									 <img class="lazy" src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" data-original="<%=imageUrlComplete%>" style="display: inline;height:153px;width:270px">
									   <div class="gradient"></div>
									   <div class="tourimg_content3 offset1">
									   
										   
									</div>
							<div class="prize_tag" style="top:134px">

								<% if(dealConfig != null) { %>
												<div class="tag_text1" style="font-size:15px" ><%=PackageDataBean.getPackageDealPricePerPerson(request, packageConfiguration, dealConfig, false)%></div>
										<% } else { %>
												<div class="tag_text1" style="font-size:15px"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></div>
								<% } %>

							</div>
                            <div class="deal_text1"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></div>
                            <div class="deal_text2"></div>
									 </a>
									 </div></div>
								 <div class="caption_new"></div>
								 </div>

                        
                        
                        <% } %>

                       <a href="/tours/packages"><button type="button" class="btn btn-success view-all">View All Packages</button></a></div>
                    </div>
                    </div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
            </div>
        </div>
      </div>              

    <!-------------------------- span3 ends-------------------------->
    <!-------------------------- span5 starts -------------------------->
    
      <div class="span5 clearfix">
        <div class="row-fluid">
          <div class="span12">
          	<div class="header1">
              <div class="row-fluid">
              </div>
              <div class="row-fluid">
                <div class="span12">
                
                  <div class="btn-group">
               
                     <button class="btn btn-inverse dropdown-toggle dropdown" data-toggle="dropdown" data-hover="dropdown">Special packages. 
                     <span class="caret"></span></button>
                        <ul class="dropdown-menu">

						<%
						for(PackageConfigData packageConfiguration : packages) { 
								List<Integer> cities = packageConfiguration.getDestinationCities();
								String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
								String imageUrl = packageConfiguration.getImageURL(request); 
								String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
								String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
								Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
								List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
								List<ExtraOptionConfig> extraOptions = packageConfiguration.getExtraOptions();
								PackageOptionalConfig dealConfig = null;
								if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
										dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
								}
						%>
                        <li><a href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></a></li>
						
						<% } %>
   
                        </ul>
                  </div>

                  
                </div>
              </div>
            </div>
              
            <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
              </div>
            </div>
            <div id="content_1" class="content_1 mCustomScrollbar _mCS_1"><div class="mCustomScrollBox mCS-light" id="mCSB_1" style="position:relative; height:100%; overflow:hidden; max-width:100%;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;">
                     <div class="row-fluid new_thumbnail">
                        <div class="span12">
                        
                        
                        
						<%
						for(PackageConfigData packageConfiguration : packages) { 
								List<Integer> cities = packageConfiguration.getDestinationCities();
								String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
								String imageUrl = packageConfiguration.getImageURL(request); 
								String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
								String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
								Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
								List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
								List<ExtraOptionConfig> extraOptions = packageConfiguration.getExtraOptions();
								PackageOptionalConfig dealConfig = null;
								if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
										dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
								}
						%>
                        
                        <div class="thumbnail">
								  <div class="row-fluid">
								  <div class="span12 gradient_holder share_hover">
								   <a href="<%=pkgDetailUrl%>">
									 <img class="lazy" src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" data-original="<%=imageUrlComplete%>" style="display: inline;height:265px;width:470px">
									   <div class="gradient"></div>
									   <div class="tourimg_content3 offset1">
									   
										   
									</div>
							<div class="prize_tag" style="top:229px">

								<% if(dealConfig != null) { %>
												<div class="tag_text1" style="font-size:15px" ><%=PackageDataBean.getPackageDealPricePerPerson(request, packageConfiguration, dealConfig, false)%></div>
										<% } else { %>
												<div class="tag_text1" style="font-size:15px"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></div>
								<% } %>

							</div>
                            <div class="deal_text1"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></div>
                            <div class="deal_text2"></div>
									 </a>
									 </div></div>
								 <div class="caption_new"></div>
								 </div>

                        
                        
                        <% } %>

                       <a href="/tours/packages"><button type="button" class="btn btn-success view-all">View All Packages</button></a></div>
                    </div>
                    </div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
            </div>
        </div>
      </div>              






		
		
		
	</div>
</div>



  <script>
  console.log(1234);
      $('a.tooltips').tooltip();
        //on click show send to friend form
  function send_to_friend(i){ 
         $('#send_to_friend_form'+i).toggle('show');
         return false;
  } 
  
 $(document).mouseup(function (e)
  {
    var container = $(".send_to_friend_form");

    if (container.has(e.target).length === 0)
    {
        container.slideUp();
    }
});
 
 //on click show equire form 
   function mywishlist_enquire(i){       
       console.log(i);
         $('#enquire_now'+i).toggle('show');
         return false;
   }
   
  
    function close_send_to_friend(i){
       $('#send_to_friend_form'+i).slideUp('show');
         return false;
   }
   
   function close_pack_enq(i){
        $('#enquire_now'+i).slideUp('show');
         return false;
   }
     function close_pack_enq_1(i){
         console.log(i);
        $('#pack_enquire'+i).slideUp('show');
         return false;
   }
      ///////// for tool tip

    function size_show(){
                $(".size_show").show();
	}

    function size_hide(){
                $(".size_show").hide();
	}
    
    function nav_show(){
                    $("#right_link").css({'display': 'block'});
                    $("#left_link").css({'display': 'block'});
                    return false;
	}
	
    function nav_hide(){
                    $("#right_link").css({'display': 'none'});
                    $("#left_link").css({'display': 'none'});
                    return false;
        }	
               		
  </script>




<jsp:include page="/includes/footTags.jsp"/>
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("p").truncate({max_length:400});
});
$jQ(".slideshow .slides").cycle({fx: 'fade', speed: 1000, timeout: 5000, pause: 1});
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
