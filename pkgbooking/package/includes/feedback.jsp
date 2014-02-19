<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.poc.server.model.PackagePaxData"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.PaxRoomInfo"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.user.destination.UserDestinationListType"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.holiday.data.StarCategory"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="java.util.List"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	List<Integer> destinationCities = null;
	if(pkgConfig != null)  {
 	   destinationCities = pkgConfig.getDestinationCities();
	}
	long id = RequestUtil.getLongRequestParameter(request,"id",-1L);
	String type  = RequestUtil.getStringRequestParameter(request,"type","");
%>
<style type="text/css">
.lgnRgBlk{width:700px} 
.booking .triplets .f-item {width:20%}
.booking .penta .f-item {width:18%}
.u_invisible{display:none;}
.booking h3 {text-indent:0px;padding:10px 0px 5px 10px;}
.booking .f-item {padding:6px 2% 6px 0;}
</style>
<form name="feedback" id="feedback" class="booking wideL" style="box-shadow:none;-webkit-box-shadow:none;background:none;padding:10px 0;margin-bottom:0">
<input type="hidden" name="id" value="<%=id%>" />
<input type="hidden" name="type" value="<%=type%>" />
<fieldset>
	<div class="row row5">
		<% if(type.equals(DestinationType.RESTAURANT.name())) {	%>
		<div class="row penta u_block">
			<div class="f-item">
				<label class="dCityNm u_floatL">Good For</label>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.VEGETARIAN.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.VEGETARIAN.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.FAST_FOOD.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" name="<%=DestinationCuisineType.FAST_FOOD.name()%>" value="on" />
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.CHINESE.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.CHINESE.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.INDIAN.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.INDIAN.name()%>"/>
			</div>
		</div>
		<div class="row penta u_block">
			<div class="f-item">
				<label class="dCityNm u_floatL">&nbsp;</label>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.THAI.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.THAI.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.JAPANESE.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.JAPANESE.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.ASIAN.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.ASIAN.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.EUROPEAN.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.EUROPEAN.name()%>"/>
			</div>
		</div>
		<div class="row penta u_block">		
			<div class="f-item">
				<label class="dCityNm u_floatL">&nbsp;</label>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.CONTINENTAL.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.CONTINENTAL.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.LEBANESE.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.LEBANESE.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.MEXICAN.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.MEXICAN.name()%>"/>
			</div>
			<div class="f-item">
				<label><%=DestinationCuisineType.VIETNAMESE.getDisplayName()%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" class="checkbox" value="on" name="<%=DestinationCuisineType.VIETNAMESE.name()%>"/>
			</div>
		</div>
		<% } else if(!type.equals("itinerary")) { %>
		<div class="row penta u_block">
			<div class="f-item">
				<label class="dCityNm u_floatL">Traveled as</label>
			</div>
			<% for (TravelerType travelerType: TravelerType.getTopLevelTravelerTypes()) { %>
				<div class="f-item">
					<label><%=travelerType.getAlternateDisplayName()%></label>
					<span class="u_floatL dCityLd"><input type="radio" class="checkbox" name="ttype" value="<%=travelerType.name()%>"/>
				</div>
			<% } %>
		</div>
		<div class="row penta u_block">
			<div class="f-item">
				<label class="dCityNm u_floatL">Traveled for</label>
			</div>
			<% for (HolidayPurposeType purposeType: HolidayPurposeType.getTopLevelPurposeTypes()) { %>
				<div class="f-item">
					<label><%=purposeType.getDisplayName()%></label>
					<span class="u_floatL dCityLd"><input type="radio" class="checkbox" name="hpur" value="<%=purposeType.name()%>"/>
				</div>
			<% } %>
		</div>
		<div class="row penta u_block">
			<div class="f-item">
				<label class="dCityNm u_floatL">Your Experience</label>
			</div>
			<div class="f-item">
				<label>Not Good</label>
				<span class="u_floatL dCityLd"><input type="radio" class="checkbox" name="exp" value="1"/>
			</div>
			<div class="f-item">
				<label>Average</label>
				<span class="u_floatL dCityLd"><input type="radio" class="checkbox" name="exp" value="2"/>
			</div>
			<div class="f-item">
				<label>Good</label>
				<span class="u_floatL dCityLd"><input type="radio" class="checkbox" name="exp" value="3"/>
			</div>
			<div class="f-item">
				<label>Excellent</label>
				<span class="u_floatL dCityLd"><input type="radio" class="checkbox" name="exp" value="4"/>
			</div>
		</div>
		<% } %>
		<% if(destinationCities != null && type.equals("itinerary")) {
		%>
		<div class="row penta u_block">
			<div class="f-item">
				<label class="dCityNm u_floatL">Been to</label>
			</div>
			<% for(Integer city : destinationCities) { %>
			<div class="f-item">
				<label><%=LocationData.getCityNameFromId(city)%></label>
				<span class="u_floatL dCityLd"><input type="checkbox" onclick="$jQ('#<%=city%>miss').slideToggle('slow')" class="checkbox" name="<%=city%>been" value="yes" />			
			</div>
			<% } %>
		</div>
		<% for(Integer city : destinationCities) { %>
		<div class="row row1 hide" id="<%=city%>miss" style="display:none">
			<div class="f-item" style="width:98%">
				<label for="first_name">Don't miss in <%=LocationData.getCityNameFromId(city)%></label>
				<textarea type="text" rows=5 cols=80 name="<%=city%>desc" style="height:50px"></textarea>
			</div>
		</div>
		<% } } else { %>
		<div class="row row1">
			<div class="f-item" style="width:98%">
				<label for="first_name">What is the one thing you should not miss at this place?</label>
				<textarea type="text" rows=5 cols=80 name="feedback"></textarea>
			</div>
		</div>
		<% } %>
	</div>
	<h2 id="status"></h2>
	<div class="row row5 btnPos right">
		<a href="#" id="submitBtn" class="search-button" onclick="TRPREQ.savePR(); return false;">Continue &raquo;</a>
	</div>
</fieldset>
</form>
<script type="text/javascript">
$jQ("#submitBtn").click(function () {
	var successLoadDt = function(a, m) {
		MODAL_PANEL.hide();
		$jQ('#status').html(m);
	}
	AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.CONTRIBUTE)%>', 
		{params:$jQ('#feedback').serialize(), scope:this, success: {parseMsg:true, handler: successLoadDt}});
	return false;		
 });
</script> 