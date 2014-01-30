
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.user.UserPreferenceKey"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.settings.AppSettingType"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.TourAction"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.TravelTip"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="java.util.Map"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<link href="/static/css/themes/touroperator4/css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/bootstrap-fileupload.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/stylesheet.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/jquery.autocompletefb.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/style.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/bootstrap-select.css" rel="stylesheet" type="text/css" media="screen">
<link href="/static/css/themes/touroperator4/css/animate.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/master.css" rel="stylesheet" type="text/css">

<script src="/static/css/themes/touroperator4/js/cb=gapi.loaded_1" async=""></script>
<script type="text/javascript" async="" src="/static/css/themes/touroperator4/js/cse.js"></script>
<script src="/static/css/themes/touroperator4/js/cb=gapi.loaded_0" async=""></script>
<script src="/static/css/themes/touroperator4/js/jquery-1.9.1.min.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery-migrate-1.1.1.min.js"></script>
<script src="/static/css/themes/touroperator4/js/bootstrap.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery-ui.js"></script>
<script src="/static/css/themes/touroperator4/js/modernizr.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery.lazyload.min.js"></script>
    
<script type="text/javascript" src="/static/css/themes/touroperator4/js/plusone.js" gapi_processed="true"></script>
<script src="/static/css/themes/touroperator4/js/bootstrap-select.js"></script>   

<%
	String docType = (request.getParameter("doc_type") != null) ? request.getParameter("doc_type"): "";
	boolean hideHeader = UIConfig.isHideHeader(request);
	boolean showMinHd = Boolean.parseBoolean(request.getParameter("minHd"));
	Destination destination = null;
	JSONObject json = null;
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	User user = SessionManager.getUser(request);
	User partnerUser = null;
	List<PackageConfigData> packages = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
		UserPreference socialContacts = partnerConfig.getUserPreferenceValue(UserPreferenceKey.SOCIAL_CONTACTS);
		if(socialContacts != null && StringUtils.isNotBlank(socialContacts.getValue())) {
			json = new JSONObject(socialContacts.getValue());
		}		
	}
	UserProfileData profile = (UserProfileData)request.getAttribute(Attributes.USER_PROFILE_DATA.toString());
%>



 <script src="/static/css/themes/touroperator4/js/jsapi" type="text/javascript"></script>
 <link type="text/css" href="/static/css/themes/touroperator4/css/default+en.css" rel="stylesheet">
 <link type="text/css" href="/static/css/themes/touroperator4/css/default.css" rel="stylesheet">
 <script type="text/javascript" src="/static/css/themes/touroperator4/js/default+en.I.js"></script>
 <script type="text/javascript" src="/static/css/themes/touroperator4/js/search.I.js"></script>
 <style type="text/css">
