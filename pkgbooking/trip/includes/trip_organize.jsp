<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());
%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.TripAction"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.eos.b2c.ui.action.SubActions.PlacesAction"%>
<div id="tripOrgnzVw">
<% if (pkgConfig != null) { %>
<div class="u_block">
	<div class="u_floatL" style="width:200px;">
	<% 
		int totalCities = pkgConfig.getCityConfigs().size();
		int currentCityCount = 0;
		for (CityConfig cityConfig: pkgConfig.getCityConfigs()) { 
		    String cityKey = PackageConfigManager.getPackageCityKey(cityConfig.getCityId(), currentCityCount);
		    boolean isLastCity = (currentCityCount == totalCities - 1);
	        currentCityCount++;
	        
	        int numDaysInCity = cityConfig.getTotalNumNights() + (isLastCity ? 1: 0);
	%>
		<div id="itnCty<%=cityKey%>" class="itnCty posR" style="margin-bottom:10px;">
			<div class="bkClose" style="display:none;"></div>
			<div style="background:#333; color:#fff; font-size:12px; padding:5px 10px;"><b><%=cityConfig.getCityNameWithArea()%></b></div>
			<div style="border:1px solid #333; border-top:0; padding:2px;">
				<% for (int day = 1; day <= numDaysInCity; day++) { %>
					<div id="itnTb<%=cityConfig.getCityId()%><%=day%>" class="itnTb"><a href="#" onclick="ITNORGNZ.showItn(<%=cityConfig.getCityId()%>, <%=day%>); return false;">Day <%=day%></a></div>
				<% } %>
				<div class="itnTb"><a href="#" onclick="ITNORGNZ.addDay('<%=cityKey%>'); return false;" class="t_icon t_add">Add Day</a></div>
			</div>
		</div>
	<% } %>
	</div>

	<div class="u_floatR" style="width:750px;">
	<% 
		for (int day = 1; day <= pkgConfig.getNumberOfNights() + 1; day++) {
		    PackageDayItinerary pkgDayItn = pkgItinerary.getPackageDayItinerary(day);
		    int dayInCity = pkgDayItn.getDayInCity();
	%>
		<div id="itnVw<%=pkgDayItn.getCityId()%><%=dayInCity%>" class="cityDayItnVw" style="display:none;">
			<div class="u_block">
				<h2 class="u_floatL" style="font-size:22px; font-weight:normal; margin:0 0 0.2em;"><%=pkgDayItn.getDayTitle()%> - Day <%=dayInCity%></h2>
				<div class="u_floatR">
					<a href="#" class="t_icon t_add" onclick="ITNORGNZ.loadCityExploreAdd(<%=pkgDayItn.getCityId()%>, '<%=pkgDayItn.getCityKey()%>', <%=dayInCity%>); return false;" style="display:none;">Add Place</a>
					<a href="#" class="gryBLn" onclick="ITNORGNZ.removeDay('<%=pkgDayItn.getCityKey()%>', <%=dayInCity%>); return false;">remove</a>
				</div>
			</div>
			<%
				for (ActivityTimeSlot timeSlot: ActivityTimeSlot.getTimeSlotInChronologicalOrder()) {
				    List<DayItinerary> dayActivities = pkgDayItn.getAcitivitiesForTimeSlot(timeSlot);
				    if (dayActivities == null) {
				        continue;
				    }
			%>
				<div>
					<h3 style="font-size:15px; padding:3px 8px; background:#eee;"><%=timeSlot.getDisplayText()%></h3>
					<div style="padding:2px 8px 8px;">
					<%
						boolean isFirstAct = true;
						for (DayItinerary dayActivity: dayActivities) { 
					%>
						<div id="itnStp<%=dayActivity.getCityKey()%><%=dayInCity%><%=timeSlot.name()%><%=dayActivity.getPlaceId()%>" style="<%=isFirstAct ? "": "border-top:1px solid #ddd; padding:8px 0 0; margin:8px 0 0;"%>">
							<div class="u_block">
								<h3 class="u_floatL" style="font-size:13px;"><%=dayActivity.getActivityName()%></h3>
								<div class="u_floatR"><a href="#" class="gryBLn" onclick="ITNORGNZ.removePlace('<%=dayActivity.getCityKey()%>', <%=dayInCity%>, <%=dayActivity.getPlaceId()%>, '<%=timeSlot.name()%>'); return false;">remove</a></div>
							</div>
							<div class="u_block actvTxt" style="font-size:12px;">
								<% if (StringUtils.isNotBlank(dayActivity.getPlace().getMainImage())) { %>
									<div class="u_floatL" style="margin:0 10px 10px 0;"><img src="<%=UIHelper.getDestinationImageURLForDataType(request, dayActivity.getPlace().getMainImage(), FileDataType.I150X75)%>" width="150"></div>
								<% } %>
								<%=UIHelper.extractRenderTextFromHTML(dayActivity.getActivityDesc())%>
							</div>
						</div>
					<% isFirstAct = false;} %>
					</div>
				</div>
			<% } %>
		</div>
	<% } %>
	</div>
</div>
<% } else { %>
	<div style="margin:4em 0;">
		<div class="u_alignC noDtBB dkC">
			<p>You haven't added anything to your trip. Start exploring the world!</p>
		</div>
	</div>
<% } %>

