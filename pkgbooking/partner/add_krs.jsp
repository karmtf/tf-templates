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
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	UserInputState lhsState = null;
	UserInputState rhsState = null;	
	List<Destination> areas = null;
	int cityId = -1;
	if(kr != null) {
		lhsState = kr.getLhsState();
		rhsState = kr.getRhsState();
		cityId = (Integer)lhsState.getUserInputForInputType(UserInputType.CITY, true).getValue();
		if(cityId > 0) {
			areas = (List<Destination>)DestinationContentManager.getChildrenForCity(cityId, DestinationType.AREA);
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
	<h5 class="widget-name">Add New Knowledge Rule <%=cityId > 0 ? "for" + LocationData.getCityNameFromId(cityId) : ""%></h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-kr-rules" method="post">
		<input type="hidden" name="id" value="<%=(kr != null)?kr.getId():"-1"%>" />
		<input type="hidden" name="city" value="<%=cityId%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Rule</h6>
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
					<label class="control-label">City</label>
					<div class="controls"><input type="text"  value="<%=(cityId > 0)?LocationData.getCityNameFromId(cityId):""%>" name="dCityEx" id="dCityEx" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Rule Name:</label>
					<div class="controls"><input type="text" name="ruleName" id="ruleName" value="<%=(kr != null)?kr.getRelationshipName():""%>" class="span12"></div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">When the user:</h4>
				<div class="statement-group" style="margin-bottom:10px">	
					<div class="control-group">
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
					<div class="control-group">
						<label class="control-label">Traveler Type:</label>
						<div class="controls">
							<select data-placeholder="Choose travel purpose" name="traveler"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(TravelerType type : TravelerType.values()) { %>
								<option value="<%=type.name()%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.TRAVELER_TYPE, true).getState(type) > 0)?"selected":""%>><%=type.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling Purpose:</label>
						<div class="controls">
							<select data-placeholder="Choose travel theme" name="purpose"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(HolidayPurposeType tag : HolidayPurposeType.values()) { %>
								<option value="<%=tag.name()%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.HOLIDAY_PURPOSE, true).getState(tag) > 0)?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Looking for:</label>
						<div class="controls">
							<select id="product" name="product" class="styled" tabindex="4" onchange="changeOptions()">
								<option value="holiday" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getState(ViaProductType.HOLIDAY) > 0)?"selected":""%>>Holiday Packages</option>
								<option value="hotel" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getState(ViaProductType.HOTEL) > 0)?"selected":""%>>Hotels</option>
								<option value="see" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.HIGH_LEVEL_PLACE_TYPE, true).getState(ContentDataType.DESTINATION_ATTRACTIONS) > 0)?"selected":""%>>Places to see</option>
								<option value="do" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.HIGH_LEVEL_PLACE_TYPE, true).getState(ContentDataType.DESTINATION_ACTIVITIES) > 0)?"selected":""%>>Things to do</option>
								<option value="eat" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PLACE_TYPE, true).getState(DestinationType.RESTAURANT) > 0)?"selected":""%>>Places to eat</option>
								<option value="shop" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.PLACE_TYPE, true).getState(DestinationType.SHOPPING_PLACE) > 0)?"selected":""%>>Shopping</option>
							</select>
						</div>
					</div>
					<div class="control-group reco hotel holiday">
						<label class="control-label">Star Rating:</label>
						<div class="controls">
							<select data-placeholder="Choose star rating" name="starLhs"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for (int i = 1; i <= 5; i++) { %>
									<option value="<%=i%>" <%=(lhsState != null && lhsState.getUserInputForInputType(UserInputType.STAR_RATING, true).getState(i) > 0)?"selected":""%>><%=i%> star</option>
								<% } %>
							</select>
						</div>
					</div>					
				</div>
				<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
				<div class="statement-group">
					<div class="control-group reco hotel holiday">
						<label class="control-label">Avg Duration:</label>
						<div class="controls">
							<select data-placeholder="Select duration" name="duration"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for (int i = 1; i <= 21; i++) { %>
									<option value="<%=i%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.DURATION, true).getState(i) > 0)?"selected":""%>><%=i%> days</option>
								<% } %>
							</select>
						</div>
					</div>	
					<div class="control-group reco hotel holiday">
						<label class="control-label">Star Rating:</label>
						<div class="controls">
							<select data-placeholder="Choose star rating" name="star"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for (int i = 1; i <= 5; i++) { %>
									<option value="<%=i%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.STAR_RATING, true).getState(i) > 0)?"selected":""%>><%=i%> star</option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group reco holiday see do">
						<label class="control-label">Travel Theme:</label>
						<div class="controls">
							<select data-placeholder="Choose travel theme" name="theme"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(HolidayThemeType tag : HolidayThemeType.values()) { %>
								<option value="<%=tag.name()%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.HOLIDAY_THEME, true).getState(tag) > 0)?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group reco hotel">
						<label class="control-label">Hotel Theme:</label>
						<div class="controls">
							<select data-placeholder="Choose travel theme" name="hotel_theme"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(MarketPlaceHotel.Themes theme : MarketPlaceHotel.Themes.values()) { %>
								<option value="<%=theme.name()%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.HOTEL_THEME, true).getState(theme) > 0)?"selected":""%>><%=theme.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group reco hotel">
						<label class="control-label">Amenities:</label>
						<div class="controls">
							<select data-placeholder="Select amenities" name="amenity"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(MarketPlaceHotel.Amenities amen : MarketPlaceHotel.Amenities.values()) { %>
								<option value="<%=amen.name()%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.HOTEL_AMENITY, true).getState(amen) > 0)?"selected":""%>><%=amen.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group reco hotel holiday">
						  <label class="control-label">Budget under:</label>
						  <div class="controls">
							<div class="row-fluid">
								<div class="span2">
									US Dollar ($)
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="budget" value="<%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.BUDGET, true).getFirstValue() != null)? rhsState.getUserInputForInputType(UserInputType.BUDGET, true).getFirstValue():0.0%>" /><span class="help-block"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="control-group reco hotel eat see do shop">
						<label class="control-label">Nearby Area:</label>
						<div class="controls">
							<select data-placeholder="Select areas applicable" name="area"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% if(areas != null) { %>
								<% for(Destination area : areas) { %>
								<option value="<%=area.getId()%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.NEAR_BY_PLACE, true).getState(area.getId()) > 0)?"selected":""%>><%=area.getName()%></option>
								<% } %>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group reco eat">
						<label class="control-label">Cuisine Type:</label>
						<div class="controls">
							<select data-placeholder="Select cuisines or dining types" name="cuisine"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(DestinationCuisineType cuisine : DestinationCuisineType.values()) { %>
								<option value="<%=cuisine.name()%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.CUISINE, true).getState(cuisine) > 0)?"selected":""%>><%=cuisine.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group reco shop">
						<label class="control-label">Shopping Category:</label>
						<div class="controls">
							<select data-placeholder="Choose shopping categories" name="shopping"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(ShoppingCategoryType category : ShoppingCategoryType.values()) { %>
								<option value="<%=category.name()%>" <%=(rhsState != null && rhsState.getUserInputForInputType(UserInputType.SHOPPING_CATEGORY, true).getState(category) > 0)?"selected":""%>><%=category.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
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
function changeOptions() {
	$jQ('.reco').hide();
	var sel = $jQ('#product').val();
	$jQ('.' + sel).show();
}
changeOptions();
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