.gsc-control-cse {
font-family: Arial, sans-serif;
border-color: #FFFFFF;
background-color: #FFFFFF;
}
.gsc-control-cse .gsc-table-result {
font-family: Arial, sans-serif;
}
input.gsc-input, .gsc-input-box, .gsc-input-box-hover, .gsc-input-box-focus {
border-color: #D9D9D9;
}
input.gsc-search-button, input.gsc-search-button:hover, input.gsc-search-button:focus {
border-color: #666666;
background-color: #CECECE;
background-image: none;
filter: none;
}
.gsc-tabHeader.gsc-tabhInactive {
border-color: #E9E9E9;
background-color: #E9E9E9;
}
.gsc-tabHeader.gsc-tabhActive {
border-color: #FF9900;
border-bottom-color: #FFFFFF;
background-color: #FFFFFF;
}
.gsc-tabsArea {
border-color: #FF9900;
}
.gsc-webResult.gsc-result,
.gsc-results .gsc-imageResult {
border-color: #FFFFFF;
background-color: #FFFFFF;
}
.gsc-webResult.gsc-result:hover,
.gsc-imageResult:hover {
border-color: #FFFFFF;
background-color: #FFFFFF;
}
.gs-webResult.gs-result a.gs-title:link,
.gs-webResult.gs-result a.gs-title:link b,
.gs-imageResult a.gs-title:link,
.gs-imageResult a.gs-title:link b {
color: #0000CC;
}
.gs-webResult.gs-result a.gs-title:visited,
.gs-webResult.gs-result a.gs-title:visited b,
.gs-imageResult a.gs-title:visited,
.gs-imageResult a.gs-title:visited b {
color: #0000CC;
}
.gs-webResult.gs-result a.gs-title:hover,
.gs-webResult.gs-result a.gs-title:hover b,
.gs-imageResult a.gs-title:hover,
.gs-imageResult a.gs-title:hover b {
color: #0000CC;
}
.gs-webResult.gs-result a.gs-title:active,
.gs-webResult.gs-result a.gs-title:active b,
.gs-imageResult a.gs-title:active,
.gs-imageResult a.gs-title:active b {
color: #0000CC;
}
.gsc-cursor-page {
color: #0000CC;
}
a.gsc-trailing-more-results:link {
color: #0000CC;
}
.gs-webResult .gs-snippet,
.gs-imageResult .gs-snippet,
.gs-fileFormatType {
color: #000000;
}
.gs-webResult div.gs-visibleUrl,
.gs-imageResult div.gs-visibleUrl {
color: #008000;
}
.gs-webResult div.gs-visibleUrl-short {
color: #008000;
}
.gs-webResult div.gs-visibleUrl-short {
display: none;
}
.gs-webResult div.gs-visibleUrl-long {
display: block;
}
.gs-promotion div.gs-visibleUrl-short {
display: none;
}
.gs-promotion div.gs-visibleUrl-long {
display: block;
}
.gsc-cursor-box {
border-color: #FFFFFF;
}
.gsc-results .gsc-cursor-box .gsc-cursor-page {
border-color: #E9E9E9;
background-color: #FFFFFF;
color: #0000CC;
}
.gsc-results .gsc-cursor-box .gsc-cursor-current-page {
border-color: #FF9900;
background-color: #FFFFFF;
color: #0000CC;
}
.gsc-webResult.gsc-result.gsc-promotion {
border-color: #336699;
background-color: #FFFFFF;
}
.gsc-completion-title {
color: #0000CC;
}
.gsc-completion-snippet {
color: #000000;
}
.gs-promotion a.gs-title:link,
.gs-promotion a.gs-title:link *,
.gs-promotion .gs-snippet a:link {
color: #0000CC;
}
.gs-promotion a.gs-title:visited,
.gs-promotion a.gs-title:visited *,
.gs-promotion .gs-snippet a:visited {
color: #0000CC;
}
.gs-promotion a.gs-title:hover,
.gs-promotion a.gs-title:hover *,
.gs-promotion .gs-snippet a:hover {
color: #0000CC;
}
.gs-promotion a.gs-title:active,
.gs-promotion a.gs-title:active *,
.gs-promotion .gs-snippet a:active {
color: #0000CC;
}
.gs-promotion .gs-snippet,
.gs-promotion .gs-title .gs-promotion-title-right,
.gs-promotion .gs-title .gs-promotion-title-right * {
color: #000000;
}
.gs-promotion .gs-visibleUrl,
.gs-promotion .gs-visibleUrl-short {
color: #008000;
}
</style>


<style type="text/css">
ul li {font-size:14px;font-weight:bold}
</style>

</head>

<div class="topmenu" style="position: fixed;top: 0; width: 100%;z-index: 100; ">
    
<!-- top nav -->
<div class="row-fluid">
  <div class="span12 top_menu_wrapper">
    <div class="container top_menu_wrapper2">
                   
    	<div class="navbar navbar-inverse">
                    <div class="navbar-inner">
                        <div class="container top_menu_wrapper">
                            <button class="btn btn-navbar" data-target=".nav-collapse" data-toggle="collapse" type="button">
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <div class="home pull-left btn-link">
								<a href="/" data-hint="Home" class="hint--bottom" style="margin-top:8px">
									<img src="/static/css/themes/touroperator4/images/home.gif">
								</a>
							</div>
                            <div class="nav-collapse collapse">
                                <ul class="nav">
                                  <li class=""><a href="/" id="show_slide1">About us <span class="caret caret1" id="caret1"></span></a> </li>
                                  <li class=""><a href="/" id="show_slide3">Last minute deals <span class="caret caret1" id="caret3"></span></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
	</div>
  </div>
</div>




