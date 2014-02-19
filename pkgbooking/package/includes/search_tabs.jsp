<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String searchURL = (searchQuery != null) ? searchQuery.getContentSearchURL(request, null, false): "";
	boolean isOnMapView = Boolean.parseBoolean(request.getParameter("isOnMapView"));
	Set<Integer> toCities = searchQuery.getQueryParams().getTo();
	Set<Long> parents =  searchQuery.getQueryParams().getDestinationCityParents();
	boolean isBlankView = (searchQuery != null && (searchQuery.getQueryParams().getOverallProductType() == ViaProductType.HOTEL || searchQuery.getQueryParams().getOverallProductType() == ViaProductType.HOLIDAY || searchQuery.getQueryParams().getOverallProductType() == ViaProductType.FLIGHT) && searchQuery.getViewType() == SellableContentSearchViewType.NONE);	
	Destination dest = null;
	if(toCities != null && toCities.size() == 1) {
		dest = DestinationContentBean.getDestinationFromCityId((Integer)toCities.iterator().next(), false);
	} else if(parents != null && parents.size() == 1) {
		dest = DestinationContentManager.getDestinationFromId((Long)parents.iterator().next());
	}
%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<nav class="main-nav" role="navigation" style="border-bottom:1px solid #eee;background:#fff">
	<ul class="wrap">
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.HOLIDAY)) { %><li <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.HOLIDAY && searchQuery.getViewType() == SellableContentSearchViewType.NONE) ? "class='active'": ""%>><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.HOLIDAY, SellableContentSearchViewType.NONE, false): "#"%>" class="pkgSrchA">Packages</a></li><% } %>
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.HOLIDAY)) { %><li class="itineraries <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.HOLIDAY && searchQuery.getViewType() == SellableContentSearchViewType.ITINERARY) ? "active": ""%>"><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.HOLIDAY, SellableContentSearchViewType.ITINERARY, false): "#"%>" class="pkgSrchA">Itineraries</a></li><% } %>
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.HOTEL)) { %><li <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.HOTEL && searchQuery.getViewType() == SellableContentSearchViewType.NONE) ? "class='active'": ""%>><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.HOTEL, SellableContentSearchViewType.NONE, false): "#"%>" class="htlSrchA">Hotels</a></li><% } %>
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.FLIGHT_HOTEL)) { %><li <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.FLIGHT_HOTEL && searchQuery.getViewType() == SellableContentSearchViewType.NONE) ? "class='active'": ""%> style="display:none"><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.FLIGHT_HOTEL, SellableContentSearchViewType.NONE, false): "#"%>" class="htlSrchA">Flight + Hotels</a></li><% } %>
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.FLIGHT)) { %><li <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.FLIGHT) ? "class='active'": ""%>><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.FLIGHT, SellableContentSearchViewType.NONE, false): "#"%>" class="dstSrchA">Flights</a></li><% } %>
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.SIGHTSEEING_TOUR)) { %><li class="sightseeing <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.SIGHTSEEING_TOUR && searchQuery.getViewType() == SellableContentSearchViewType.NONE) ? "active": ""%>"><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.SIGHTSEEING_TOUR, SellableContentSearchViewType.NONE, false): "#"%>" class="dstSrchA">Sightseeing</a></li><% } %>
		<% if (SettingsController.getInstance().isProductEnabled(ViaProductType.DESTINATION)) { %>
			<% if(isBlankView && dest != null) { %>
			<li><a href="<%=DestinationContentBean.getDestinationContentURL(request, dest)%>">Travel Guide</a></li>
			<% } else { %>
			<li <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.DESTINATION && searchQuery.getViewType() == SellableContentSearchViewType.NONE) ? "class='active'": ""%>><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.DESTINATION, SellableContentSearchViewType.NONE, false): "#"%>" class="dstSrchA">Travel Guide</a></li>
			<% } %>
		<% } %>
		<% if (false && SettingsController.getInstance().isProductEnabled(ViaProductType.PAGE_META)) { %><li <%=(searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.PAGE_META) ? "class='active'": ""%>><a href="<%=(searchQuery != null) ? searchQuery.getContentSearchURL(request, null, ViaProductType.PAGE_META, SellableContentSearchViewType.NONE, false): "#"%>" class="dstSrchA" style="display:none">Web Results</a></li><% } %>
		<% if (searchQuery != null && searchQuery.getQueryParams().getOverallProductType() == ViaProductType.HOLIDAY && searchQuery.getViewType() == SellableContentSearchViewType.NONE) { %>
		<li class="sightseeing" style="float:right;min-width:320px;margin-top:10px">
			<ol class="track-progress" data-steps="4" style="margin-bottom:10px">
			  <li class="done">
				<span>Search</span>
				<i></i>
			  </li><!--
			  --><li>
				<span>Details</span>
				<i></i>
			  </li><!--
			  --><li>
				<span style="padding-left:20px">Customize</span>
				<i></i>
			  </li><!--
			  --><li>
				<span>Book</span>
				<i></i>
			  </li>
			</ol>		
		</li>
		<% } %>
	</ul>
</nav>