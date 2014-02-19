<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.hotels.data.HotelSearchQuery"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.supplier.SellableUnitManager"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	int hotelId = RequestUtil.getIntegerRequestParameter(request, "hotelid", -1);
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	SupplierPackage selectedPackage = (SupplierPackage)request.getAttribute(Attributes.PACKAGE.toString());
	SupplierPackagePricing selectedPackagePricing = (SupplierPackagePricing)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());
	PackageConfigData pkgConfig = (PackageConfigData)request.getAttribute(Attributes.PACKAGE_CONFIG.toString());

	long prec = RequestUtil.getLongRequestParameter(request,"prec",-1L);
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	List<Long> destinations = new ArrayList<Long>();
	HotelRoomUnit roomUnit = null;
	MealPlanUnit mealUnit = null;
	List<PackageTag> packageTags = null;
	if(selectedPackage != null) {
		try {
			roomUnit = (HotelRoomUnit)selectedPackage.getSellableUnit();
			mealUnit = roomUnit.getMealPlanUnit();
			packageTags = selectedPackage.getPackageTags();
		} catch (Exception e) {
		}
	}	
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	List<Destination> countries = DestinationContentManager.getAllDestinations(DestinationType.COUNTRY);
	List<PackageTag> tags = PackageTag.getImportantList();
	Set<DayOfWeek> days = selectedPackagePricing != null ? selectedPackagePricing.getApplicableDaysAsSet() : new HashSet<DayOfWeek>();
	List<ActivityTimeSlot> times = selectedPackagePricing != null ? selectedPackagePricing.getApplicableTimeAsList() : null;
	ActivityTimeSlot time = (times != null && !times.isEmpty()) ? times.get(0) : null;
	CurrencyType currencyType = selectedPackagePricing != null ? CurrencyType.getCurrencyByNameOrCode(selectedPackagePricing.getCurrency()) : null;
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	double maxSleeps = 2;
	int minStay = 1;
	if(selectedPackagePricing != null) {
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		maxSleeps = selectedPackagePricing.getMaxQty();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_SINGLE) {
					single = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_TWIN) {
					twin = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_EXTRA_ADULT) {
					adult = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD) {
					cwb = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD_WITHOUT_BED) {
					cob = price.getPriceAmount();
				}
			}
		}
	}
	List<PackageOptionalConfig> optionals = (List<PackageOptionalConfig>)request.getAttribute(Attributes.PACKAGE_OPTIONALS_DATA.toString());
	PackageOptionalConfig selectedOptional = null;
	if(optionals != null) {
		for(PackageOptionalConfig optional : optionals) {
			if(optional.getContentId() == roomUnit.getHotelId()) {
				selectedOptional = optional;
				break;
			}
		}
	}
%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFileManager"%>
<%@page import="com.eos.b2c.ui.FileUploadNavigation"%>
<%@page import="com.via.content.ContentFileType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<html>
<head>
<title>Edit Offer</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.SWF_UPLOAD_JS, null)%>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.UPLOAD_UTILS_JS, null)%>
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
});
</script>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<style type="text/css">
.row-fluid .span2 {width: 13%;float:left;}
</style>
<div class="spacer"></div>
<h5 class="widget-name">Add/Edit Stay Package 
	<a href="http://images.tripfactory.com/static/img/help/Add_Hotel_Package.docx" target="_blank" style="margin-left: 10px;"><img src="http://images.tripfactory.com/static/img/icons/iconHelp.gif" style="display:inline;height:16px;"></a>	
	<div class="u_floatR">
	  <a href="#" class="btn btn-primary">Next Step - Publish Your Package &raquo;</a>
	</div>
