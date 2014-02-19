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
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.currency.CurrencyType"%>
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
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryDescription"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryStep"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageItineraryTemplate"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%
	User user = SessionManager.getUser(request);
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	PackageConfigData selectedPackage = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	List<CityConfig> itinerary = selectedPackage.getCityConfigs();
	List<PackageItineraryTemplate> templates = (List<PackageItineraryTemplate>)request.getAttribute(Attributes.ITINERARY_TEMPLATES.toString());
%>
<html>
<head>
<title>Edit Itinerary for <%=selectedPackage.getPackageName()%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<script type="text/javascript">
 function init(id,c) {
	$jQ("#" + id).autocomplete({
		minLength: 2,
		source: function(request, response) {
		
		
		
			$jQ.ajax({
			 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.PLACE_SUGGEST)%>",
			 dataType: "json",
			 data: {
				q: request.term,
				city : c
			 },
			 success: function(data) {
				response(data);
			 }
		  });
	   },
	   select: function(event, ui) {
		  var id = $jQ(this).attr("id");
		  $jQ('#' + id + 'dest').val(ui.item.id);
	   }
	});
 }
</script>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Edit Itinerary for <%=selectedPackage.getPackageName()%></h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-itinerary-config" method="post">
		<input type="hidden" name="pkgId" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Edit Itinerary</h6>
				</div>
			</div>
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">◊</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<% 
					int count = 1;
					int currCity = -1;
					int lastPos = 0;
					PackageItineraryTemplate template = null;
					for (CityConfig day : itinerary) { 
						currCity = day.getCityId();
						if(templates != null && !templates.isEmpty()) { 
							for(PackageItineraryTemplate temp : templates) {
								if(temp.getCityId() == currCity) {
									template = temp;
									break;
								}
							}
						}
						for (int j = 1; j <= day.getTotalNumNights(); j++) { 
							int cnt = 0;
							ItineraryDescription desc = null;
							if(template != null) {
								desc = template.getItineraryDescriptionForDay(j);
							}
				%>
				<div class="control-group">
					<label class="control-label">Day <%=count%>: <%=LocationData.getCityNameFromId(currCity)%></label>
				</div>
				<div class="control-group">
					<label class="control-label">Add Title</label>
					<div class="controls"><input type="text" name="dayTitle<%=j%>dest<%=day.getCityId()%>" value="<%=(desc != null)?desc.getDayTitle():""%>" class="span12"></div>
				</div>
				<div class="control-group" style="display:none">
					<label class="control-label">Day Description</label>
					<div class="controls">
						<textarea rows="3" cols="5" name="dayDesc<%=j%>dest<%=day.getCityId()%>" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height:60px;"><%=(desc != null)?desc.getDaySchedule():""%></textarea>
					</div>
				</div>
				<div class="control-group">
					<div class="u_floatL"><a href="#" onclick="addSlot(<%=j%>,<%=day.getCityId()%>);return false;" class="btn btn-primary">Add Item</a></div>
					<div class="u_clear"></div>
				</div>
				<div id="<%=day.getCityId()%>itinerary<%=j%>">
					<% 
						if(template != null) {
							List<ItineraryStep> steps = template.getItinerarySteps();
							for(ItineraryStep step : steps) {
								if(step.getDay() == j) {
					%>
					<div class="control-group itin">
						<label class="control-label">Add Place/Activity</label>
						<div class="controls">
							<div class="u_floatL"><input type="text" size="30" name="place<%=cnt%>" id="<%=j%>place<%=cnt%><%=day.getCityId()%>" class="ui-autocomplete-input span12" autocomplete="off" value="<%=DestinationContentManager.getDestinationFromId(step.getPlaceId()).getName()%>" /></div>
							<div class="u_floatL" style="margin-left:10px">
								<select name="<%=j%>slot<%=cnt%>dest<%=day.getCityId()%>" id="<%=j%>slot<%=cnt%>dest<%=day.getCityId()%>" class="span12"><option value="MORNING"
								<%=step.getTimeSlot().name().equals("MORNING")?"selected":""%>>Morning</option><option value="AFTERNOON" <%=step.getTimeSlot().name().equals("AFTERNOON")?"selected":""%>>Afternoon</option><option value="EVENING" <%=step.getTimeSlot().name().equals("EVENING")?"selected":""%>>Evening</option>
								</select>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<select name="<%=j%>currency<%=cnt%>dest<%=day.getCityId()%>" id="<%=j%>currency<%=cnt%>dest<%=day.getCityId()%>" class="span12">
									<% for (CurrencyType curr: CurrencyType.values()) { %><option value="<%=curr.getCurrencyCode()%>" <%=step.getCurrency().equals(curr.getCurrencyCode())?"selected":""%>><%=curr.getCurrencyCode()%></option><% } %>
								</select>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<input name="<%=j%>cost<%=cnt%>dest<%=day.getCityId()%>" id="<%=j%>currency<%=cnt%>dest<%=day.getCityId()%>" type="text" value="<%=step.getCost()%>" size="5" class="span12" />
							</div>
							<div class="u_clear"></div>
							<div class="spacer"></div>
							<div class="u_floatL">Comments</div><div class="u_floatL" style="margin-left:10px"><textarea name="<%=j%>comment<%=cnt%>dest<%=day.getCityId()%>" id="<%=j%>comment<%=cnt%>dest<%=day.getCityId()%>" type="text" rows=3 cols=60><%=step.getComment()%></textarea></div>							
							<div class="u_clear"></div>
							<input type="hidden" name="<%=j%>place<%=cnt%><%=day.getCityId()%>dest" id="<%=j%>place<%=cnt%><%=day.getCityId()%>dest" value="<%=step.getPlaceId()%>" />
						</div>
					</div>
					<script type="text/javascript">init('<%=j%>place<%=cnt%><%=day.getCityId()%>',<%=day.getCityId()%>)</script>
					<% cnt++;} %>
					<% } } %>
				</div>
				<% count++;lastPos=j;}} 
				   ItineraryDescription desc = null;
				   if(template != null) {
					   desc = template.getItineraryDescriptionForDay(lastPos+1);
				   }				
				%>
				<div id="<%=currCity%>itinerary<%=lastPos+1%>" class="control-group">
					<div class="control-group">
						<label class="control-label">Day <%=count%>: <%=LocationData.getCityNameFromId(currCity)%></label>
					</div>
					<div class="control-group">
						<label class="control-label">Add Title</label>
						<div class="controls"><input type="text" name="dayTitle<%=lastPos+1%>dest<%=currCity%>" value="<%=(desc != null)?desc.getDayTitle():""%>" class="span12"></div>
					</div>
					<div class="control-group" style="display:none">
						<label class="control-label">Add Description</label>
						<div class="controls">
							<textarea rows="5" cols="5" name="dayDesc<%=lastPos+1%>dest<%=currCity%>" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(desc != null)?desc.getDaySchedule():""%></textarea>
						</div>
					</div>
					<div class="control-group">
						<div class="u_floatL"><button type="button" onclick="addSlot(<%=lastPos+1%>,<%=currCity%>)" class="btn btn-primary">Add Item</button></div>
						<div class="u_clear"></div>
					</div>
					<% 
						if(template != null) {
							int cnt = 0;
							int j = lastPos+1;
							List<ItineraryStep> steps = template.getItinerarySteps();
							for(ItineraryStep step : steps) {
								if(step.getDay() == lastPos+1) {
					%>
					<div class="control-group itin">
						<label class="control-label">Add Place/Activity</label>
						<div class="controls">
							<div class="u_floatL"><input type="text" size="30" name="place<%=cnt%>" id="<%=j%>place<%=cnt%><%=currCity%>" class="ui-autocomplete-input span12" autocomplete="off" value="<%=DestinationContentManager.getDestinationFromId(step.getPlaceId()).getName()%>" /></div>
							<div class="u_floatL" style="margin-left:10px">
								<select name="<%=j%>slot<%=cnt%>dest<%=currCity%>" id="<%=j%>slot<%=cnt%>dest<%=currCity%>" class="span12"><option value="MORNING"
								<%=step.getTimeSlot().name().equals("MORNING")?"selected":""%>>Morning</option><option value="AFTERNOON" <%=step.getTimeSlot().name().equals("AFTERNOON")?"selected":""%>>Afternoon</option><option value="EVENING" <%=step.getTimeSlot().name().equals("EVENING")?"selected":""%>>Evening</option>
								</select>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<select name="<%=j%>currency<%=cnt%>dest<%=currCity%>" id="<%=j%>currency<%=cnt%>dest<%=currCity%>" class="span12">
									<% for (CurrencyType curr: CurrencyType.values()) { %><option value="<%=curr.getCurrencyCode()%>" <%=step.getCurrency().equals(curr.getCurrencyCode())?"selected":""%>><%=curr.getCurrencyCode()%></option><% } %>
								</select>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<input name="<%=j%>cost<%=cnt%>dest<%=currCity%>" id="<%=j%>currency<%=cnt%>dest<%=currCity%>" type="text" value="<%=step.getCost()%>" size="5" class="span12" />
							</div>
							<div class="u_clear"></div>
							<div class="spacer"></div>
							<div class="u_floatL">Comments</div><div class="u_floatL" style="margin-left:10px"><textarea name="<%=j%>comment<%=cnt%>dest<%=currCity%>" id="<%=j%>comment<%=cnt%>dest<%=currCity%>" type="text" rows=3 cols=60><%=step.getComment()%></textarea></div>							
							<div class="u_clear"></div>
							<input type="hidden" name="<%=j%>place<%=cnt%><%=currCity%>dest" id="<%=j%>place<%=cnt%><%=currCity%>dest" value="<%=step.getPlaceId()%>" />
						</div>
					</div>
					<script type="text/javascript">init('<%=j%>place<%=cnt%><%=currCity%>',<%=currCity%>)</script>
					<% cnt++;} %>
					<% } } %>
				</div>
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Save Itinerary</button>
				</div>		
				</div>
			</div>
			<!-- /HTML5 inputs -->
		</fieldset>
	</form>
