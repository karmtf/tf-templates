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
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.TransportType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%
	User user = SessionManager.getUser(request);
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	List<SupplierRecommendation> recos = (List<SupplierRecommendation>)request.getAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd");
	SupplierPackage selectedPackage = null;
	long pkgId = request.getParameter("pkgId") != null ? Long.parseLong(request.getParameter("pkgId")) : -1L;
	long pricingId = request.getParameter("pricingId") != null ? Long.parseLong(request.getParameter("pricingId")) : -1L;
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	if(pkgId > 0) {
		for(SupplierPackage pkg : packages.values()) {
			if(pkg.getId() == pkgId) {
				selectedPackage = pkg;
				break;
			}
		}
	}
	Map<Long,List<SupplierPackagePricing>> pricings =   (Map<Long,List<SupplierPackagePricing>>)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());;
	SupplierPackagePricing selectedPackagePricing = null;
	if(pkgId > 0 && pricingId > 0) {
		List<SupplierPackagePricing> selPricing = pricings.get(pkgId);
		for(SupplierPackagePricing pr : selPricing) {
			if(pr.getId() == pricingId) {
				selectedPackagePricing = pr;
				break;
			}
		}
	}
	CurrencyType currencyType = null; 
	if(hotel != null) {
		currencyType = selectedPackagePricing != null ? CurrencyType.getCurrencyByNameOrCode(selectedPackagePricing.getCurrency()) : CurrencyType.getCurrencyByCode(LocationData.getCurrencyByCity(hotel.getCity()));
	}
	HotelRoomUnit roomUnit = null;
	MealPlanUnit mealUnit = null;
	if(selectedPackage != null) {
		roomUnit = (HotelRoomUnit)selectedPackage.getSellableUnit();
		mealUnit = roomUnit.getMealPlanUnit();
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	int minStay = 1;
	List<DayOfWeek> days = new ArrayList<DayOfWeek>();
	if(selectedPackagePricing != null) {
		minStay = selectedPackagePricing.getMinQty();
		days = selectedPackagePricing.getApplicableDaysAsList();
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
    Map<SellableUnitType, SupplierPackagePricing> retDealsMap = new HashMap<SellableUnitType, SupplierPackagePricing>();
    {
        List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
        if(retDealsList != null) {
        	for(SupplierPackagePricing retDeal: retDealsList){
        		retDealsMap.put(retDeal.getDealSellableUnitType(), retDeal);
        	}
        }
    }
%>
<html>
<head>
<title>Add Hotel Rates</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>

</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".select").select2();
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
	<% if(packages != null && !packages.isEmpty() && pricings != null) { %>
	<h5 class="widget-name">Hotel Rates Uploaded</h5>
	<table class="table">
		<tr>
			<th>Hotel</th>
			<th>Room Type</th>
			<th>Validity</th>
			<th>Currency</th>
			<th>Single</th>
			<th>Twin</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				boolean isReco = false;
				if(recos != null) {
					for(SupplierRecommendation reco : recos) {
						if(reco.getSupplierPackageId().longValue() == pkg.getId().longValue()) {
							isReco = true;
							break;
						}
					}
				}
				if(isReco) {
					continue;
				}
				HotelRoomUnit room = (HotelRoomUnit)pkg.getSellableUnit();
				List<SupplierPackagePricing> prices = pricings.get(pkg.getId());
				if(prices != null) {
				for(SupplierPackagePricing pricing : prices) { 
					isOdd = !isOdd;
					PricingComponents comp = pricing.getPricingComponents();
					double singleAdultPrice = 0;
					double twinAdultPrice = 0;
					if(comp != null) {
						Map<PricingComponentsKey, PriceAmount> priceMap = comp.getPriceMap();
						for(Iterator iter = priceMap.entrySet().iterator(); iter.hasNext();) {
							Map.Entry<PricingComponentsKey, PriceAmount> entry = (Map.Entry<PricingComponentsKey, PriceAmount>)iter.next();
							PricingComponentsKey key = entry.getKey();
							PriceAmount price = entry.getValue();
							if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_SINGLE) {
								singleAdultPrice = price.getPriceAmount();
							} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_TWIN) {
								twinAdultPrice = price.getPriceAmount();
							}
						}
					}
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:200px;font-size:11px;padding:8px"><%=MarketPlaceHotel.getHotelById(room.getHotelId()).getName()%></td>
			<td style="width:200px;font-size:11px;padding:8px"><%=room.getRoomType()%></td>
			<td style="width:120px;font-size:11px;padding:8px"><%=df.format(pricing.getTravelStartDate())%> to <%=df.format(pricing.getTravelEndDate())%></td>
			<td style="width:50px"><%=pricing.getCurrency()%></td>
			<td style="width:50px"><%=singleAdultPrice%></td>
			<td style="width:50px"><%=twinAdultPrice%></td>
			<% if(hotel != null) { %>			
			<td style="width:40px"><a href="/partner/hotel-rates?selectedSideNav=packages&pkgId=<%=pkg.getId()%>&pricingId=<%=pricing.getId()%>&hotelid=<%=hotel.getId()%>">Edit</a></td>
			<td style="width:40px"><a href="/partner/delete-hotel-rates?selectedSideNav=packages&pricingId=<%=pricing.getId()%>&hotelid=<%=hotel.getId()%>">Delete</a></td>
			<% } else { %>
			<td style="width:40px"><a href="/partner/hotel-rates?selectedSideNav=packages&pkgId=<%=pkg.getId()%>&pricingId=<%=pricing.getId()%>">Edit</a></td>
			<td style="width:40px"><a href="/partner/delete-hotel-rates?selectedSideNav=packages&pricingId=<%=pricing.getId()%>">Delete</a></td>
			<% } %>
		</tr>
		<% } } } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add New Hotel Rate/Package</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-hotel-rates" method="post">
		<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<input type="hidden" name="pricingId" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="destid" value="-1" />
		<input type="hidden" name="hotelid" value="<%=hotel != null ? hotel.getId() : -1%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Hotel Rate</h6>
				</div>
			</div>
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<% if(hotel == null) { %>
				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls"><input type="text"  value="<%=(roomUnit != null)?LocationData.getCityNameFromId(roomUnit.getSellableUnit().getDestId()):""%>" name="dCityEx" id="dCityEx" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Hotel Name</label>
					<div class="controls"><input type="text" name="hotelName" id="hotelName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12"></div>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label">Package/Rate Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12"></div>
				</div>
				<div class="control-group">
					<label class="control-label">Room</label>
					<div class="controls">
						<% if(roomUnit != null) { %>
						<span><%=roomUnit.getRoomType()%></span>
						<input type="hidden" name="roomtype" value="<%=roomUnit.getRoomId()%>$<%=roomUnit.getRoomType()%>" />
						<% } else { %>
						<select name="roomtype" id="roomtype">
							<option value="-1">- Select a room -</option>
						</select>
					<% } %>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Meal Plan:</label>
					<div class="controls">
					<% if(mealUnit != null) { %>
						<span><%=mealUnit.getMealPlanCode()%></span>
						<input type="hidden" name="mealplan" value="<%=mealUnit.getMealPlanCode()%>" />
					<% } else { %>
						<select name="mealplan" class="styled" tabindex="4" style="opacity: 0;">
							<option value="EP">Room Only</option>
							<option value="CP">Daily Breakfast</option>
							<option value="MAP">Breakfast and Lunch/Dinner</option>
							<option value="AP">All Meals</option>
						</select>
					<% } %>
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
				<div class="control-group" style="display:none">
					<label class="control-label">Sell it as:</label>
					<div class="controls">
						<select id="rateType" name="rateType" class="styled" tabindex="4">
							<option value="<%=AvailabilityType.AVAILABLE.name()%>"
							<%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.AVAILABLE)?"selected":""%>>Stand Alone</option>
							<option value="<%=AvailabilityType.PACKAGED.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.PACKAGED)?"selected":""%>>Bundled</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Minimum Stay</label>
					<div class="controls">
						<select name="minqty" class="styled" tabindex="4" style="opacity: 0;">
							<% for (int i = 1; i < 15; i++) { %>
							<option value="<%=i%>" <%=(minStay == i)?"selected":""%>><%=i%></option>
							<% } %>
						</select>
					</div>
				</div>
				<% if (user != null && user.getRoleType() == RoleType.TOUR_OPERATOR) { %>
				<div class="control-group">
				  <label class="control-label"> Freebies:</label>
				  <div class="controls">
					<select data-placeholder="Example: Hotel Bar, Pool, Gym, etc." name="freebies" class="select select2-offscreen" multiple="multiple" tabindex="-1">
					<%
						for (SellableUnitType  unitType: SellableUnitType.HOTEL_DEAL_OPTIONS)  {
							SupplierPackagePricing existingDeal = retDealsMap.get(unitType);
							boolean enabled = existingDeal != null;
					%>
					<option value="<%=unitType.name()%>" <%=(enabled)?"selected":""%>>Free <%=unitType.getDesc()%></option>
					<% } %>
					</select>
				  </div>
				</div>
				<% } %>
				<div class="control-group">
					  <label class="control-label">Currency:</label>
					  <div class="controls">
					  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
							<% for (CurrencyType curr: CurrencyType.values()) { %>
								<option <%=(currencyType != null && curr == currencyType) ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
							<% } %>
					  </select>						  
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Price per night:</label>
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
							<input type="checkbox" name="mon" value="mon" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.MONDAY))?"checked":""%>>
							Monday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="tue" value="tue" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.TUESDAY))?"checked":""%>>
							Tuesday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="wed" value="wed" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.WEDNESDAY))?"checked":""%>>
							Wednesday
						  </label>
						  <label class="checkbox">
							<input type="checkbox" name="thur" value="thur" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.THURSDAY))?"checked":""%>>
							Thursday
						  </label>
						</div>
						<div class="span3">
						  <label class="radio">
							<input type="checkbox" name="fri" value="fri" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.FRIDAY))?"checked":""%>>
							Friday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="sat" value="sat" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.SATURDAY))?"checked":""%>>
							Saturday
						  </label>
						  <label class="radio">
							<input type="checkbox" name="sun" value="sun" class="styled" <%=(days.isEmpty() || days.contains(DayOfWeek.SUNDAY))?"checked":""%>>
							Sunday
						  </label>
					</div>
				  </div>
			  </div>
			  <%
					List<String> terms = null;
					if(selectedPackage != null) {
						terms = selectedPackage.getTerms();
					}
				%>
				<div class="control-group">
					<label class="control-label">Cancellation Policy:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>		
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Update Rates</button>
				</div>		
				</div>
			</div>
			<!-- /HTML5 inputs -->
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
<% if(hotel != null) { %>
populateRooms(<%=hotel.getId()%>);
<% } %>
$jQ("#dCityEx").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.CITY_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  document.packageForm.destid.value = ui.item.data.id;
   }
});
$jQ("#hotelName").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.HOTEL_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term,
			city : document.packageForm.destid.value
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  document.packageForm.hotelid.value = ui.item.id;
	  populateRooms(ui.item.id);
   }
});

function populateRooms(id) {
	$jQ.ajax({
	 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.ROOM_SUGGEST)%>",
	 dataType: "json",
	 data: {
		hotel : document.packageForm.hotelid.value
	 },
	 success: function(data) {
		var select = $jQ('#roomtype').empty();
		$jQ.each(data, function() {
			$jQ.each(this, function(i,item) {
				select.append('<option value="' + this.id + '$' +  this.nm + '">' + this.nm + '</option>'); 
			});
		});
	 }
  });
}
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