<!-------------------------- slide_up3 -------------------------->
<div id="slide_up3" class="slide" style="display:none" >
	<div class="row-fluid"  style="background-color: #fff;">
  		       
              <div class="span12" >
                                    <div class="container margin_top15"><br />
                                    <div class="row-fluid"> 
                        <%
						int countLastMinDeal = 0;
						if(packages != null) {
						for(PackageConfigData packageConfiguration : packages) { 
								countLastMinDeal++;
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
								if (countLastMinDeal < 5) {
						%>
                           <div class="span3 deal">
						   <a href="<%=pkgDetailUrl%>"><img class="lazy" src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" data-original="<%=imageUrlComplete%>" style="display: inline;height:153px;width:270px">
                            <div class="gradient2"></div>
							<div class="prize_tag" style="top:134px">
								<% if(dealConfig != null) { %>
												<div class="tag_text1" style="font-size:15px" ><%=PackageDataBean.getPackageDealPricePerPerson(request, packageConfiguration, dealConfig, false)%></div>
										<% } else { %>
												<div class="tag_text1" style="font-size:15px"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></div>
								<% } %>
							</div>
                            <div class="deal_text1"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 30)%></div>
							 <% if(dealConfig != null) { %>
								<div class="deal_text2"><%=packageConfiguration.getNumberOfNights()%> nights</div>
                             <% } %>
                            <br />                            <br />
                            
                          </div>
                        <% } else { break; } } }%> 

                <div class="hide_pannel hide_pannel2"><img id="arrow_up3" width="80" height="26" src="http://hammockholidays.com/images/hide.png" /></div><div class="read_more pull-right"><a href="/tours/packages">More packages</a></div></div></div>
   	  </div>
  </div>
</div>
<!-------------------------- slide_up3 -------------------------->


<!-- slide up 1 -->
<div id="slide_up1" class="slide" style="display:none">
	<div class="row-fluid" style="background-color: #fff;">
  		<div class="span12">
    		<div class="container">
               	<div class="span3">
                <h1><a href="/tours/contactus">Info</a></h1>
                <a href="/tours/contactus"><img src="/static/css/themes/touroperator4/images/about.jpg" title="Know more"/></a>
					<% if(profile != null) {%>
                        <p><%=profile.getUserProfileDescription()%><a href="/tours/contactus">More</a></p>
                    <% }%>
						<div class="hide_pannel"><img src="/static/css/themes/touroperator4/images/hide.png" width="80" height="26" id="arrow_up1" /></div><br />
              </div>
                <div class="span3">
                <h1><a href="/tours/contactus">Contact</a></h1>
                <a href="/tours/contactus"><img src="/static/css/themes/touroperator4/images/contact.jpg" title="Know more"/></a>
                        <p>Phone: <%=partnerUser.m_mobile%><br />
			<a style="color:#000" href="mailto:<%=partnerUser.m_email%>"><%=partnerUser.m_email%></a> <br />
			<a href="/tours/contactus"> More</a></p>
              </div>
    		</div>
    	</div>
    </div>
</div>
<!-- slide up 1 -->






<div class="row-fluid border_bottom nav2_gradiant">
  <div class="span12">
    <div class="container">
      <div class="navbar span5">
        <ul class="nav nav2">
				<!--<li><a href="/tours/welcome">Home</a></li>-->
					<li><a href="/tours/packages">Packages</a></li>
					<li><a href="/tours/tips">Travel Guide</a></li>
					<li><a href="/tours/reviews">Travel Tips</a></li>
					<li><a href="/tours/contactus">Contact</a></li>
         </ul>
      </div>
      <div class="span3">
      <div class="logo_holder"><a href="/" class="navbar-brand logo"><img src="<%=PartnerConfigBean.getPartnerConfigLogoURL(request, partnerConfigData)%>"  style="height:50px;width:150px"></a></div></div>

        <div class="span4">
      <div class="navbar-search_holder">

  
<script>
  (function() {
    var cx = '009514069806777361294:breczqi04p0';
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + cx;
  //  gcse.setLinkTarget(google.search.Search.LINK_TARGET_SELF);
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);
  })();
