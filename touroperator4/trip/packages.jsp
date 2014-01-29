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
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
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
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page session="true" %>
<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
    long destId = RequestUtil.getLongRequestParameter(request, "destId", -1L);
	List<PackageConfigData> packages = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	Map<Long, List<Long>> regions = (Map<Long, List<Long>>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
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
		
		
		
		
		
		
<div class="row-fluid"  style="margin-top: 98px;">
	<div class="span12">
		<div class="container wrapper">
			<div class="span3 margin_left0">
				<div class="row-fluid header1">
					<div class="span12">
						<h1 style="color:#0088CC !important;margin-bottom:-30px">Explore Places</h1>    
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
							if(regions != null) {
								for (Long country : regions.keySet()) {
						%>
						<a class="package_link" href="/tours/packages?destId=<%=country%>" >
							<div><%=DestinationContentManager.getDestinationNameFromId(country)%></div>
							<span class="menu_arrow"></span> </a>
					<% 		} 
						} 
					%>
						</div>
					</div>
				</div>
					
      
      
      
      
<div class="row-fluid margin_top15">
	<div class="span9">
		<div class="container wrapper">
		<!-------------------------- span starts -------------------------->
			<div class="span9 clearfix">
				<div class="row-fluid">
					<div class="span12">
						<div class="row-fluid">
							<div class="span12"></div>
						</div>
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
                        
							<div class="thumbnail span5" style="margin-left:0px;margin-right:43px">
								<div class="row-fluid">
									<div class="span12 gradient_holder share_hover">
										<a href="<%=pkgDetailUrl%>">
											<img class="lazy" src="/static/css/themes/touroperator4/images_1/20_0_Havelock_Island-001_b.jpg" data-original="/static/css/themes/touroperator4/images_1/20_0_Havelock_Island-001_b.jpg" style="display: inline;/*height:209px;width:391px*/">
											<div class="gradient"></div>
											<div class="tourimg_content3 offset1"></div>
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
									</div>
								</div>
								<div class="caption_new"></div>
							</div>
							<% } %>
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
