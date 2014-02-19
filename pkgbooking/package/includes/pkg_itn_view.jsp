<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
	PackageItineraryResultItem pkgItnResult = (PackageItineraryResultItem) request.getAttribute(Attributes.PACKAGE_ITN_RESULT.toString());
	PackageSearchQuery searchQuery = (PackageSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	List<Destination> cityDestinations = pkgItnResult.getCityDestinations();

	String clazz = StringUtils.trimToEmpty(request.getParameter("clazz"));
	String pkgGroupURL = "";//PackageSearchQuery.getPackageSearchURL(request, searchQuery, pkgGroup);
%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.holiday.search.PackageSearchQuery"%>
<%@page import="com.eos.b2c.holiday.data.PackageItineraryResultItem"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.gmap.StaticMapsUtil"%>
<%@page import="java.util.List"%>
<div class="u_block pkgItnV <%=clazz%>" style="padding:5px; margin-bottom:5px;">
	<div style="width:200px; float:left;">
		<img src="<%=StaticMapsUtil.getUrl(200, 100, pkgItnResult.getCityDestinations(), true, true)%>" width="200" height="100"/>
	</div>
	<% 
		int cityCount = 0;
		for (Destination cityDest: cityDestinations) { 
		    cityCount++;
		    boolean isLastCity = (cityDestinations.size() == cityCount);
	%>
		<div class="posR" style="width:150px; float:left; margin-left:10px; background:#fff; padding:5px;">
			<img src="<%=UIHelper.getImageURLForDataType(request, cityDest.getMainImage(), FileDataType.I200X100, true)%>" width="150" height="75"/>
			<div style="padding-top:5px;">
				<div style="font-size:12px; text-align:center;"><b><%=cityDest.getName()%></b></div>
			</div>
			<% if (!isLastCity) { %><div style="position:absolute; top:30px; right:-30px; z-index:1; width:44px; height:26px; background:transparent url(/static/img/icons/rgt-arrw.png) no-repeat;"></div><% } %>
		</div>
	<% } %>
</div>