</script>

 <script>
	
            $(document).ready(function(){

			$(window).load(function(){

				slide_up	=	$("#slide_up1");
				slide_up.slideUp(10);
				
				$("a#show_slide1").click(function(e) {
                                        e.preventDefault();
					
                                        slide_up1.slideUp();
					slide_up2.slideUp();
					slide_up.slideToggle();
					
                                      if($('#caret2').attr("class")=="caret1 caret_up"){
					  $('#caret2').toggleClass("caret caret_up");
				      }
				      
                                      if($('#caret3').attr("class")=="caret1 caret_up"){
					  $('#caret3').toggleClass("caret caret_up");
					}
				      
                                      $('#caret1').toggleClass("caret caret_up");
					
				});
				
				
			    $("img#arrow_up1").click(function(e){
                                        e.preventDefault();
					slide_up.slideUp();
					$('#caret1').toggleClass("caret caret_up");
				});
                        
                                function UpdatePassword(){
                                	$(".hidd").click(function(event){
					event.preventDefault()
					$(".hid").slideDown(500);
			  	     });
                                   }
                                 UpdatePassword();
                                 
				$(".hiddd").click(function(){
					$(".hid").slideUp();
				
				});
				
			
				slide_up1	=	$("#slide_up2");
				slide_up1.slideUp(10);
				
				$("a#show_slide2").click(function(e) {
                                        e.preventDefault();
					slide_up.slideUp();
					slide_up2.slideUp();
					slide_up1.slideToggle();
					if($('#caret1').attr("class")=="caret1 caret_up"){
					  $('#caret1').toggleClass("caret caret_up");
					}
					if($('#caret3').attr("class")=="caret1 caret_up"){
					  $('#caret3').toggleClass("caret caret_up");
					}
					$('#caret2').toggleClass("caret caret_up");
				});
				
				$("img#arrow_up2").click(function(e){
                                        e.preventDefault();
					slide_up1.slideUp();
					$('#caret2').toggleClass("caret caret_up");					
				});
				
				slide_up2	=	$("#slide_up3");
				slide_up2.slideUp(10);
				
				$("a#show_slide3").click(function(e) {
                                        e.preventDefault();
					slide_up.slideUp();
					slide_up1.slideUp();
					slide_up2.slideToggle();
                                        
                                      if($('#caret1').attr("class")=="caret1 caret_up"){
					  $('#caret1').toggleClass("caret caret_up");
					}
                                        
					if($('#caret2').attr("class")=="caret1 caret_up"){
					  $('#caret2').toggleClass("caret caret_up");
					}
                                        
					$('#caret3').toggleClass("caret caret_up");
				});
				
				$("img#arrow_up3").click(function(e){
                                        e.preventDefault();
					slide_up2.slideUp();
					$('#caret3').toggleClass("caret caret_up");
				});
				
                                
				$("#content_1 , #content_2 ,#content_3, .sub_pakage_scroll").mCustomScrollbar({
					scrollButtons:{
						enable:true
					},
                                        advanced:{
                                            updateOnContentResize: true,
                                            autoScrollOnFocus: false
                                        }
                                        
                                                                                  ,   
                                         callbacks:{
                                            onScrollStart: function(){
                                                console.log($(this).offset());
                                                if($(window).scrollTop()<606)
                                                 $('html,body').animate({scrollTop: '400'},1000);
                                                 }
                                         }     
                                     
                                                    
                 
				});

			
				
			});
		})(jQuery);
  $('.carousel').carousel({
    interval: 4000
    })
	</script>
	
	
       
	
	
	
	



