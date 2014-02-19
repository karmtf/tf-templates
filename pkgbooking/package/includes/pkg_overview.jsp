<%@page import="com.poc.server.config.step.PackageConfigSteps"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.step.AbstractConfigStep"%>
<%@page import="com.poc.server.config.step.FlightConfigStep"%>
<%@page import="com.eos.gds.data.FlightInformation"%>
<%@page import="com.poc.server.config.step.HotelConfigStep"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.hotel.HotelSelection"%>
<%@page import="com.poc.server.config.step.SupplierPackageConfigStep"%>
<%@page import="com.poc.server.config.step.SelectedSupplierPackage"%>
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.poc.server.activities.ActivityDataBean"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageConfigSteps pkgConfigSteps = pkgConfig.getPkgConfigSteps();

	User loggedInUser = SessionManager.getUser(request);
	boolean isLoggedIn = (loggedInUser != null);
	boolean isCreatorUser = (loggedInUser != null && loggedInUser.getId() == pkgConfig.getCreatedByUser());
%>
<% if (pkgConfigSteps != null) { %>
<%
	for (AbstractConfigStep configStep : pkgConfigSteps.getConfigSteps()) {
	    if (configStep.isSkipped() || !configStep.isStepComplete()) {
	        continue;
	    }
%>
	<div class="deals text-wrap">
	<h1><%=configStep.getStepHeading()%></h1>
	<%
		switch (configStep.getProductType()) {
		case FLIGHT:
		    FlightConfigStep flightConfigStep = (FlightConfigStep) configStep;
	%>
		<% 
			for (FlightInformation fInfo: flightConfigStep.getSelectedFlights()) { 
			    request.setAttribute(Attributes.FLIGHT_INFO.toString(), fInfo);
		%>
		<jsp:include page="/flight/includes/flight_short_view.jsp">
			<jsp:param name="isTrimView" value="true"/>
		</jsp:include>
		<% } %>
	<%
		break;
		case HOTEL:
		    HotelConfigStep hotelConfigStep = (HotelConfigStep) configStep;
		    HotelSelection selection = hotelConfigStep.getHotelSelection();
		    MarketPlaceHotel hotel = hotelConfigStep.getSelectedHotel();
	%>
	<article class="full-width" style="box-shadow:none;-moz-box-shadow:none">
		<figure>
			<img src="<%=UIHelper.getHotelImageURLForDataType(request, hotel, FileDataType.I300X150, true)%>" style="width:180px;">
		</figure>
		<div class="details" style="width:70%;padding-top:0">
			<h1 style="font-family:arial"><a class="productUrl" href="<%=HotelDataBean.getHotelDetailsURL(request, hotel)%>"><%=WordUtils.capitalizeFully(UIHelper.cutLargeText(hotel.getName(), 50))%></a></h1>
			<% if (hotel.getStarRating() > 0) { %>
			<span class="stars">
				<% for (int i = 0; i < hotel.getStarRating(); i++) { %>
				<img src="/static/images/ico/star.png" alt="" />
				<% } %>
			</span>
			<% } %>
			<span class="address">
				<%
				if(!StringUtils.isBlank(hotel.getLocation())) { %>
					<%=(hotel.getLocation().length() > 35) ? hotel.getLocation().substring(0,35) : hotel.getLocation()%>, <%=LocationData.getCityNameFromId(hotel.getCity())%>
				<% } else if(!StringUtils.isBlank(hotel.getAddrLine1())) { %>
					<%=(hotel.getAddrLine1().length() > 35) ? hotel.getAddrLine1().substring(0,35) : hotel.getAddrLine1()%>, <%=LocationData.getCityNameFromId(hotel.getCity())%>
				<% } %>
			</span>
			<div class="description">
				<p><% if(hotel.getDesc().indexOf("Location.") != -1) { %>
				<%=UIHelper.cutLargeText(hotel.getDesc().substring(27), 115)%>
				<% } else { %>
				<%=UIHelper.cutLargeText(hotel.getDesc(), 115)%>
				<% } %><a href="<%=HotelDataBean.getHotelDetailsURL(request, hotel)%>">More info</a></p>
				<p style="color:#F78C0D">
					<b>Includes:</b> Stay in <%=hotelConfigStep.getRoomName()%>
					<% if (selection != null && selection.getMealPlan() != null) { %>, <%=selection.getMealPlan().getMealPlanName()%><% } %>
				</p>
			</div>			
		</div>
	</article>
	<%
		break;
		case SIGHTSEEING_TOUR:
		    SupplierPackageConfigStep ssConfigStep = (SupplierPackageConfigStep) configStep;
	%>
		<%
			for (String supplierPkgOptionKey : ssConfigStep.getSelectedSupplierPackagesMap().keySet()) {
			    SelectedSupplierPackage selectedSupplierPkg = ssConfigStep.getSelectedSupplierPackagesMap().get(supplierPkgOptionKey);
			    SightseeingUnit sightseeingUnit = (SightseeingUnit) selectedSupplierPkg.getSupplierPackage().getSellableUnit();
		%>
		<article class="full-width" style="box-shadow:none;-moz-box-shadow:none">
			<div class="details" style="width:100%;padding-top:0">
				<h1 style="font-family:arial"><%=WordUtils.capitalizeFully(UIHelper.cutLargeText(sightseeingUnit.getName(), 50))%></h1>
				<span class="address"><%=LocationData.getCityNameFromId(sightseeingUnit.getDestId())%>, Duration: <%=sightseeingUnit.getDuration()%> hours</span>
				<% if (isCreatorUser) { %>
				<span class="address">Date: <%=ThreadSafeUtil.getDDMMMMMyyyyDateFormat(false, false).format(selectedSupplierPkg.getPackageDate())%></span>
				<% } %>
			</div>
		</article>
		<% } %>
	<% 
		break;
		} 
	%>
	</div>
<% } %>
<% } %>