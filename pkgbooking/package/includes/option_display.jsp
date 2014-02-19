<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageInventory"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.via.content.ContentDataType"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.gds.data.Carrier"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.secondary.database.model.PackageExperience"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.currency.CurrencyConverter"%>
<%@page import="com.eos.b2c.holiday.data.TransportType"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<% 
	String currentCurrency = SessionManager.getCurrentUserCurrency(request);
	PackageOptionalConfig optional = (PackageOptionalConfig) request.getAttribute(Attributes.PACKAGE_OPTIONALS_DATA.toString());
	int city = Integer.parseInt(request.getParameter("city"));
	int price = (int)Math.round(CurrencyConverter.convert(optional.getCurrency(), currentCurrency, optional.getPrice()));								
%>
<% if(optional.getSellableUnitType() == SellableUnitType.HOTEL_ROOM && optional.getContentId() > 0) { %>
<div class="option option2" id="pkgOpt<%=optional.getId()%>">
	<input type="checkbox" name="stay<%=city%>" value="<%=optional.getId()%>" onclick="recalculatePkgPrice()" />&nbsp;&nbsp;<a target="_blank" href="<%=HotelDataBean.getHotelDetailsURL(request, MarketPlaceHotel.getHotelById(optional.getContentId()))%>"><%=MarketPlaceHotel.getHotelById(optional.getContentId()).getName()%></a> - <%=optional.getTitle()%>
	<% if(optional.getSupplierDeals() != null && !optional.getSupplierDeals().isEmpty()) { %>
	<div style="color:#F78C0D">
		<b>Free Inclusions</b>: <%=ListUtility.toString(SellableUnitType.getDisplayTextList(optional.getSupplierDeals()),", ")%>			
	</div>
	<% } %>
	<% if(optional.getExtraNightPrice() > 0) { %>
	<div class="u_vsmallF">
		<b>Extra Night: +</b>&nbsp;<%=CurrencyType.getShortCurrencyCode(currentCurrency)%>&nbsp;<%=(int)Math.round(CurrencyConverter.convert(optional.getCurrency(), currentCurrency, optional.getExtraNightPrice()))%> per room per night
	</div>
	<% } %>
</div>
<% } else if(optional.getSellableUnitType() == SellableUnitType.FLIGHT && optional.getContentId() > 0) { %>
<div class="option option2" id="pkgOpt<%=optional.getId()%>"><input type="checkbox" name="flight<%=city%>" value="<%=optional.getId()%>" onclick="recalculatePkgPrice()" />&nbsp;&nbsp;<%=(optional.getExCityId() != null && optional.getExCityId() > 0) ? "Ex - " + LocationData.getCityNameFromId(optional.getExCityId()) + " - ": ""%><%=Carrier.getName(optional.getContentId())%> - <%=optional.getTitle()%>
	<% if(optional.getSupplierDeals() != null && !optional.getSupplierDeals().isEmpty()) { %>
	<div style="color:#F78C0D">
		<b>Free Inclusions</b>: <%=ListUtility.toString(SellableUnitType.getDisplayTextList(optional.getSupplierDeals()),", ")%>				
	</div>
	<% } %>
</div>
<% } else if(optional.getSellableUnitType() == SellableUnitType.TRANSPORT && optional.getContentId() > 0) { %>
<div class="option option2" id="pkgOpt<%=optional.getId()%>">
	<input type="checkbox" name="transport<%=city%>" value="<%=optional.getId()%>" onclick="recalculatePkgPrice()" />&nbsp;&nbsp;<%=TransportType.getTransportOptionByCode(optional.getContentId()).getDisplayName()%> - <%=optional.getTitle()%>
	<div class="u_vsmallF">
		<%= (optional.getExCityId() != null && optional.getExCityId() > 0) ? "Ex - " + LocationData.getCityNameFromId(optional.getExCityId()) : "" %>
	</div>
</div>
<% } else if(optional.getSellableUnitType() == SellableUnitType.FOOD_AND_DRINKS) { %>
<div class="option option2" id="pkgOpt<%=optional.getId()%>"><input type="checkbox" name="<%=optional.getId()%>food" class="sightseeing" value="<%=optional.getId()%>" onclick="recalculatePkgPrice()" />&nbsp;&nbsp;<%=optional.getTitle()%>
	<% if(optional.getDescription() != null) { %>
	<div class="u_vsmallF">
		<%=optional.getDescription()%>
	</div>
	<% } %>
</div>
<% } else { %>
<div class="option option2" id="pkgOpt<%=optional.getId()%>"><input type="checkbox" name="<%=optional.getId()%>sightseeing" class="sightseeing" value="<%=optional.getId()%>" onclick="recalculatePkgPrice()" />&nbsp;&nbsp;<%=optional.getTitle()%> <%=(optional.getContentId() != null && optional.getContentId() > 0) ? " - " + optional.getContentId() + " hrs" : ""%>
	<% if(optional.getDescription() != null) { %>
	<div class="u_vsmallF">
		<%=optional.getDescription()%>
	</div>
	<% } %>
</div>
<% } %>
<% if(optional.getPrice() >= 0) { %>
<div class="option right" style="text-align:right"><b>+ <%=CurrencyType.getShortCurrencyCode(currentCurrency)%>&nbsp;<%=price%></b>
	<div class="u_vsmallF">
		<%=optional.getPricingType().getDisplayText("")%>
	</div>
</div>
<% } else { %>
<div class="option right" style="text-align:right"><b>- <%=CurrencyType.getShortCurrencyCode(currentCurrency)%>&nbsp;<%=price*-1%></b>
	<div class="u_vsmallF">
		<%=optional.getPricingType().getDisplayText("")%>
	</div>
</div>			
<% } %>
<div class="clearfix"></div>
