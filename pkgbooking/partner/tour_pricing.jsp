<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>


<%@page import="com.eos.b2c.ui.NavigationHelper"%>

<%@page import="com.eos.currency.CurrencyType"%>
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
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.SellableUnitWrapper"%>
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>

<%
	SupplierPackage selectedPackage = (SupplierPackage)request.getAttribute(Attributes.PACKAGEDATA.toString());
	List<SupplierPackagePricing> packages = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	CurrencyType currencyType = CurrencyType.AMERICAN_DOLLAR;
	long pricingId = request.getParameter("pricingId") != null ? Long.parseLong(request.getParameter("pricingId")) : -1L;
	SupplierPackagePricing selectedPackagePricing = null;
	if(pricingId > 0) {
		for(SupplierPackagePricing pkg : packages) {
			if(pkg.getId() == pricingId) {
				selectedPackagePricing = pkg;
				break;
			}
		}
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	PricingComponents pricingComponents = selectedPackagePricing != null ? selectedPackagePricing.getPricingComponents() : null;
%>
<html>
<head>
<title>Manage Tour Pricing</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div style="color:green;font-weight:bold;margin:10px 0;font-size:14px"><%=statusMessage%></div>
	<% } %>
	<div class="mrgn10T" style="margin-bottom:10px">
		<a href="/partner/tour-package">Select Packages >></a>
	</div>
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Pricing for <%=selectedPackage.getName()%></h5>
	<div class="mrgn10T" style="margin-bottom:15px;padding:0 10px;background:#f5f5f5;border:1px solid #D7D8DA">
	<table class="table">
		<tr class="odd">
			<th style="width:80px"><b>Code</b></th>
			<th style="width:180px"><b>Validity</b></th>
			<th style="width:100px"><b>Pricing</b></th>
			<th style="width:100px"><b>Pricing</b></th>
			<th style="width:50px"></th>
		</tr>
		<% 
			boolean isOdd = true;
			for(SupplierPackagePricing pkg : packages) { 
				isOdd = !isOdd;
		%>
		<tr class="<%=isOdd?"odd":"even"%>">
			<td style="width:80px"><%=pkg.getOptionCode()%></td>
			<td style="width:180px"><%=df.format(pkg.getTravelStartDate())%> to <%=df.format(pkg.getTravelEndDate())%></td>			
			<%
				PricingComponents comp = pkg.getPricingComponents();
				if(comp != null) {
					Map<PricingComponentsKey, PriceAmount> priceMap = comp.getPriceMap();
					for(Iterator iter = priceMap.entrySet().iterator(); iter.hasNext();) {
						Map.Entry<PricingComponentsKey, PriceAmount> entry = (Map.Entry<PricingComponentsKey, PriceAmount>)iter.next();
						PricingComponentsKey key = entry.getKey();
						PriceAmount price = entry.getValue();
			%>
			<td style="width:100px">
			<%=key.getAllowedPricingPredefined().getDesc()[0]%>:<%=pkg.getCurrency()%>&nbsp;<%=price.getPriceAmount()%></td>
			<% } } %>
			<td style="width:50px"><a href="/partner/delete-tour-pricing?selectedSideNav=packages&pkgid=<%=selectedPackage.getId()%>&pricingId=<%=pkg.getId()%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add Tour Pricing For <%=selectedPackage.getName()%></h5>
	<form name="packageForm" action="/partner/add-tour-pricing" method="post">
	<input type="hidden" name="nights" value="1" />
	<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
	<%
		SightseeingUnit sightseeingUnit = (SightseeingUnit)selectedPackage.getSellableUnit();
	%>	
	<div class="mrgn10T">
		<div style="line-height:18px;margin:5px 0;width:200px" class="u_floatL">
			<b>Package Code:</b>
			<span style="font-size:11px;"><%=sightseeingUnit.getPackageCode()%></span>
		</div>
		<div style="line-height:18px;margin:5px 0;width:300px" class="u_floatL">
			<b>Package Name:</b>
			<span style="font-size:11px;"><%=selectedPackage.getName()%></span>
		</div>
		<div class="u_clear"></div>
	</div>
	<div class="mrgn10T">
		<div style="line-height:18px;margin:5px 0">
			<b>Pricing Code/Name:</b><br>
			<input name="optionCode" id="optionCode" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getOptionCode():""%>" size="20" />
		</div>
	</div>
	<div class="mrgn10T">
		<div style="line-height:18px;margin:5px 0">
			<b>Pricing Plan Description:</b><br>
			<input name="optionDesc" id="optionDesc" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getOptionDesc():""%>" size="60" />
		</div>
	</div>
	<div class="mrgn10T">
		<b>Validity:</b><br>
		<div style="line-height:18px;margin:5px 0;width:200px" class="u_floatL">
			<b>From:</b>
			<input type="text" id="fromDate" name="fromDate" class="calInput" value="<%=fromDateStr%>">
		</div>
		<div style="line-height:18px;margin:5px 0;width:300px" class="u_floatL">
			<b>To:</b>
			<input type="text" id="toDate" name="toDate" class="calInput" value="<%=toDateStr%>">
		</div>
		<div class="u_clear"></div>
	</div>
	<div class="mrgn10T">
		<div style="line-height:18px;margin:5px 0">
			<b>Currency:</b><br>
			<select name="currency" id="currency">
				<% for (CurrencyType curr: CurrencyType.values()) { %>
					<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
				<% } %>
			</select>
		</div>
	</div>
	<div class="mrgn10T">
		<b>Add Pricing:</b><br>
		<div style="line-height:18px;margin:5px 0;width:130px" class="u_floatL">
			<b>Adult:</b>
			<input type="text" id="adult" name="adult" size=15 value="0.0" />
		</div>
		<div style="line-height:18px;margin:5px 0;width:130px" class="u_floatL">
			<b>Child:</b>
			<input type="text" id="child" name="child" size=15 value="0.0" />
		</div>
		<div class="u_clear"></div>
	</div>
	<div style="margin:20px 0">
		<a class="btn btn-primary" href="#" onclick="packageForm.submit()">Add Package Pricing</a>
	</div>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
$jQ(document).ready(function() {
var dtPicker = new DatePick({fromInp:document.packageForm.fromDate, toInp:document.packageForm.toDate, calO:{minDate:null}});
});
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
