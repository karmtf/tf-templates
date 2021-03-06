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
                 java.util.Set,
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
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
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.ui.SessionManager"%>

<%@page session="true" %>
<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
	List<Integer> countries = (List<Integer>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
	Destination cityDestination = (Destination) request.getAttribute(Attributes.DESTINATION_DATA.toString());
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
                
			<div class="row-fluid"  style="margin-top: 98px;">
				<div class="span12">
					<div class="container wrapper">
						<div class="span3 margin_left0">
							<div class="row-fluid header1">
								<div class="span12">
									<h1 style="color:#0088CC !important">Travel Tips</h1>    
								</div>
							</div>
							<div class="row-fluid">
								<div class="span12">
									<div class="caret"></div>
								</div>
							</div>
							<br>
							<div class="row-fluid" id="menu">
								<div class="span12">
					  
							<% 
								if(countries != null) {
									for (Integer country : countries) {        
							%>
								<a class="package_link" href="/tours/tips?destId=<%=country%>" >
									<div><%=LocationData.getCityNameFromId(country)%></div>
										<span class="menu_arrow"></span> </a>

							<%}  
							} 
							%>
							</div>
						</div>
					</div>
                                        
      
                                          
					<div class="row-fluid">
						<div class="span8">
							<div class="container wrapper">
							
							<div class="row-fluid header1">
								<div class="span8">
									<h1 ><%=cityDestination.getName()%></h1>    
								</div>
							</div>
							<div class="row-fluid">
								<div class="span8">
									<div class="caret"></div>
								</div>
							</div>

								
							<div class="row-fluid">
								<div class="span8">
									<jsp:include page="city_general_details.jsp" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>  
		</div>
	</div>  
</div>





<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
