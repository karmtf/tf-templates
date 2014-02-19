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
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>

<%@page import="com.poc.server.constants.AvailabilityType"%>

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
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%
	User loggedInUser = SessionManager.getUser(request);
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SupplierPackage selectedPackage = null;
	long pkgId = request.getParameter("pkgId") != null ? Long.parseLong(request.getParameter("pkgId")) : -1L;
	if(pkgId > 0) {
		for(SupplierPackage pkg : packages.values()) {
			if(pkg.getId() == pkgId) {
				selectedPackage = pkg;
				break;
			}
		}
	}
	SupplierPackagePricing selectedPackagePricing = (SupplierPackagePricing)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());;
	CurrencyType currencyType = selectedPackagePricing != null ? CurrencyType.getCurrencyByNameOrCode(selectedPackagePricing.getCurrency()) : null;
	SightseeingUnit sightseeingUnit = null;
	if(selectedPackage != null) {
		sightseeingUnit = (SightseeingUnit)selectedPackage.getSellableUnit();
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	double flat = 0;
	double adult = 0;
	double child = 0;
	if(selectedPackagePricing != null) {
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT) {
					adult = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_CHILD) {
					child = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_FULL_AMOUNT) {
					flat = price.getPriceAmount();
				}
			}
		}
	}
%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFileManager"%>
<%@page import="com.eos.b2c.ui.FileUploadNavigation"%>
<%@page import="com.via.content.ContentFileType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<html>
<head>
<title>Manage Activities and Excursions</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.SWF_UPLOAD_JS, null)%>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.UPLOAD_UTILS_JS, null)%>

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
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Activities/Tours Uploaded</h5>
	<table class="table">
		<tr>
			<th>Activity Name</th>
			<th>City</th>
			<th>Edit</th>
			<th>Publish</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				isOdd = !isOdd;
				SightseeingUnit sUnit = (SightseeingUnit)pkg.getSellableUnit();
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:400px"><%=pkg.getName()%></td>
			<td style="width:100px"><%=LocationData.getCityNameFromId(sUnit.getDestId())%></td>
			<td style="width:60px"><a href="/partner/tour-package?selectedSideNav=packages&pkgId=<%=pkg.getId()%>">Edit Tour</a></td>
			<td style="width:60px"><a href="/partner/publish-activity-package?selectedSideNav=packages&pkgId=<%=pkg.getId()%>">Publish</a></td>
			<td style="width:60px"><a href="/partner/delete-tour-package?selectedSideNav=packages&pkgid=<%=pkg.getId()%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add New Activity/Excursion
	<a href="http://images.tripfactory.com/static/img/help/Add_Activity.docx" target="_blank" style="margin-left: 10px;"><img src="http://images.tripfactory.com/static/img/icons/iconHelp.gif" style="display:inline;height:16px;"></a>
	</h5>
	<div style="margin-bottom:10px">
	Some examples of activites search: <a target="_blank" href="/package/search?q=singapore+sightseeing">singapore sightseeing</a>, <a target="_blank" href="/package/search?q=dubai+desert+safari+tour">dubai desert safari tour</a>, <a target="_blank" href="/package/search?q=disney+tickets">disney tickets</a>
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-tour-package" method="post">
		<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<input type="hidden" name="pricingId" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="destid" value="<%=(sightseeingUnit != null)?sightseeingUnit.getDestId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Activity</h6>
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
					<label class="control-label">Destination</label>
					<div class="controls"><input type="text"  value="<%=(sightseeingUnit != null)?LocationData.getCityNameFromId(sightseeingUnit.getDestId()):""%>" name="dCityEx" id="dCityEx" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Activity Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12"></div>
				</div>
				<div class="control-group">
					<label class="control-label">Duration</label>
					<div class="controls">
						<input type="text" name="duration" class="span12" id="duration" value="<%=(sightseeingUnit != null)?sightseeingUnit.getDuration():""%>" style="width:50px"/>&nbsp;hours
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Tour Description:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="description" id="description" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedPackage != null)?selectedPackage.getSupplierSpecificDesc():""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>					
				<div class="control-group">
					<label class="control-label">Inclusions:</label>
					<%
						List<String> inclusions = null;
						List<String> terms = null;
						List<String> exclusions = null;
						if(selectedPackage != null) {
							inclusions = selectedPackage.getFreeTextInclusions();
							terms = selectedPackage.getTerms();
							exclusions = selectedPackage.getExclusions();
						}
					%>
					<div class="controls">
						<textarea rows="5" cols="5" name="inclusions" id="inclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(inclusions != null && inclusions.size() >= 1)?inclusions.get(0):""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Exclusions:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="exclusions" id="exclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(exclusions != null && exclusions.size() >= 1)?exclusions.get(0):""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Max Capacity</label>
					<div class="controls">
						<input type="text" name="capacity" class="span12" id="capacity" value="<%=(sightseeingUnit != null)?sightseeingUnit.getMaxCapacity():""%>" style="width:50px"/>&nbsp;persons
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Min Capacity</label>
					<div class="controls">
						<input type="text" name="minqty" class="span12" id="minqty" value="<%=(selectedPackagePricing != null)? selectedPackagePricing.getMinQty():"0"%>" style="width:50px"/>&nbsp;persons
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
								<input type="text" class="spinner-currency span12" name="adultPrice" value="<%=adult%>" /><span class="help-block">Adult Price</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="childPrice" value="<%=child%>" /><span class="help-block">Child Price</span>
							</div>
						</div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Image:</label>
					<div class="controls">
						<div class="u_floatL">
							<img src="<%=(sightseeingUnit != null && StringUtils.isNotBlank(sightseeingUnit.getImage())) ? UIHelper.getImageURLForDataType(request, sightseeingUnit.getImage(), FileDataType.I200X100, true): "/static/img/photos/no_photo_200x150.jpg"%>" width="96" id="pkgImgPic"/>
						</div>
						<div style="margin-left:115px;">
							<p><b>Upload Image</b></p>
							<p class="u_smallF">Select an image file (only jpg or gif files) on your computer (2MB max):</p>
							<div>
								<input type="hidden" name="img_filename" id="img_filename" readonly="true" value="<%=(sightseeingUnit != null && StringUtils.isNotBlank(sightseeingUnit.getImage())) ? sightseeingUnit.getImage(): ""%>" style="margin-bottom: 7px;"/>&nbsp;<span id="uploadFileButton">Browse</span>
							</div>
							<div id="fileUploadProgBar" class="uplProgBar"></div>
						</div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Website URL<br>(if applicable)</label>
					<div class="controls"><input type="text" name="supplierUrl" id="supplierUrl" value="<%=(selectedPackage != null && selectedPackage.getSupplierRedirectUrl() != null)?selectedPackage.getSupplierRedirectUrl():""%>" class="span12"></div>
				</div>									
				<div class="control-group">
					<label class="control-label">Cancellation Policy:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>		
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Add This</button>
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
	  populateActivities(ui.item.data.id);
   }
});

function populateActivities(id) {
	$jQ.ajax({
	 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.TOURS_SUGGEST)%>",
	 dataType: "json",
	 data: {	
		city : document.packageForm.destid.value
	 },
	 success: function(data) {
		var select = $jQ('#pkgName').empty();
		select.append('<option value="-1">-- Select a Tour ---</option>');
		$jQ.each(data, function() {
			select.append('<option value="' + this.id + '">' + this.nm + '</option>');
		});
	 }
  });
}

function populateDesc() {
	$jQ.ajax({
	 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.FETCH_PLACE)%>",
	 dataType: "json",
	 data: {
		place : $jQ('#pkgName').val()
	 },
	 success: function(data) {
		var place = $jQ(data);
		$jQ('#desc').html(place[0].desc);
	 }
  });
}
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
