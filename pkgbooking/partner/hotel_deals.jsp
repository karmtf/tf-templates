<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>


<%@page import="com.eos.b2c.ui.NavigationHelper"%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	Map<Integer, String> hotelsMap = (Map<Integer, String>)request.getAttribute(B2cNavigationConstantBean.GET_DEALS_HOTEL_ATTRIBUTE);
	if(hotelsMap == null) { hotelsMap = new HashMap<Integer, String>(); };
	long dealId = request.getParameter("dealId") != null ? Long.parseLong(request.getParameter("dealId")) : -1L;
	SupplierPackagePricing selectedDeal = null;
    Map<SellableUnitType, SupplierPackagePricing> retDealsMap = new HashMap<SellableUnitType, SupplierPackagePricing>();
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	if(retDealsList != null) {
		for(SupplierPackagePricing retDeal: retDealsList){
			if(retDeal.getId() == dealId) {
				selectedDeal = retDeal;
				break;
			}
		}
	}
	String fromDateStr = selectedDeal != null ? dt.format(selectedDeal.getTravelStartDate()) : "";
	String toDateStr = selectedDeal != null ? dt.format(selectedDeal.getTravelEndDate()) : "";
	CurrencyType currencyType = selectedDeal != null ? CurrencyType.getCurrencyByNameOrCode(selectedDeal.getCurrency()) : CurrencyType.getCurrencyByCode(LocationData.getCurrencyByCity(hotel.getCity()));
	Double amount = selectedDeal != null ? selectedDeal.getIndicativePriceAmount() : null;
	AllowedPricingPredefined pricingKey =  selectedDeal != null ? selectedDeal.getIndicativePriceKey() : null;
%>
<html>
<head>
<title>Manage Ancillaries For <%=hotel.getName()%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<script type="text/javascript" src="http://www.latentmotion.com/tripfactory/mocks/admin2/js/plugins/ui/date.js"></script>

