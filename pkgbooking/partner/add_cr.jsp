<%@page import="com.eos.b2c.holiday.data.TravelerVisitFrequency"%>
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
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.ShoppingCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
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
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.via.content.ContentDataType"%>
<%
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	KnowledgeRelationship kr = (KnowledgeRelationship)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	int relid = RequestUtil.getIntegerRequestParameter(request, "relid", -1);
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	UserInputState lhsState = null;
	UserInputState rhsState = null;
	if(kr != null) {
		lhsState = kr.getLhsState();
		rhsState = kr.getRhsState();
	}
	int cityId = -1;
	if(lhsState != null && lhsState.getUserInputForInputType(UserInputType.CITY, true).getValue() != null) { 
		cityId = (Integer)lhsState.getUserInputForInputType(UserInputType.CITY, true).getValue();
	}
	int sourceCity = -1;
	if(lhsState != null && lhsState.getUserInputForInputType(UserInputType.SOURCE_CITY, true).getValue() != null) { 
		sourceCity = (Integer)lhsState.getUserInputForInputType(UserInputType.SOURCE_CITY, true).getValue();
	}
	Set<Integer> hotels = null;
	Set<Long> places = null;
	if(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getState(ViaProductType.HOTEL) > 0) {
		hotels = rhsState.getUserInputForInputType(UserInputType.HOTEL, true).getValues();
	} else if(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getState(ViaProductType.DESTINATION) > 0) {
		places = rhsState.getUserInputForInputType(UserInputType.PLACE, true).getValues();
	} else if(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getState(ViaProductType.AIRPORT) > 0) {
		places = rhsState.getUserInputForInputType(UserInputType.PLACE, true).getValues();
	}
	String product = null;
	if(lhsState != null) {
		ViaProductType productType = (ViaProductType)lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getValue();
		if(productType == ViaProductType.DESTINATION) {
			ContentDataType contentType = (ContentDataType)lhsState.getUserInputForInputType(UserInputType.HIGH_LEVEL_PLACE_TYPE, true).getValue();
			if(contentType == ContentDataType.DESTINATION_ACTIVITIES) {
				product = "do";
			}
		} else {
			product = productType.name().toLowerCase();
		}
	}
%>
<html>
<head>
<title>Add Knowledge Relationship</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".select").select2();
});
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Add New Contribution</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-kr-rules" method="post">
		<% if(relid > 0) { %>
		<input type="hidden" name="relid" value="<%=relid%>" />
		<% } else { %>
		<input type="hidden" name="id" value="<%=(kr != null)?kr.getId():"-1"%>" />
		<% } %>
		<input type="hidden" name="city" value="<%=cityId%>" />
		<% if(product != null) { %>
		<input type="hidden" id="product" name="product" value="<%=product.toLowerCase()%>" />
		<% } else { %>
		<input type="hidden" id="product" name="product" value="airport" />
		<% } %>
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Contribution</h6>
				</div>
			</div>
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">◊</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<div class="statement-group" style="margin-bottom:10px">	
					<div class="control-group">
						<label class="control-label">Heading Title:</label>
						<div class="controls"><input type="text" name="ruleName" id="ruleName" value="<%=(kr != null)?kr.getRelationshipName():""%>" class="span12"></div>
					</div>
					<div class="control-group">
						<label class="control-label">Coming into</label>
						<div class="controls"><input type="text"  value="<%=LocationData.getCityNameFromId(cityId)%>" name="dCityEx" id="dCityEx" class="ui-autocomplete-input span12" autocomplete="off" /></div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling Purpose:</label>
						<div class="controls">
							<select data-placeholder="Choose travel purpose" name="purpose"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(HolidayPurposeType tag : HolidayPurposeType.getPurposeTypes()) { %>
								<option value="<%=tag.name()%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.HOLIDAY_PURPOSE, true).getState(tag) > 0)?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Duration of Time</label>
						<div class="controls">
							<select data-placeholder="Choose time duration" name="minDuration" class="select" tabindex="0">
								<% for (int i = 0; i <= 14; i++) { %>
									<option value="<%=i%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.LAYOVER_DURATION, true).getState(i) > 0)?"selected":""%>><%=i%> hours</option>
								<% } %>
							</select>						
						</div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">Your recommendations:</h4>
				<div class="statement-group">
					<%
						Iterator iter = null;
						if(places != null && !places.isEmpty()) {
							iter = places.iterator();
						}
						if(hotels != null && !hotels.isEmpty()) {
							iter = hotels.iterator();
						}
						long placeId = -1L;
						int hotelId = -1;
						String name = "";
						for(int i = 1; i <= 5; i++) {
							if(places != null && !places.isEmpty() && iter.hasNext()) {
								placeId = (Long)iter.next();
								name = DestinationContentManager.getDestinationNameFromId(placeId);
							} else if(hotels != null && !hotels.isEmpty() && iter.hasNext()) {
								hotelId = (Integer)iter.next(); 
								name = MarketPlaceHotel.getHotelById(hotelId).getName();
							} else {
								placeId = -1L;
								name = "";
								hotelId = -1;
							}
					%>
					<div class="control-group">
						<label class="control-label">Place <%=i%></label>
						<div class="controls">
							<input type="text" value="<%=name%>" name="place<%=i%>" class="place" id="place<%=i%>" class="ui-autocomplete-input span12" autocomplete="off" style="width:100%" />
							<input type="hidden" value="<%=placeId >  0 ? placeId : (hotelId > 0 ? hotelId : "-1")%>" name="place<%=i%>dest" id="place<%=i%>dest" class="ui-autocomplete-input span12" autocomplete="off" />
						</div>
					</div>
					<% } %>
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
var counter = 1;
function changeOptions() {
	$jQ('.reco').hide();
	var sel = $jQ('#product').val();
	$jQ('.' + sel).show();
}
changeOptions();
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
	  document.packageForm.city.value = ui.item.data.id;
   }
});
$jQ(".place").autocomplete({
	minLength: 2,
	source: function(request, response) {
		if($jQ('#product').val() == 'hotel') { 
			$jQ.ajax({
			 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.HOTEL_SUGGEST)%>",
			 dataType: "json",
			 data: {
				q: request.term,
				city : document.packageForm.city.value
			 },
			 success: function(data) {
				response(data);
			 }
		  });
		} else if($jQ('#product').val() == 'holiday') { 
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
		} else if($jQ('#product').val() == 'do') { 
			$jQ.ajax({
			 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.ACTIVITY_SUGGEST)%>",
			 dataType: "json",
			 data: {
				q: request.term,
				city : document.packageForm.city.value
			 },
			 success: function(data) {
				response(data);
			 }
		  });
		} else { 
			$jQ.ajax({
			 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.PLACE_SUGGEST)%>",
			 dataType: "json",
			 data: {
				q: request.term,
				city : document.packageForm.city.value
			 },
			 success: function(data) {
				response(data);
			 }
		  });
		}
   },
   select: function(event, ui) {
	  var id = $jQ(this).attr("id");
	  if(ui.item.data) {
	  	$jQ('#' + id + 'dest').val(ui.item.data.id);
	  } else {
	  	$jQ('#' + id + 'dest').val(ui.item.id);
	  }
   },
   change: function(event, ui) {
	  var id = $jQ(this).attr("id");
	  if($jQ(this).val() == '') {
		$jQ('#' + id + 'dest').val("-1");
	  }
   }
});
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