</div>
</div>
<style type="text/css">
#footerFdkCtr {position:fixed; bottom:0; right:20px; font-size:13px; border-radius:5px 5px 0 0; box-shadow:0 0 5px #333; width:250px; text-align:left;}
#footerFdkCtr .topbar {background:#3672AA; padding:5px 10px;}
#footerFdkCtr .topbar a {color:#fff; display:block;}
#footerFdkCtr .fdkBd {background:#fff; padding:10px; font-size:12px; line-height:16px;}
#footerFdkCtr p {margin-bottom:8px; font-size:12px;}
#footerFdkCtr .fdkInp {padding:2px 0;}
#footerFdkCtr input {font-size:12px;}
#footerFdkCtr .fdkAct {background:#093; color:#fff;}
</style>
<div class="u_clear">
<div id="footerFdkCtr">
	<div class="topbar barclose"><a href="#">Are we missing something ?</a></div>
	<div class="fdkBd" style="display:none;">
		<form id="footerFdkForm" name="footerFdkForm">
			<p>Send us your suggestions or any places which we are missing to be added.</p>
			<% if (user == null) { %>
				<div class="fdkInp"><input type="text" name="name" value="" class="example" title="Your Name"/></div>
				<div class="fdkInp"><input type="text" name="email" value="" class="example" title="Your Email"/></div>
			<% } %>
			<div class="fdkInp"><textarea name="message" class="example" rows="5" style="width:230px" title="Send us suggestions, any places to add which are missing"></textarea></div>
			<div class="u_alignR fdkInp"><a href="#" class="fdkAct btn btn-primary">Send</a></div>
		</form>
	</div>