<script type="text/javascript">
$jQ(document).ready(function() {
<% if (pkgConfig != null) { %>
	ITNORGNZ.init();
	ITNORGNZ.showItn(<%=pkgConfig.getCityConfigs().get(0).getCityId()%>, 1);
<% } %>
});
var ITNORGNZ = new function() {
	var me = this; this.currentDay = 1; this.currentCId = null;
	this.init = function() {
		$jQ('.itnCty').hover(function() {$jQ(this).find('.bkClose').show();}, function() {$jQ(this).find('.bkClose').hide();});
		$jQ('.itnCty .bkClose').click(function() {
			var cKy = $jQ(this).parent('.itnCty').attr("id").substr(6);
			ITNORGNZ.removeCity(cKy);
			return false;
		});
	}
	this.showItn = function(cId, day) {
		this.currentDay = day; this.currentCId = cId;
		$jQ('.itnTb').removeClass('selItnTb');
		$jQ('#itnTb'+cId+day).addClass('selItnTb');
		$jQ('.cityDayItnVw').hide();
		$jQ('#itnVw'+cId+day).show();
	}
	this.removePlace = function(cKy, day, iId, slt) {
		if (!window.confirm('Are you sure you want to remove this from the trip?')) return;
		var successSaved = function(a, m, x) {
			$jQ('#itnStp'+cKy+day+slt+iId).remove();
		}
		var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy, day:day, id:iId, slt:slt};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_REMOVE)%>', 
			{params: $jQ.param(prms), scope: this, wait: {inDialog:false},
				success: {handler: successSaved}
			});
	}
	this.successLoadTrip = function(a, m, x) {
		var rspO = JS_UTIL.parseJSON($jQ(x).text());
		var curDy = me.currentDay, curCId = me.currentCId;
		$jQ('#tripOrgnzVw').replaceWith(rspO.htm);
		ITNORGNZ.showItn(curCId, curDy);
	}
	this.removeDay = function(cKy, day) {
		if (!window.confirm('Are you sure you want to remove this day from the trip?')) return;
		var successSaved = function(a, m, x) {
			me.successLoadTrip(a, m, x);
			MODAL_PANEL.hide();
		}
		var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy, day:day};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_REMOVE)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved}
			});
	}
	this.removeCity = function(cKy) {
		if (!window.confirm('Are you sure you want to remove this city from the trip?')) return;
		var successSaved = function(a, m, x) {
			me.successLoadTrip(a, m, x);
			MODAL_PANEL.hide();
		}
		var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_REMOVE)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved}
			});
	}
	this.addDay = function(cKy) {
		var successSaved = function(a, m, x) {
			me.successLoadTrip(a, m, x);
			MODAL_PANEL.hide();
		}
		var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_ADD)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved}
			});
	}
	this.loadCityExploreAdd = function(cId, cKy, day) {
		var successLoad = function(a, m, x) {
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			MODAL_PANEL.show('<div>'+rspO.htm+'</div>', {title:null, blockClass:'lgRgBlk2'});

			var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy, day:day};
			EXPCTY.setAddToTripOpts({url:'<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_ADD)%>', prms:prms,
				success:function(a, m, x) {me.successLoadTrip(a, m, x);} });
		}
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PLACES, PlacesAction.ADD_EXPLORE_PLACE)%>', 
			{params: 'askTimeSlot=true&cId='+cId, scope: this, success: {handler: successLoad} });
	}
}
</script>
</div>