</h5>
<div style="margin-bottom:10px">
Some examples of packages search: <a target="_blank" href="/package/search?q=goa+hotel+packages+5+star">goa hotel packages 5 star</a>
</div>
<form id="packageForm" name="packageForm" action="/partner/save-hotel-package" class="rel form-horizontal" method="post">
  <input type="hidden" name="destid" value="-1" />
  <input type="hidden" name="pkgid" value="<%=selectedPackage != null ? selectedPackage.getId() : -1%>" />
  <input type="hidden" name="hotelid" value="<%=roomUnit != null ? roomUnit.getHotelId() : (hotelId > 0 ? hotelId : -1) %>" />
  <div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Edit Package Details <%=(hotelId > 0) ? " for " + MarketPlaceHotel.getHotelById(hotelId).getName() : ""%></h6>
				</div>
			</div>
			<div class="well">
				<div class="control-group">
					<label class="control-label">Package Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12" style="width:95%"></div>
				</div>
				<% if(hotelId < 0) { %>
				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls"><input type="text"  value="<%=(roomUnit != null)?LocationData.getCityNameFromId(roomUnit.getSellableUnit().getDestId()):""%>" name="dCityEx" id="dCityEx" style="width:95%" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Hotel Name</label>
					<div class="controls"><input type="text" name="hotelName" id="hotelName" style="width:95%" value="<%=(roomUnit != null)? MarketPlaceHotel.getHotelById(roomUnit.getHotelId()).getName():""%>" class="span12"></div>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label">Ideal For:</label>
					<div class="controls">
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.FIRST_TIME%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.FIRST_TIME)) ? "checked" : ""%> />&nbsp;<%=PackageTag.FIRST_TIME.getDisplayName()%>					
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.BUSINESS%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BUSINESS)) ? "checked" : ""%> />&nbsp;Business					
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.HONEYMOON%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.HONEYMOON)) ? "checked" : ""%> />&nbsp;Honeymoon					
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.BUDGET%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BUDGET)) ? "checked" : ""%> />&nbsp;Budget					
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.LUXURY%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.LUXURY)) ? "checked" : ""%> />&nbsp;Luxury					
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.FAMILY%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.FAMILY)) ? "checked" : ""%> />&nbsp;Families					
						</span>
						<span class="span2" style="margin-left:0">
							<input type="checkbox" name="<%=PackageTag.BACKPACKING%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BACKPACKING)) ? "checked" : ""%> />&nbsp;Backpackers					
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.BEACH%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BEACH)) ? "checked" : ""%> />&nbsp;Beach
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.SENIORS%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.SENIORS)) ? "checked" : ""%> />&nbsp;Elderly
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.OFFBEAT%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.OFFBEAT)) ? "checked" : ""%> />&nbsp;Off-beat 
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.ADVENTURE%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.ADVENTURE)) ? "checked" : ""%> />&nbsp;Adventure 
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.WEEKEND%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.WEEKEND)) ? "checked" : ""%> />&nbsp;Weekends 
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.EARLY_BIRD%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.EARLY_BIRD)) ? "checked" : ""%> />&nbsp;Early Bird 
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.LAST_MINUTE%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.LAST_MINUTE)) ? "checked" : ""%> />&nbsp;Last Minute
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.LONG_STAY%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.LONG_STAY)) ? "checked" : ""%> />&nbsp;Long Stay
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.SKI%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.SKI)) ? "checked" : ""%> />&nbsp;Skiing
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.GOLFING%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.GOLFING)) ? "checked" : ""%> />&nbsp;Golfing
						</span>
						<span class="span2">
							<input type="checkbox" name="<%=PackageTag.FOOTBALL%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.FOOTBALL)) ? "checked" : ""%> />&nbsp;Football
						</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Package Image:</label>
					<div class="controls">
						<div class="u_floatL">
							<img src="<%=(pkgConfig != null && StringUtils.isNotBlank(pkgConfig.getMainImageURL())) ? UIHelper.getImageURLForDataType(request, pkgConfig.getMainImageURL(), FileDataType.I200X100, true): "/static/img/photos/no_photo_200x150.jpg"%>" width="96" id="pkgImgPic"/>
						</div>
						<div style="margin-left:115px;">
							<p><b>Upload Image</b></p>
							<p class="u_smallF">Select an image file (only jpg or gif files) on your computer (2MB max):</p>
							<div>
								<input type="hidden" name="img_filename" id="img_filename" readonly="true" value="<%=(pkgConfig != null && StringUtils.isNotBlank(pkgConfig.getMainImageURL())) ? pkgConfig.getMainImageURL(): ""%>" style="margin-bottom: 7px;"/>&nbsp;<span id="uploadFileButton">Browse</span>
							</div>
							<div id="fileUploadProgBar" class="uplProgBar"></div>
						</div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">When the customer is:</h4>
				<div class="statement-group" style="margin-bottom:10px">
					<div class="control-group">
						<label class="control-label">Traveling Dates:</label>
						<div class="controls">
							<ul class="dates-range">
								<li><input type="text" placeholder="Start Travel Date" id="date" value="<%=fromDateStr%>" name="fromDate" class="datepicker" size="10" <%=prec > 0 ?"readonly":""%>><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
								<li class="sep">-</li>
								<li><input type="text" placeholder="End Travel Date" value="<%=toDateStr%>" id="date2" name="toDate" class="datepicker" size="10" <%=prec > 0 ?"readonly":""%>><span class="ui-datepicker-append"><%=toDateStr%></li>
							</ul>
						</div>
					</div>						
					<div class="control-group">
						<label class="control-label">Min length of stay:</label>
						<div class="controls">
							<select id="duration" name="duration" class="styled" tabindex="3">
								<option value="1" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 1)?"selected":""%>>One Night</option>
								<option value="2" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 2)?"selected":""%>>Two Nights</option>
								<option value="3" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 3)?"selected":""%>>Three Nights</option>
								<option value="4" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 4)?"selected":""%>>Four Nights</option>
								<option value="5" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 5)?"selected":""%>>Five Nights</option>
								<option value="6" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 6)?"selected":""%>>Six Nights</option>
								<option value="7" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 7)?"selected":""%>>One Week</option>
								<option value="14" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 14)?"selected":""%>>Two Weeks</option>
							</select>
						</div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
				<div class="statement-group">
					<div class="control-group">
						<div class="u_floatL" style="min-width:400px">
							<label class="control-label">Room Type</label>
							<div class="controls">
								<% if(roomUnit != null) { %>
								<span><%=roomUnit.getRoomType()%></span>
								<input type="hidden" name="roomtype" value="<%=roomUnit.getRoomId()%>$<%=roomUnit.getRoomType()%>" />
								<% } else { %>
								<select name="roomtype" id="roomtype">
									<option value="-1">- Select a room -</option>
								</select>
								<input type="text" name="roomname" id="roomname" style="width:90%;display:none" value="" />
							<% } %>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label">Meals:</label>
							<div class="controls">
								<select name="mealplan" class="styled" tabindex="4" style="opacity: 0;">
									<option value="EP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("EP"))?"selected":""%>>Room Only</option>
									<option value="CP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("CP"))?"selected":""%>>Daily Breakfast</option>
									<option value="MAP"<%=(mealUnit != null && mealUnit.getMealPlanCode().equals("MAP"))?"selected":""%>>Breakfast and Lunch/Dinner</option>
									<option value="AP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("AP"))?"selected":""%>>All Meals</option>
								</select>							
							</div>
						</div>
						<div class="u_clear"></div>						
					</div>													
					<div class="control-group" style="display:none">
						<label class="control-label">Add Ancillaries:</label>
						<div class="controls">
							<select data-placeholder="Add some freebies" name="freebies" class="select" multiple="multiple" tabindex="9">
								<% 
									if(retDealsList != null) {
									for(SupplierPackagePricing retDeal: retDealsList) {
										boolean enabled = true;
								%>
								<option value="<%=retDeal.getId()%>" <%=(enabled)?"selected":""%>><%=retDeal.getOptionTitle()%></option>
								<% } } %>
							</select>
						</div>
					</div>
					<div id="itinerary" class="control-group">
						<% 
							int count = 1;
							if(retDealsList != null) {
							for(SupplierPackagePricing retDeal: retDealsList) {
								boolean enabled = true;
						%>
						<div id="cityDiv<%=count%>">
							<div class="controls" style="margin-bottom:10px">
								<div class="u_floatL">
									<select name="dealType<%=count%>" id="dealType<%=count%>">
										<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %>			
										<option value="<%=unitType.name()%>" <%=(unitType == retDeal.getDealSellableUnitType()) ? "selected" : ""%>><%=unitType.getDesc()%></option>
										<% } %>
									</select>
								</div>
								<div class="u_floatL" style="margin-left:10px">
									<input size="50" type="text" name="title<%=count%>" value="<%=retDeal.getOptionTitle()%>" id="title<%=count%>" class="span12" />
								</div>
								<div class="u_clear"></div>
							</div>
						</div>				
						<% count++;} } %>					
					</div>
					<div class="control-group">
						<div class="u_floatL"><button type="button" id="addButton" class="btn btn-primary">Add New Freebie/Ancillary</button></div>
						<div class="u_floatL" style="margin-left:10px"><button type="button" id="removeButton" class="btn btn-danger">Remove Freebie/Ancillary</button></div>
						<div class="u_clear"></div>
					</div>
					<div class="control-group">
						<label class="control-label">Currency:</label>
						<div class="controls">
							<div class="row-fluid">
								<div class="span2">
								  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
										<% for (CurrencyType curr: CurrencyType.values()) { %>
											<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
										<% } %>
								  </select>
								</div>
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Price/Per Night:</label>
						<div class="controls">
							<div class="row-fluid">
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="sleepsMax" value="<%=(maxSleeps > 0 ? maxSleeps : 0)%>" /><span class="help-block">Max Occupancy</span>
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="twinSharing" value="<%=twin%>" /><span class="help-block">Per Night Price</span>
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
							<div class="clearfix"></div>
							<p style="font-size:11px;margin-top:10px">
							Please enter price per night valid for no. of persons entered in (max occupancy)
							</p>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Extra night price:</label>
						<div class="controls">
							<div class="row-fluid">
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="extraNight" value="<%=(selectedOptional != null && selectedOptional.getExtraNightPrice() != null) ? selectedOptional.getExtraNightPrice() : 0 %>" /><span class="help-block">Per Room/Night</span>
								</div>
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Website URL<br>(if applicable)</label>
						<div class="controls"><input type="text" name="supplierUrl" id="supplierUrl" value="<%=(selectedPackage != null && selectedPackage.getSupplierRedirectUrl() != null)?selectedPackage.getSupplierRedirectUrl():""%>" class="span12" style="width:95%" /></div>
					</div>
					<%
						List<String> terms = null;
						if(selectedPackage != null) {
							terms = selectedPackage.getTerms();
						}
					%>
					<div class="control-group">
						<label class="control-label">Terms and Conditions:</label>
						<div class="controls">
							<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px; width:100%"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
							<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
						</div>
					</div>							
					<div class="form-actions align-right">
						<button type="submit" class="btn btn-primary">Submit</button>
						<a href="/partner/hotel-packages"><button type="button" class="btn btn-danger">Cancel</button></a>
					</div>
				</div>
		</div>
  </div>
