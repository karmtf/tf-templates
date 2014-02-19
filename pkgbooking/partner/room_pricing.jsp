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
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="java.util.Collection"%>
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
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.SellableUnitWrapper"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%
	SupplierPackage selectedPackage = (SupplierPackage)request.getAttribute(Attributes.PACKAGEDATA.toString());
	Collection<SupplierPackagePricing> packages = (Collection<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());
	SupplierPackagePricing basePricing = (SupplierPackagePricing)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING_OPTION.toString());
	PackageConfigData basePkg = (PackageConfigData)request.getAttribute(Attributes.PACKAGE.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	CurrencyType currencyType = CurrencyType.AMERICAN_DOLLAR;
	long pricingId = request.getParameter("pricingId") != null ? Long.parseLong(request.getParameter("pricingId")) : -1L;
	int hotelid = request.getParameter("hotelid") != null ? Integer.parseInt(request.getParameter("hotelid")) : -1;
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
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	if(selectedPackagePricing != null) {
		currencyType = CurrencyType.getCurrencyByCode(selectedPackagePricing.getCurrency());
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_SINGLE) {
					single = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_TWIN) {
					twin = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_EXTRA_ADULT) {
					adult = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD) {
					cwb = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD_WITHOUT_BED) {
					cob = price.getPriceAmount();
				}
			}
		}
	}
%>
<html>
<head>
<title>Manage Pricing</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
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
<div id="mainContent" class="mainContent u_floatL" style="width:850px;">
	<div class="spacer"></div>
	<div class="mrgn10T" style="margin-bottom:10px">
		<a href="/partner/hotel-packages?hotelid=<%=hotelid%>">Select Packages >></a>
	</div>
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Pricing for <%=selectedPackage.getName()%></h5>
	<table class="table">
		<tr class="odd">
			<th style="width:180px"><b>Validity</b></th>
			<th style="width:70px"><b>Min Nights</b></th>
			<th style="width:100px"><b>M T W T F S S</b></th> 
			<th style="width:100px"></th>
			<th style="width:100px"></th>
		</tr>
		<% 
			boolean isOdd = true;
			for(SupplierPackagePricing pkg : packages) { 
				isOdd = !isOdd;
				if(pkg.getRecommendationId() > 0) {
					continue;
				}
		%>
		<tr class="<%=isOdd?"odd":"even"%>">
			<td style="width:180px"><%=df.format(pkg.getTravelStartDate())%> to <%=df.format(pkg.getTravelEndDate())%></td>
			<td style="width:70px"><%=pkg.getMinQty()%></td>
			<td style="width:100px">
				<%List<DayOfWeek> days = pkg.getApplicableDaysAsList();%>
				<% if(days.contains(DayOfWeek.MONDAY)){%>M <%}else{%>&nbsp;&nbsp;<%}%>
				<% if(days.contains(DayOfWeek.TUESDAY)){%>T <%}else{%>&nbsp;&nbsp;<%}%>
				<% if(days.contains(DayOfWeek.WEDNESDAY)){%>W <%}else{%>&nbsp;&nbsp;<%}%>
				<% if(days.contains(DayOfWeek.THURSDAY)){%>T <%}else{%>&nbsp;&nbsp;<%}%>
				<% if(days.contains(DayOfWeek.FRIDAY)){%>F <%}else{%>&nbsp;&nbsp;<%}%>
				<% if(days.contains(DayOfWeek.SATURDAY)){%>S <%}else{%>&nbsp;&nbsp;<%}%>
				<% if(days.contains(DayOfWeek.SUNDAY)){%>S <%}else{%>&nbsp;&nbsp;<%}%>
			</td>
			<td style="width:100px">
				<% if(pkg.getId() != basePricing.getId()) { %>
				<a href="/partner/delete-package-pricing?hotelid=<%=request.getParameter("hotelid")%>&selectedSideNav=packages&basePkgId=<%=basePkg.getId()%>&pricingId=<%=pkg.getId()%>">Delete</a>
				<% } else { %>
				Base Pricing
				<% } %>
			</td>
			<td style="width:100px">
				<a href="/partner/manage-package-pricing?selectedSideNav=packages&basePkgId=<%=basePkg.getId()%>&pricingId=<%=pkg.getId()%>">Edit</a>
			</td>
		</tr>
		<tr class="<%=isOdd?"odd":"even"%>">
			<td colspan="5">
			<%
				PricingComponents comp = pkg.getPricingComponents();
				if(comp != null) {
					Map<PricingComponentsKey, PriceAmount> priceMap = comp.getPriceMap();
					for(Iterator iter = priceMap.entrySet().iterator(); iter.hasNext();) {
						Map.Entry<PricingComponentsKey, PriceAmount> entry = (Map.Entry<PricingComponentsKey, PriceAmount>)iter.next();
						PricingComponentsKey key = entry.getKey();
						PriceAmount price = entry.getValue();
			%>
			<div style="margin-right:20px;line-height:20px"><%=key.getAllowedPricingPredefined().getDesc()[0]%>:<%=pkg.getCurrency()%>&nbsp;<%=price.getPriceAmount()%></div>
			<% } } %>
			</td>
		</tr>
		<% } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add Multiple Pricings For <%=selectedPackage.getName()%></h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-package-pricing" method="post">
	<input type="hidden" name="hotelid" value="<%=request.getParameter("hotelid")%>" />
	<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
	<input type="hidden" name="basePkgId" value="<%=(basePkg != null)?basePkg.getId():"-1"%>" />
	<input type="hidden" name="pricingId" value="<%=(selectedPackagePricing != null) ? selectedPackagePricing.getId() : "-1"%>" />
	<input type="hidden" name="pricing" value="<%=basePricing.getId()%>" />
	<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Pricing for <%=selectedPackage.getName()%></h6>
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
					<label class="control-label">Dates Available:</label>
					<div class="controls">
						<ul class="dates-range no-append">
							<li><input type="text" placeholder="Start Travel Date" value="<%=fromDateStr%>" id="date" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
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
					<label class="control-label">Package Price:</label>
					<div class="controls">
						<div class="row-fluid">
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="singleAdult" value="<%=single%>" /><span class="help-block">Single Adult</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="twinSharing" value="<%=twin%>" /><span class="help-block">Twin Sharing</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="extraAdult" value="<%=adult%>" /><span class="help-block">Extra Adult</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="cwb" value="<%=cwb%>" /><span class="help-block">Child with Bed</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="cob" value="<%=cob%>" /><span class="help-block">Child no Bed</span>
							</div>
						</div>
					</div>
				</div>
				<div class="control-group">
                    <label class="control-label">Days Valid: </label>
					<div class="controls">
					  <div class="span3">
						  <label class="checkbox">
							<input type="checkbox" name="mon" value="mon" class="styled">
							Monday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="tue" value="tue" class="styled">
							Tuesday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="wed" value="wed" class="styled">
							Wednesday
						  </label>
						  <label class="checkbox">
							<input type="checkbox" name="thur" value="thur" class="styled" checked>
							Thursday
						  </label>
						</div>
						<div class="span3">
						  <label class="radio">
							<input type="checkbox" name="fri" value="fri" class="styled" checked>
							Friday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="sat" value="sat" class="styled" checked>
							Saturday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="sun" value="sun" class="styled" checked>
							Sunday
						  </label>
					</div>
				  </div>
			  </div>
			  <div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Update Package Pricing</button>
				</div>		
			</div>
		</div>
		<!-- /HTML5 inputs -->
	</fieldset>
   </form>
   <div class="spacer"></div>
</div>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
