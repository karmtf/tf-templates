<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.language.util.LanguageConstants"%>
<%@page import="com.eos.language.util.LanguageBundle"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.gds.data.Carrier"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.holiday.data.TransportOption"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%
	PackageConfigData packageConfiguration = (PackageConfigData) request.getAttribute(Attributes.PACKAGE.toString());
	boolean showEditOption = Boolean.parseBoolean(request.getParameter("creator"));
	if (packageConfiguration.getConfigType() == PackageConfigType.ITINERARY) {
%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<jsp:include page="package_itn_short_view.jsp">
	<jsp:param name="showEdit" value="<%=showEditOption%>" />
</jsp:include>
<% } else { 
	List<TransportConfig> transports = packageConfiguration.getTransportConfigs();
	List<ExtraOptionConfig> extras = packageConfiguration.getExtraOptions();
	TransportOption transport = null;
	if(transports != null && !transports.isEmpty()) {
		transport = transports.get(0).getTransportOption();
	}
%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.secondary.database.model.UserPackageAssociation"%>
<%@page import="java.util.Map"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.TransportConfig"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.holiday.data.PackageDescType"%>
<%@page import="com.eos.b2c.data.LocationData.CityItem"%>
<%@page import="com.eos.b2c.user.destination.UserDestinationListType"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.search.data.PackageMatchParam"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.model.StayConfig"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	String clazz = StringUtils.trimToEmpty(request.getParameter("clazz"));
	String alert = request.getParameter("alert");
	boolean showPick = Boolean.parseBoolean(request.getParameter("showPick"));
	UserPackageAssociation userPkgAssociation = packageConfiguration.getUserPackageAssociation();
	boolean isDraft = (packageConfiguration.isDraftConfig());
	boolean isPkgPicked = (userPkgAssociation != null && userPkgAssociation.isPicked());
	boolean hasUserBeenToAllCities = packageConfiguration.hasUserBeenToAllCities();
	boolean isSystemUser = UIHelper.isSystemUser(loggedInUser);

	CityConfig cityCfg = packageConfiguration.getCityConfigs().get(0);
	PackageMatchParam pkgMatchParam = packageConfiguration.getSearchMatchParams();
	List<String> cityItnNames = packageConfiguration.getItineraryDisplayNames();
	Map<String, Map<PackageDescType, List<String>>> descMap = PackageConfigManager.generatePackageInclusionsForPreview(packageConfiguration);
	List<String> cityNames = packageConfiguration.getDestinationCityNames();
	String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
	List<PackageTag> pkgTags = packageConfiguration.getPackageTags();
	List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
	
	Set<PackageTag> tags = new HashSet<PackageTag>();
	tags.addAll(pkgTags);
	List<Integer> cities = packageConfiguration.getDestinationCities();
	Destination place = DestinationContentBean.getDestinationFromCityId(cities.get(0), false);

	String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
	String imageUrl = packageConfiguration.getImageURL(request); 
	String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);

	Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
	PackageOptionalConfig dealConfig = null;
	if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
		dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
	}
