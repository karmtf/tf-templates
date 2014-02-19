<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.UPLOAD_UTILS_JS});

	User loggedInUser = SessionManager.getUser(request);
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
    String pkgName = pkgConfig.getPackageName();
	String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, pkgConfig);

    int sourceCityId =  pkgConfig.getExCityId();
    String sourceCity =  (sourceCityId > 0) ? LocationData.getCityNameFromId(sourceCityId): null;
    
    List<Integer> destinationCities = pkgConfig.getDestinationCities();
	List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();

	int totalNoOfNights = pkgConfig.getNumberOfNights();
	List<PackageTag> pkgTags = pkgConfig.getPackageTags();

	ContentWorkItem workItem = (ContentWorkItem) request.getAttribute(Attributes.CONTENT_WORK_ITEM.toString());
%>
<%@page import="com.poc.server.secondary.database.model.ContentWorkItem"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<html>
<head>
<title>Edit Itinerary for <%=pkgConfig.getPackageName()%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<style type="text/css">
.itin{margin-bottom:10px;}
@media screen and (max-width: 830px) {
.left-sidebar {display:none;}
}
@media screen and (max-width: 768px) {
.left-sidebar {display:none;}
}
@media screen and (max-width: 600px) {
.left-sidebar {display:none;}
.three-fourth {width:100%;}
}
</style>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
			<div id="top_content">
				<jsp:include page="/user/includes/nav.jsp">
					<jsp:param name="selectedSideNav" value="products"/>
				</jsp:include>
				<section class="three-fourth" style="background:#fff;padding:10px;width:98%">
				<div class="notification rounded" style="background:rgb(255, 253, 244);font-size: 13px;border:1px solid rgb(240, 235, 202); color: rgb(167, 127, 67);padding:10px;margin:0px 0 10px 0;display:none">
					Once you have edited your itinerary click on Publish Itinerary Button to publish and make your itinerary searchable on TripFactory.
				</div>
				<div class="deals">
					<div class="full-width details" style="position:relative;margin-bottom:0">
						<div class="left">
							<h1 class="mainHeading" style="font-size:20px;max-width:100%"><%=pkgName%>&nbsp;
								<% if(StringUtils.isNotBlank(pkgDetailUrl)) { %>
								<span style="display:inline-block;vertical-align:middle;"><a target="_blank" title="Preview" style="font-size:13px;font-family:arial;padding:7px" href="<%=pkgDetailUrl%>" id="shwMapAct">Preview Itinerary</a></span>
								<% } %>
							</h1>
							<span class="address">
								<%
								int size = cityConfigs.size();
								int index = 0;
								for (CityConfig cityPkgConfig : cityConfigs) {
									int nts = cityPkgConfig.getTotalNumNights();
									String name = cityPkgConfig.getCityNameWithArea();
									int city = cityPkgConfig.getCityId();			
								%>
								<%=nts%>N <a class="productUrl" href="<%=DestinationContentBean.getDestinationContentURL(request, DestinationContentManager.getDestinationFromCityId(city))%>"><%=name%></a>
								<% if (index < (size - 2)) { %>, <% } else if(index == (size-2)) { %> and <% } %>
								<% index++;} %>					
							</span>
						</div>
						<div class="right">
							<% if(loggedInUser.getRoleType() == RoleType.TOUR_OPERATOR) { %>
							<a title="Web Link" class="search-button" href="/partner/price-grid?basePkgId=<%=pkgConfig.getId()%>" id="shwMapAct">Next Step - Add Pricing &raquo;</a>
							<% } %>						
						</div>
						<div class="clearfix"></div>
					</div>
				</div>
				<jsp:include page="/package/includes/edit_itinerary_view_large.jsp">
					<jsp:param name="showCollect" value="true"/>
					<jsp:param name="showCompactView" value="true"/>
				</jsp:include>				
			</section>
			<div class="clearfix"></div>
		</div>
	</div>
<!--//main content-->
</div>
</div>
<!--//main-->
<script type="text/javascript">
function addPlace(cityId, cityName) {
	$jQ('#addNewExpDiv input[name=cId]').val(cityId);
	$jQ('#addNewExpDiv input[name=dName]').val(cityName);
	MODAL_PANEL.show('#addNewExpDiv', {title:'Add a New Experience', blockClass:'lgnRgBlk'});	
}
</script>
<jsp:include page="/place/includes/add_new_experience_form.jsp"></jsp:include>
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
</html>
