<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="java.util.List"%>

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


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.eos.gds.data.Carrier"%>
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
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.supplier.SellableUnitManager"%>

<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.via.content.ContentDataType"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	KnowledgeRelationship kr = (KnowledgeRelationship)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	UserInputState lhsState = null;
	UserInputState rhsState = null;
	User user = SessionManager.getUser(request);	
	FlightUnit flightUnit = null;
	HotelRoomUnit roomUnit = null;
	MealPlanUnit mealUnit = null;
	HotelRoomUnit roomUnit2 = null;
	MealPlanUnit mealUnit2 = null;
	if(kr != null) {
		lhsState = kr.getLhsState();
		rhsState = kr.getRhsState();
		SupplierPackage lhsPackage = (SupplierPackage)request.getAttribute("lhsPackage");
		SupplierPackage rhsPackage = (SupplierPackage)request.getAttribute("rhsPackage");
		if(lhsPackage != null) {
			roomUnit = (HotelRoomUnit)lhsPackage.getSellableUnit();
			mealUnit = roomUnit.getMealPlanUnit();
		}
		if(rhsPackage != null) {
			roomUnit = (HotelRoomUnit)rhsPackage.getSellableUnit();
			mealUnit = roomUnit2.getMealPlanUnit();
		}
	}
%>
<html>
<head>
<title>Edit Shopping Flow</title>
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
});
</script>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<style type="text/css">
.row-fluid .span2 {width: 12%;}
</style>
<div class="spacer"></div>
<h5 class="widget-name"><i class="icon-columns"></i>Edit Active Shopping Flow</h5>
<div>
<form id="campaignForm" name="campaignForm"  action="/partner/save-shoppingflow" class="rel form-horizontal" method="post">
  <input type=hidden name="hotelid" value="<%=(hotel != null) ? hotel.getId() : -1%>" />
  <input type=hidden name="product" value="hotel"/>
  <input type=hidden name="sourceId" value="-1"/>
  <input type=hidden name="destId" value="-1"/>
  <input type=hidden name="id" value="<%=(kr != null)?kr.getId():-1%>"/>
  <div class="widget">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Edit Shopping Flow</h6>
				</div>
			</div>
			<div class="well">
				<div class="control-group">
					<label class="control-label">Flow Name:</label>
					<div class="controls"><input type="text" name="ruleName" id="ruleName" value="<%=(kr != null)?kr.getRelationshipName():""%>" class="span12" style="width:95%"></div>
				</div>									
				<h4 class="statement-title" style="margin-top:15px">When the customer is:</h4>
				<div class="statement-group" style="margin-bottom:10px">
					<div class="control-group">
						<label class="control-label">Nationality:</label>
						<div class="controls">
							<select data-placeholder="Choose traveler nationality" name="ethnicity" class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(TravelerEthnicity type : TravelerEthnicity.values()) { %>
								<option value="<%=type.name()%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.TRAVELER_EHTNICITY, true).getState(type) > 0)?"selected":""%>><%=type.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<% if(user.getRoleType() == RoleType.AIRLINE) { %>
					<div class="control-group">
						<label class="control-label">Traveling from</label>
						<div class="controls"><input type="text"  value="<%=(flightUnit != null)?LocationData.getCityNameFromId(flightUnit.getSourceId()):""%>" name="source" id="source" class="ui-autocomplete-input span12" autocomplete="off" style="width:90%" /></div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling to</label>
						<div class="controls"><input type="text"  value="<%=(flightUnit != null)?LocationData.getCityNameFromId(flightUnit.getDestId()):""%>" name="dest" id="dest" class="ui-autocomplete-input span12" autocomplete="off" style="width:90%"/></div>
					</div>
					<% } %>
					<div class="control-group">
						<label class="control-label">Visiting For:</label>
						<div class="controls">
							<select data-placeholder="Choose travel theme" name="purpose"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(HolidayPurposeType tag : HolidayPurposeType.values()) { %>
								<option value="<%=tag.name()%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.HOLIDAY_PURPOSE, true).getState(tag) > 0)?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
				<div class="statement-group">
					<div class="control-group">
						<label class="control-label">Selected Room Type:</label>
						<div class="controls">
							<select id="roomtype" name="roomtype2" class="styled" tabindex="4" style="opacity: 0;">
								<% for (HotelRoom room : mpRooms) { %>
								<option value="<%=room.getId()%>$<%=room.getRoomName()%>" <%=(roomUnit!=null && roomUnit.getRoomId() == room.getId())?"selected":""%>><%=room.getRoomName()%></option>
								<% } %>
							</select>
						</div>
					</div>  					
					<div class="control-group">
						<label class="control-label">Selected Meal Plan:</label>
						<div class="controls">
							<select name="mealplan2" class="styled" tabindex="4" style="opacity: 0;">
								<option value="EP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("EP"))?"selected":""%>>Room Only</option>
								<option value="CP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("CP"))?"selected":""%>>Daily Breakfast</option>
								<option value="MAP"<%=(mealUnit != null && mealUnit.getMealPlanCode().equals("MAP"))?"selected":""%>>Breakfast and Lunch/Dinner</option>
								<option value="AP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("AP"))?"selected":""%>>All Meals</option>
							</select>
						</div>
					</div>
					<div class="form-actions align-right">
						<button type="submit" class="btn btn-primary">Submit</button>
						<a href="/partner/shoppingflows"><button type="button" class="btn btn-danger">Cancel</button></a>
					</div>
				</div>
		</div>
  </div>
</form>
</div>
<script type="text/javascript">
<% if(user.getRoleType() == RoleType.AIRLINE) { %>
$jQ("#source").autocomplete({
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
	  document.campaignForm.sourceId.value = ui.item.data.id;
   }
});
$jQ("#dest").autocomplete({
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
	  document.campaignForm.destId.value = ui.item.data.id;
   }
});
<% } %>
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