</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".datepicker").datepicker({
		defaultDate: +7,
		showOtherMonths:true,
		autoSize: true,
		appendText:'(dd-mm-yyyy)',
		dateFormat:'dd/mm/yy'
	});
	$jQ(".spinner-currency").spinner({
		min: 0,
		max: 2500,
		step: 5,
		start: 1000,
		numberFormat:"C"
	});
});
</script>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<form name="dealsForm" action="/partner/load-hotel-deals" method="get">
	<input type="hidden" name="hotelid" value="<%=hotel.getId()%>" />
	<input type="hidden" name="roomid" value="0" />
	</form>
	<% if(retDealsList != null && !retDealsList.isEmpty()) { %>
	<h5 class="widget-name">Current Ancillaries Being Sold</h5>
	<table class="table">
		<tr>
			<th>Type</th>
			<th>Description</th>
			<th>Price</th>
			<th>Edit</th>
			<th>Disable/Enable</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackagePricing retDeal : retDealsList) {
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:150px;font-size:11px"><%=retDeal.getDealSellableUnitType().getDesc()%></td>
			<td style="width:300px;font-size:11px"><%=retDeal.getOptionTitle()%></td>
			<td style="width:150px;font-size:11px"><%=retDeal.getCurrency()%> <%=retDeal.getIndicativePriceAmount()%> (<%=retDeal.getIndicativePriceKey().getDesc()[0]%>)</td>
			<td style="width:50px"><a href="/partner/load-hotel-deals?hotelid=<%=hotel.getId()%>&selectedSideNav=packages&dealId=<%=retDeal.getId()%>">Edit</a></td>
			<% if(retDeal.isDisabled()) { %>
			<td style="width:50px"><a href="/partner/load-hotel-deals?hotelid=<%=hotel.getId()%>&selectedSideNav=packages&dealId=<%=retDeal.getId()%>&enable=true">Enable Sale</a></td>
			<% } else { %>
			<td style="width:50px"><a href="/partner/load-hotel-deals?hotelid=<%=hotel.getId()%>&selectedSideNav=packages&dealId=<%=retDeal.getId()%>&enable=false">Disable Sale</a></td>
			<% } %>
		</tr>
		<% } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add Ancillaries for <%=hotel.getName()%></h5>
	<form class="form-horizontal" name="packageForm" action="/partner/add-hotel-deals" method="post">
		<input type="hidden" name="hotelid" value="<%=hotel.getId()%>" />
		<input type="hidden" name="dealid" value="<%=(selectedDeal != null)?selectedDeal.getId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Add New Add-on</h6>
				</div>
			</div>
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label">Ancillary Type:</label>
					<div class="controls">
						<p>Please use <b>Hotel Extras</b> as category to add other ancillaries e.g. flowers, lounge, champagne etc.</p>
						<select name="ancillary" id="ancillary">
						<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %>
						<option value="<%=unitType.name()%>" <%=(selectedDeal != null && selectedDeal.getDealSellableUnitType() == unitType)?"selected":""%>><%=unitType.getDesc()%></option>
						<% } %>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Min Nights</label>
					<div class="controls">
						<select name="qty" class="styled" tabindex="4" style="opacity: 0;">
							<% for (int i = 1; i < 21; i++) { %>
							<option value="<%=i%>" <%=(selectedDeal != null && selectedDeal.getMinQty() == i)?"selected":""%>><%=i%></option>
							<% } %>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Name/Title:</label>
					<div class="controls">
						<input type="text" name="title" class="span12" id="title" value="<%=(selectedDeal != null)?selectedDeal.getOptionTitle():""%>" />
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Description:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="desc" id="desc" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedDeal != null)?selectedDeal.getDealDesc():""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Validity:</label>
					<div class="controls">
						<ul class="dates-range no-append">
							<li><input type="text" placeholder="Start Travel Date" id="date" value="<%=fromDateStr%>" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
							<li class="sep">-</li>
							<li><input type="text" placeholder="End Travel Date" value="<%=toDateStr%>" id="date2" name="toDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=toDateStr%></span></li>
						</ul>
					</div>
				</div>	
				<div class="control-group">
					  <label class="control-label">Currency:</label>
					  <div class="controls">
					  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
							<% for (CurrencyType curr: CurrencyType.values()) { %>
								<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
							<% } %>
					  </select>						  
					</div>
				</div>	
				<div class="control-group">
					<label class="control-label">Pricing:</label>
					<div class="controls">
						<div class="row-fluid">
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="price" value="<%=(amount != null)?amount:0%>" /><span class="help-block">Pricing</span>
							</div>
							<div class="span2">
								<select name="pricingType" id="pricingType">
									<option value="<%=AllowedPricingPredefined.PRICE_FULL_AMOUNT.getDesc()[0]%>" <%=(pricingKey != null && AllowedPricingPredefined.PRICE_FULL_AMOUNT == pricingKey)?"selected":""%>><%=AllowedPricingPredefined.PRICE_FULL_AMOUNT.getDesc()[0]%> per booking</option>
									<option value="<%=AllowedPricingPredefined.PRICE_PER_PAX_ADULT.getDesc()[0]%>" <%=(pricingKey != null && AllowedPricingPredefined.PRICE_PER_PAX_ADULT == pricingKey)?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_PAX_ADULT.getDesc()[0]%></option>
									<option value="<%=AllowedPricingPredefined.PRICE_PER_ROOM_PER_NIGHT.getDesc()[0]%>" <%=(pricingKey != null && AllowedPricingPredefined.PRICE_PER_ROOM_PER_NIGHT == pricingKey)?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_ROOM_PER_NIGHT.getDesc()[0]%></option>
									<option value="<%=AllowedPricingPredefined.PRICE_PER_ROOM.getDesc()[0]%>" <%=(pricingKey != null && AllowedPricingPredefined.PRICE_PER_ROOM == pricingKey)?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_ROOM.getDesc()[0]%></option>
									<option value="<%=AllowedPricingPredefined.PRICE_PER_PAX_PER_DAY.getDesc()[0]%>" <%=(pricingKey != null && AllowedPricingPredefined.PRICE_PER_PAX_PER_DAY == pricingKey)?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_PAX_PER_DAY.getDesc()[0]%></option>
								</select>
							</div>
						</div>
					</div>
				</div>
			  <div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Save Add-ons</button>
				</div>		
			</div>
		</div>
		<!-- /HTML5 inputs -->
	</fieldset>
   </form>
</div>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