%>
<%@page import="com.eos.b2c.holiday.data.PackageConfigType"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<div id="pkgSV<%=packageConfiguration.getId()%>" class="pkgSmV itinerary-result">
	<article class="full-width mrgn10B" style="width:100%;margin-right:10px;border:1px solid #eee;margin-bottom:10px;">
	<figure>
		<a class="productUrl" href="<%=pkgDetailUrl%>"><img src="<%=imageUrlComplete%>" style="height:145px;border:1px solid rgba(0,0,0,.2);border-radius:3px;width:100%" /></a>
	</figure>
	<div class="details" style="padding-top:15px;">
		<h1><a class="productUrl title" <%=TripBean.getProductDescriptionHtmlParams(ViaProductType.HOLIDAY, packageConfiguration)%> style="text-decoration:none" title="<%=packageConfiguration.getPackageName()%>" href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 45)%></a></h1>
		<span class="address" style="width:100%">
			<% if (packageConfiguration.getExCityId() > 0 && packageConfiguration.getExCityId() != cityCfg.getCityId()) { %>
				from <%=LocationData.getCityNameFromId(packageConfiguration.getExCityId())%> -
			<% } %>
			<%
			int size = cityConfigs.size();
			int index = 0;
			for (CityConfig cityPkgConfig : cityConfigs) {
				int nts = cityPkgConfig.getTotalNumNights();
				String name = cityPkgConfig.getCityNameWithArea();
				int city = cityPkgConfig.getCityId();
				if(index > 4) {
					break;
				}
			%>
			<%=nts%>N <a class="productUrl" href="<%=DestinationContentBean.getDestinationContentURL(request, DestinationContentManager.getDestinationFromCityId(city))%>"><%=name%></a>
			<% if (index < size - 1) { %> | <% } %>
			<% index++;} %>		
		</span>
		<div class="description">
			<ul class="tags" style="min-height:45px">
				<%
					index = 0;
					Set<SellableUnitType> units = new HashSet<SellableUnitType>();
					for (ExtraOptionConfig extra : extras) {
						if(extra.getUnitType() == SellableUnitType.HOTEL_EXTRAS || units.contains(extra.getUnitType())) {
							continue;
						}
				%>
				<li><%=extra.getUnitType().getDesc()%></li>
				<% units.add(extra.getUnitType());} %>
				<% if (pkgMatchParam != null && !pkgMatchParam.getPkgOptionalsToIncludeMap().isEmpty()) { %>
				<%
					for (Integer cityId: pkgMatchParam.getPkgOptionalsToIncludeMap().keySet()) {
					    List<PackageOptionalConfig> optionals = pkgMatchParam.getPkgOptionalsToIncludeMap().get(cityId);
				%>
				<% for (PackageOptionalConfig optional : optionals) { %>
				<% if(optional.getSellableUnitType() != SellableUnitType.HOTEL_ROOM && !units.contains(optional.getSellableUnitType())) { %> 
					<li><%=optional.getSellableUnitType().getDesc()%></li>
				<% units.add(optional.getSellableUnitType()); } else if(optional.getSellableUnitType() == SellableUnitType.HOTEL_ROOM && optional.getSupplierDeals() != null && !optional.getSupplierDeals().isEmpty()) { %>
				<% for(SellableUnitType type : optional.getSupplierDeals()) {
					if(!units.contains(type)) {					 
				%>
				<li><%=type.getDesc()%></li>
				<% units.add(type); } %>
				<% } %>
				<% } %>
				<% } %>				
				<% } %>
				<% } %>
			</ul>
			<div class="clearfix"></div>
			<% if(packageConfiguration.getPricePerPerson() > 0) { %>
			<% if(dealConfig != null) { %>
			<span style="text-decoration:line-through;font-size:13px;">
				<%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, true)%>
			</span>
			<span style="font-weight:bold;font-size:15px;color:#e9513c">
				<%=PackageDataBean.getPackageDealPricePerPerson(request, packageConfiguration, dealConfig, true)%>
			</span>
			<% } else { %>
			<span style="font-weight:bold;font-size:15px">
				<%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, true)%>
			</span>
			<% } %>
			<span style="margin-right:15px;">
				per person
			</span>
			<% } %>
			<span style="display:none"><a href="#" class="save-this active" style="font-size:11px;top:0;">Add to wishlist</a></span>
			<% if (!packageConfiguration.getPackageTags().isEmpty()) { %>
			<p style="font-size:11px;margin-top:10px;display:none">
				<%=ListUtility.toString(PackageTag.getPackageTagsDisplayNames(packageConfiguration.getPackageTags()), ", ")%>
			</p>
			<% } %>
		</div>
		<div class="meta" style="<%=(packageConfiguration.getCreatorUser() != null && packageConfiguration.getCreatorUser().getRatingScore() > 0) ? "margin-top:5px" : ""%>">
			<% if(packageConfiguration.getCreatorUser() != null) { %>
			<div class="article-by-info">
				<a href="<%=UserWallBean.getUserWallURL(request, packageConfiguration.getCreatedByUser())%>">
					<img style="margin-left:0px;margin-top:0px;float:left;margin-right:10px;" class="avatar" height="35" src="<%=UIHelper.getProfileImageURLForDataType(packageConfiguration.getCreatorUser(), FileDataType.U_SMALL)%>" width="35" />
				</a>
				<p class="byline" style="font-size:11px;">
					Created By <br>
					<a href="<%=UserWallBean.getUserWallURL(request, packageConfiguration.getCreatedByUser())%>"><%=UIHelper.cutLargeText(packageConfiguration.getCreatorUser().getName(), 25)%></a>
					<% if(packageConfiguration.getCreatorUser() != null && packageConfiguration.getCreatorUser().getRatingScore() > 0) { %>
					<br><span style="margin:2px 0px 2px 45px" class="srating rt<%=UIHelper.getRatingClassNameSuffix(packageConfiguration.getCreatorUser().getRatingScore())%> mrgnR u_floatL" title="<%=UIHelper.getDisplayRatingText(packageConfiguration.getCreatorUser().getRatingScore(), 5)%>"><span>Rated: <%=packageConfiguration.getCreatorUser().getRatingScore()%> stars</span></span>
					<a href="<%=UserWallBean.getUserWallURL(request, packageConfiguration.getCreatedByUser())%>" style="margin-left:5px">(<%=packageConfiguration.getCreatorUser().getTotalReviews()%> reviews)</a>
					<% } %>
				</p>
			</div>
			<% } %>
			<ul style="<%=(packageConfiguration.getCreatorUser() != null && packageConfiguration.getCreatorUser().getRatingScore() > 0) ? "margin-top:5px" : "margin-top:10px"%>">
				<li style="padding-right:0">
					<% if(transport != null && transport == TransportOption.FLIGHT) { %>
					<span style="margin-right:5px">
					  <img src="http://images.tripfactory.com/static/img/poccom/airlines/icons/<%=transports.get(0).getCarrierCode()%>.gif" style="vertical-align:middle;display:inline" />
					</span>
					<% } %>
					<span>
						<%=PackageConfigManager.generateProductsIncludedText(packageConfiguration)%>
					</span>
				</li>
			</ul>
			<% if(packageConfiguration.getCreatorUser() == null) { %>
			<div class="clearfix"></div>
			<div class="mrgnT">
			  <a href="<%=pkgDetailUrl%>" class="search-button">Book Now</a>
			</div>
			<% } %>
		</div>
		<div class="clearfix"></div>
		<% if(showEditOption && packageConfiguration.isHotelPackage()) { %>
		<p style="font-size:11px;text-align:left"><a href="/partner/add-hotel-package?pkgId=<%=packageConfiguration.getId()%>" class="search-button" style="color:#fff">Edit Package</a></p>		
		<% } else if(showEditOption && packageConfiguration.getBaseConfigId() != null) { %>
		<p style="font-size:11px;text-align:left"><a href="/partner/price-grid?basePkgId=<%=packageConfiguration.getBaseConfigId()%>" class="search-button" style="color:#fff">Edit Package</a></p>
		<% } %>
		<div class="clearfix"></div>
	</div>
	</article>
	<div class="clearfix"></div>
</div>
<% } %>