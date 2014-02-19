<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.settings.AppSettingType"%>
<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%
	SupplierRecommendation flight = (SupplierRecommendation) request.getAttribute(Attributes.FLIGHT_INFO.toString());
	SupplierRecommendation hotelPkg = (SupplierRecommendation) request.getAttribute(Attributes.PACKAGE.toString());
	FlightUnit flightUnit = (FlightUnit) flight.getSellableUnit();
	MarketPlaceHotel hotel = hotelPkg.getHotel();
	SupplierPackagePricing pricing = hotelPkg.getSupplierPricingsAsList().get(0);
	List<SupplierPackagePricing> deals = hotelPkg.getSupplierDealsAsList();

	String fphViewURL = FPHBean.getFPHViewURL(request, flight, hotelPkg);

	int amount = 0;
	if(pricing != null) { 
		amount = (int)Math.round(pricing.getPricingComponents().getPriceAmount(AllowedPricingPredefined.PRICE_FULL_AMOUNT));
	}
%>
<%@page import="com.poc.server.fph.FPHBean"%>
<article class="one-fourth pkgdeal">
	<h1 style="max-width:100%" class="mrgn10B">	
		<%=LocationData.getCityNameFromId(flightUnit.getSourceId())%> - <%=LocationData.getCityNameFromId(flightUnit.getDestId())%>
		<span class="right">
			<img src="<%=SettingsController.getInstance().getSettingValue(AppSettingType.LOGO_URL)%>" style="height:20px">
		</span>
	</h1>
	<figure>
		<% if(hotel.getImages() != null && !hotel.getImages().isEmpty()) { %>
		<a class="productUrl" href="<%=fphViewURL%>"><img src="<%=hotel.getImages().get(0)%>" style="height:150px;" /></a>
		<% } %>
	</figure>
	<div class="description" style="padding-top:10px;width:100%;border-bottom:0">
		<span class="address" style="font-size:12px;width:100%">
			<a href="<%=fphViewURL%>"><%=UIHelper.cutLargeText(hotel.getName(), 30)%></a>
			<% if (hotel.getStarRating() > 0) { %>
			<span class="stars" style="padding-left:5px">
				<% for (int i = 0; i < hotel.getStarRating(); i++) { %>
				<img src="/static/images/ico/star.png" alt="" />
				<% } %>
			</span>
			<% } %>			
		</span>
		<span class="address" style="font-size:12px">
			<b><%=LocationData.getCityNameFromId(hotel.getCity())%></b>
		</span>
		<span class="clearfix"></span>
		<div class="left" style="width:49%">
			<% 
				if(deals != null && !deals.isEmpty()) { 
			%>
			<span class="address mrgn10T" style="font-size:11px">
				<b>Includes</b>
			</span>
			<%
					for(SupplierPackagePricing pr : deals) {
			%>
			<span class="address mrgn10T" style="font-size:11px"><%=pr.getOptionTitle()%></span>
			<% } } %>
		</div>
		<div class="right" style="width:49%">
			<span class="address mrgn10T" style="font-size:11px">
				<%=ThreadSafeUtil.getddMMMDateFormat(false,false).format(pricing.getTravelStartDate())%> to <%=ThreadSafeUtil.getddMMMDateFormat(false,false).format(pricing.getTravelEndDate())%>
			</span>
			<span class="address mrgn10T" style="font-size:11px;color:#888">
				Flight + 2 nights stay
			</span>
			<span class="address" style="font-size:22px;font-weight:bold;color:#ffaa26">
				<%=UIHelper.getPriceDisplayText(request, amount, true, true, false, false, null, false, null)%>
			</span>
			<span class="address" style="font-size:11px;color:#888">
				per person
			</span>
		</div>
		<div class="clearfix"></div>
	</div>
</article>