</div>
<script type="text/javascript">
$jQ(document).ready(function() {
	POCUTIL.initFeedbackFt();
});
function addSlot(day, c) {
	var counter = $jQ("#" + c + "itinerary" + day + " .itin").length;
	var newTextBoxDiv = $jQ(document.createElement('div')).attr("id", day + 'itinDiv' + counter).attr("class", 'control-group itin');
	var html = '<label class="control-label">Add Place/Activity</label><div class="controls"><div class="u_floatL"><input type="text" size="30" value="" name="' + day + 'place' + counter + c + '" id="' + day + 'place' + counter + c + '" class="ui-autocomplete-input span12" autocomplete="off" /></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><select name="' + day + 'type' + counter + 'dest' + c + '" id="' + day + 'type' + counter + 'dest' + c + '" class="span12"><option value="airport">Airport</option><option value="see">Places to see</option><option value="do">Things to do</option><option value="eat">Places to eat</option><option value="shop">Shopping</option><option value="nightlife">Nightlife</option></select><div class="u_clear"></div></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><select name="' + day + 'slot' + counter + 'dest' + c + '" id="' + day + 'slot' + counter + 'dest' + c + '" class="span12"><option value="MORNING">Morning</option><option value="AFTERNOON">Afternoon</option><option value="EVENING">Evening</option></select><div class="u_clear"></div></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><select name="' + day + 'currency' + counter + 'dest' + c + '" id="' + day + 'slot' + counter + 'dest' + c + '" class="span12"><% for (CurrencyType curr: CurrencyType.values()) { %><option value="<%=curr.getCurrencyCode()%>"><%=curr.getCurrencyCode()%></option><% } %></select><div class="u_clear"></div></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><input name="' + day + 'cost' + counter + 'dest' + c + '" id="' + day + 'cost' + counter + 'dest' + c + '" type="text" value="0" size="5" class="span12" /><div class="u_clear"></div></div>';
	html += '<div class="u_clear"></div><div class="spacer"></div><div class="u_floatL">Comments</div><div class="u_floatL" style="margin-left:10px"><textarea name="' + day + 'comment' + counter + 'dest' + c + '" id="' + day + 'comment' + counter + 'dest' + c + '" type="text" rows=3 cols=60></textarea></div>';
	newTextBoxDiv.html(html);
	newTextBoxDiv.appendTo("#" + c + "itinerary" + day);
	var input = $jQ(document.createElement('input')).attr("id", day + 'place' + counter + c + 'dest').attr("name", day + 'place' + counter + c + 'dest').attr("type", 'hidden').attr("value", '-1');
	input.appendTo("#" + c + "itinerary" + day);
	$jQ("#" + day + "place" + counter + c).autocomplete({
		minLength: 2,
		source: function(request, response) {		
			if($jQ("#" + day + "type" + counter + "dest" + c).val() == 'hotel') { 
				$jQ.ajax({
				 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.HOTEL_SUGGEST)%>",
				 dataType: "json",
				 data: {
					q: request.term,
					city : c
				 },
				 success: function(data) {
					response(data);
				 }
			  });
			} else if($jQ("#" + day + "type" + counter + "dest" + c).val() == 'do') { 
				$jQ.ajax({
				 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.ACTIVITY_SUGGEST)%>",
				 dataType: "json",
				 data: {
					q: request.term,
					city : c
				 },
				 success: function(data) {
					response(data);
				 }
			  });
			} else if($jQ("#" + day + "type" + counter + "dest" + c).val() == 'airport') { 
				$jQ.ajax({
				 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.AIRPORT_SUGGEST)%>",
				 dataType: "json",
				 data: {
					q: request.term,
					city : c
				 },
				 success: function(data) {
					response(data);
				 }
			  });
			} else if($jQ("#" + day + "type" + counter + "dest" + c).val() == 'eat') { 
				$jQ.ajax({
				 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.EAT_SUGGEST)%>",
				 dataType: "json",
				 data: {
					q: request.term,
					city : c
				 },
				 success: function(data) {
					response(data);
				 }
			  });
			} else if($jQ("#" + day + "type" + counter + "dest" + c).val() == 'shop') { 
				$jQ.ajax({
				 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.SHOP_SUGGEST)%>",
				 dataType: "json",
				 data: {
					q: request.term,
					city : c
				 },
				 success: function(data) {
					response(data);
				 }
			  });
			} else if($jQ("#" + day + "type" + counter + "dest" + c).val() == 'nightlife') { 
				$jQ.ajax({
				 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.NIGHTLIFE_SUGGEST)%>",
				 dataType: "json",
				 data: {
					q: request.term,
					city : c
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
					city : c
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
	   }
	});
 }
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