<div id="___gcse_0"><div class="gsc-control-cse gsc-control-cse-en"><div class="gsc-control-wrapper-cse" dir="ltr"><form class="gsc-search-box gsc-search-box-tools" accept-charset="utf-8"><table cellspacing="0" cellpadding="0" class="gsc-search-box"><tbody><tr><td class="gsc-input"><div class="gsc-input-box" id="gsc-iw-id1"><table cellspacing="0" cellpadding="0" id="gs_id50" class="gstl_50 " style="width: 100%; padding: 0px;"><tbody><tr><td id="gs_tti50" class="gsib_a"><input autocomplete="off" type="text" size="10" class="gsc-input" name="search" title="search" id="gsc-i-id1" style="width: 100%; padding: 0px; border: none; margin: 0px; height: auto; outline: none;" dir="ltr" spellcheck="false"></td><td class="gsib_b"><div class="gsst_b" id="gs_st50" dir="ltr"><a class="gsst_a" href="javascript:void(0)" style="display: none;"><span class="gscb_a" id="gs_cb50">×</span></a></div></td></tr></tbody></table></div></td><td class="gsc-search-button"><input type="image" src="/static/css/themes/touroperator4/images/search_box_icon.png" class="gsc-search-button gsc-search-button-v2" title="search"></td><td class="gsc-clear-button"><div class="gsc-clear-button" title="clear results">&nbsp;</div></td></tr></tbody></table><table cellspacing="0" cellpadding="0" class="gsc-branding"><tbody><tr style="display: none;"><td class="gsc-branding-user-defined"></td><td class="gsc-branding-text"><div class="gsc-branding-text">powered by</div></td><td class="gsc-branding-img"><img src="/static/css/themes/touroperator4/img/small-logo.png" class="gsc-branding-img"></td></tr></tbody></table></form><div class="gsc-results-wrapper-overlay"><div class="gsc-results-close-btn" tabindex="0"></div><div class="gsc-tabsAreaInvisible"><div class="gsc-tabHeader gsc-inline-block gsc-tabhActive">Web</div><span class="gs-spacer"> </span><div tabindex="0" class=" gsc-tabHeader gsc-tabhInactive gsc-inline-block">Image</div><span class="gs-spacer"> </span></div><div class="gsc-refinementsAreaInvisible"></div><div class="gsc-above-wrapper-area-invisible"><table cellspacing="0" cellpadding="0" class="gsc-above-wrapper-area-container"><tbody><tr><td class="gsc-result-info-container"><div class="gsc-result-info-invisible"></div></td><td class="gsc-orderby-container"><div class="gsc-orderby-invisible"><div class="gsc-orderby-label gsc-inline-block">Sort by:</div><div class="gsc-option-menu-container gsc-inline-block"><div class="gsc-selected-option-container gsc-inline-block"><div class="gsc-selected-option">Relevance</div><div class="gsc-option-selector"></div></div><div class="gsc-option-menu-invisible"><div class="gsc-option-menu-item gsc-option-menu-item-highlighted"><div class="gsc-option">Relevance</div></div><div class="gsc-option-menu-item"><div class="gsc-option">Date</div></div></div></div></div></td></tr></tbody></table></div><div class="gsc-adBlockInvisible"></div><div class="gsc-wrapper"><div class="gsc-adBlockInvisible"></div><div class="gsc-resultsbox-invisible"><div class="gsc-resultsRoot gsc-tabData gsc-tabdActive"><table cellspacing="0" cellpadding="0" class="gsc-resultsHeader"><tbody><tr><td class="gsc-twiddleRegionCell"><div class="gsc-twiddle"><div class="gsc-title">Web</div></div><div class="gsc-stats"></div><div class="gsc-results-selector gsc-all-results-active"><div class="gsc-result-selector gsc-one-result" title="show one result">&nbsp;</div><div class="gsc-result-selector gsc-more-results" title="show more results">&nbsp;</div><div class="gsc-result-selector gsc-all-results" title="show all results">&nbsp;</div></div></td><td class="gsc-configLabelCell"></td></tr></tbody></table><div><div class="gsc-expansionArea"></div></div></div><div class="gsc-resultsRoot gsc-tabData gsc-tabdInactive"><table cellspacing="0" cellpadding="0" class="gsc-resultsHeader"><tbody><tr><td class="gsc-twiddleRegionCell"><div class="gsc-twiddle"><div class="gsc-title">Image</div></div><div class="gsc-stats"></div><div class="gsc-results-selector gsc-all-results-active"><div class="gsc-result-selector gsc-one-result" title="show one result">&nbsp;</div><div class="gsc-result-selector gsc-more-results" title="show more results">&nbsp;</div><div class="gsc-result-selector gsc-all-results" title="show all results">&nbsp;</div></div></td><td class="gsc-configLabelCell"></td></tr></tbody></table><div><div class="gsc-expansionArea"></div></div></div></div></div></div><div class="gsc-modal-background-image" tabindex="0"></div></div></div></div>
<!--       <form class="navbar-search">
          <input type="text" placeholder="Search" class="search-query input-medium">
          <div class="icon-search"></div>
        </form>-->
        </div>
      </div>
    </div>
  </div>
</div>
</div>



<script type="text/javascript">
SERVER_VARS._DOCTYPE = '<%=docType%>';
</script>

