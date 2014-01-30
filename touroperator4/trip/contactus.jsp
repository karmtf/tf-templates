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
                 java.util.ArrayList,
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.page.TopicPageType"%>
<%@page import="com.eos.b2c.page.TopicPageBean"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.action.TourAction"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.page.TopicPage"%>
<%@page import="com.eos.accounts.user.UserPreferenceKey"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.user.wall.UserWallItemWrapper"%>
<%@ page session="true" %>

<%	
	String title = "Contact us";
	String keywords = "";
	String description = "";
	JSONObject json = null;
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	User user = SessionManager.getUser(request);
	User partnerUser = null;
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
		UserPreference socialContacts = partnerConfig.getUserPreferenceValue(UserPreferenceKey.SOCIAL_CONTACTS);
		if(socialContacts != null && StringUtils.isNotBlank(socialContacts.getValue())) {
			json = new JSONObject(socialContacts.getValue());
		}		
	}
	
	UserProfileData profile = (UserProfileData)request.getAttribute(Attributes.USER_PROFILE_DATA.toString());
    List<TravelServicesType> services =  null;
    if (profile != null) {
        services = profile.getTravelServices();
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
		<link href="/static/css/themes/touroperator4/css/master-main.css" rel="stylesheet" type="text/css">




		<div class="row-fluid" style="margin-top:100px">

			<div class="span12">
				<div class="container about wrapper1 margin_top15">
				  <!-------------- about holder ----------------->
					<div class="row-fluid">
						<div class="span12">
							<div class="span12 margin_left0">
								<div class="margin_top17">
								<h1 class="offset1">About us</h1>
								
								
								
								<% if(profile != null && profile.getUserProfileDescription() != null && !profile.getUserProfileDescription().equals("null")) { %>
								<p class="margin_top15 offset1"><%=profile.getUserProfileDescription()%></p>
								<% } %>
								
								<% if (services != null) {%>
								<p class="margin_top15 offset1" style="padding-left:10px">
										<%        int k = 0;
												for(TravelServicesType service : services) { 
														if(k > 7) {
																break;
														}
										%>
										<%=service.getDisplayName()%><br>
										<% k++;} %>                  
								</p>                                                      
								<% } %>

								
								
								
								
							</div>
						</div>
					</div>
				</div>
				  <!-------------- about holder -----------------> 
			</div>
		
				<div class="container contact1 wrapper1 margin_top15">
			
					<div class="row-fluid contact_us">
					<h1>Contact Us</h1>
					</div>
				</div>
			<div class="container contact1 wrapper1 margin_top15" >

				<div class="row-fluid">
					<div class="span12">
							<div class="span6 contact_form">
								<div class=" ">
									<h1 >Address</h1>
									<p><%=partnerUser.m_street%><br>
										<%=LocationData.getCityNameFromId(partnerUser.getCityId())%> - <%=partnerUser.m_pincode%><br> </p>
									<h1>Phone</h1>
									<p><%=partnerUser.m_mobile%></p>
									<h1>Email</h1>
									<p><a href="mailto:<%=partnerUser.m_email%>"> <%=partnerUser.m_email%></a></p> 
								</div>
							</div>
							  
							  
							<div class="span6 contact_form ">
								<span id="enq_error"></span>  
									<form class="contact_form" name="contact_form" action="#" method="post" >
										<div id="cnt_error"></div>  
										<input type="hidden" name="source" id="hidden_val" type="text" value="contact_page" />
										
										<div class="row-fluid">
											<div class="span6">
												<label>Name*</label>
												<input type="text" class="span12" placeholder="Your Name" name="name"  pattern="[a-zA-Z ]+" title="Please Enter only letters of the alphabet" value="" required/>
												<p class="err-msg"></p>
											</div>
											<div class="span6">
												<label>Phone Number*</label>
												<input type="text" class="span12" placeholder="Your Phone Number" name="mobile" value="" pattern="[0-9]+" required  title="Please Enter only numbers"/>
												<p class="err-msg"></p>
											</div>
										</div>
										
										<div class="row-fluid">
											<div class="span6">
												<label>Email ID*</label>
												<input type="email" class="span12" placeholder="Your Email ID" required title="Please Enter Valid Email ID" name="email" value="" />
												<p class="err-msg"></p>
											</div>
											<div class="span6">
												<label>City*</label>
												<input type="text" class="span12" placeholder="Your City" name="city"  pattern="[a-zA-Z ]+" title="Please Enter only letters of the alphabet" value="" required/>
												<p class="err-msg"></p>
											</div>
										</div>
										
										<div class="row-fluid">
											<div class="span12">
												<label>Place You Love</label>
												<textarea class="span12"  id="inputEmail" placeholder="Place You Love" name="message"></textarea>
											</div>
										</div>
										<div class="controls">
										<button class="btn2 margin_left0" type="submit" name="submit" >Submit</button>
										</div>
									 </form> 
									</div>           
								</div>
							</div>
						</div>
					</div>
				</div>     
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
$jQ(".contact-submit").click(function () {
	var successLoadDt = function(a, m) {
		MODAL_PANEL.hide();
		$jQ('.message-box-wrapper').html(m);
		$jQ('.message-box-wrapper').show();
	}
	AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TOURS, TourAction.SENDMESSAGE)%>', 
		{params:$jQ('.gdl-contact-form').serialize(), scope:this, success: {parseMsg:true, handler: successLoadDt}});
	return false;		
 });
</script> <!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
