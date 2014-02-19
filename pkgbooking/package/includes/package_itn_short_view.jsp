<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.language.util.LanguageConstants"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.language.util.LanguageBundle"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	PackageConfigData packageConfiguration = (PackageConfigData) request.getAttribute(Attributes.PACKAGE.toString());
	String clazz = StringUtils.trimToEmpty(request.getParameter("clazz"));
	boolean showEditOption = Boolean.parseBoolean(request.getParameter("showEdit"));
	boolean showPick = Boolean.parseBoolean(request.getParameter("showPick"));
	boolean showCompressedView = Boolean.parseBoolean(request.getParameter("showCompressedView"));
	String width = RequestUtil.getStringRequestParameter(request, "width", "690");
	UserPackageAssociation userPkgAssociation = packageConfiguration.getUserPackageAssociation();
	boolean isDraft = (packageConfiguration.isDraftConfig());
	boolean isPkgPicked = (userPkgAssociation != null && userPkgAssociation.isPicked());
	boolean hasUserBeenToAllCities = packageConfiguration.hasUserBeenToAllCities();
	boolean isSystemUser = UIHelper.isSystemUser(loggedInUser);

	List<String> cityItnNames = packageConfiguration.getItineraryDisplayNames();
	List<PackageTag> pkgTags = packageConfiguration.getPackageTags();
	List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
	
	Set<PackageTag> tags = new HashSet<PackageTag>();
	tags.addAll(pkgTags);
	List<Integer> cities = packageConfiguration.getDestinationCities();
	String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
	String imageUrl = packageConfiguration.getImageURL(request); 
	String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.secondary.database.model.UserPackageAssociation"%>
<%@page import="com.eos.b2c.data.LocationData.CityItem"%>
<%@page import="com.eos.b2c.user.destination.UserDestinationListType"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.apache.commons.lang.WordUtils"%>
<%
if(cities != null && !cities.isEmpty()) {
	Destination place = DestinationContentBean.getDestinationFromCityId(cities.get(0), false);
%>
<div id="pkgSV<%=packageConfiguration.getId()%>" class="itinerary-result">
	<article class="<%=!clazz.equals("")?clazz:"full-width"%> mrgn10B" style="width:100%;margin-right:10px;border:1px solid #eee;margin-bottom:15px;">
		<figure style="min-height:10px">
			<a class="productUrl" href="<%=pkgDetailUrl%>"><img src="<%=imageUrlComplete%>" style="height:145px;border:1px solid rgba(0,0,0,.2);border-radius:3px;width:99%" /></a>
		</figure>
		<div class="details" style="padding-top:15px;">
			<h1 style="max-width:100%"><a class="productUrl" title="<%=packageConfiguration.getPackageName()%>" href="<%=pkgDetailUrl%>" style="text-decoration:none"><%=UIHelper.cutLargeText(WordUtils.capitalizeFully(packageConfiguration.getPackageName()), 45)%></a></h1>
			<span class="address" style="width:90%">
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
				<% if(StringUtils.isNotBlank(packageConfiguration.getPackageDesc(false))) { %>
				<p>
					<%=StringUtility.truncateAtWord(packageConfiguration.getPackageDesc(false), 100, true).replaceAll("\\?","")%>
				</p>
				<% } %>
				<% if(showEditOption) { %>
				<p style="font-size:11px">
					<a href="/partner/edit-config?pkgId=<%=packageConfiguration.getId()%>" class="search-button" style="color:#fff">Edit Itinerary</a>
				</p>
				<% } %>
				<% if (!packageConfiguration.getPackageTags().isEmpty()) { %>
				<p style="font-size:11px;margin-top:10px">
					<%=UIHelper.cutLargeText(ListUtility.toString(PackageTag.getPackageTagsDisplayNames(packageConfiguration.getPackageTags()), ", "), 60)%>
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
				<ul style="margin-top:10px;">
					<li style="color:#093"><%=packageConfiguration.getNumberOfViews()%> views</li>
				</ul>
			</div>
			<div class="clearfix"></div>
		</div>
	</article>
	<div class="clearfix"></div>
</div>
<% } %>