</form>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
<script type="text/javascript">
var counter = <%=count%>;
var uploadImg = null;
$jQ(document).ready(function() {
	uploadImg = new UploadImg({swfuversion: '<%=StaticFileVersions.SWF_UPLOAD_VERSION%>', uploadURL: '<%=FileUploadNavigation.getFileUploadBaseURL(request)%>', uploadDiv: null,
		params: {creator_id: '<%=loggedInUser.getUserId()%>', 'file_type': '<%=ContentFileType.IMAGE%>', file_category_type: '<%=ContentFileCategoryType.ITINERARY%>', file_sizegroup:'<%=FileSizeGroupType.RECT_2_1.name()%>', action1: '<%=FileUploadNavigation.UPLOAD_CONTENT_FILE_ACTION%>'}, swfSetting: {}, success: {handler: successUploadImg}});
	uploadImg.showUpload();
});
function successUploadImg(rsp) {
	var aO = JS_UTIL.parseJSON(rsp);
	$jQ("#pkgImgPic").attr("src", aO.url);
	$jQ("#img_filename").val(aO.turl);
}
$jQ("#addButton").click(function () {
	if(counter > 10){
		alert("Only 10 textboxes allow");
		return false;
	}
	var newTextBoxDiv = $jQ(document.createElement('div')).attr("id", 'cityDiv' + counter);
	var html = '<div class="controls" style="margin-bottom:10px"><div class="u_floatL"><select name="dealType' + counter + '" id="dealType' + counter + '">';
	html += '<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %><option value="<%=unitType.name()%>"><%=unitType.getDesc()%></option><% } %></select></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><input size="50" type="text"  value="" name="title' + counter + '" id="title' + counter + '" class="span12" /></div><div class="u_clear"></div></div>';
	newTextBoxDiv.html(html);
	newTextBoxDiv.appendTo("#itinerary");
	counter++;
});
$jQ("#removeButton").click(function () {
	if(counter==1){
	  alert("You cannot remove any more cities");
	  return false;
	 }
	 counter--;
	 $jQ("#cityDiv" + counter).remove();
 });
 
<% if(hotelId < 0)  { %>
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
<% } else { %>
populateRooms(<%=hotelId%>);
<% } %>
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
		if(data.length == 0) {
			$jQ('#roomtype').hide();
			$jQ('#roomname').show();
		}
	 }
  });
}
</script>
</body>
</html>
