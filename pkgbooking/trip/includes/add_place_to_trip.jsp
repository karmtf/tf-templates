<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.trip.AddToTripStepType"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%
	AddToTripStepType stepType = (AddToTripStepType) request.getAttribute(Attributes.STEP_TYPE.toString());

	Integer cityId = (Integer) request.getAttribute(Attributes.CITY_ID.toString());
	String cityName = LocationData.getCityNameFromId(cityId);
	List<Destination> places = (List<Destination>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
	PackageConfigData selectedPkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<div id="addToTripCtr<%=stepType.name()%>">
<form name="addToTripForm" id="addToTripForm" class="def-form">
	<input type="hidden" name="stp" value="<%=stepType.name()%>">
	<% if (places != null && !places.isEmpty()) { %><input type="hidden" name="plcs" value="<%=TripBean.getPlacesSerializeStr(places)%>"><% } %>
	<% if (selectedPkgConfig != null) { %><input type="hidden" name="trpId" value="<%=selectedPkgConfig.getId()%>"><% } %>
	<% switch (stepType) { 
			case SELECT_TRIP: {
			    List<PackageConfigData> pkgConfigs = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
		%>
			<h1>Select the Trip</h1>
			<div>
				<ul class="wzOpts u_block">
					<% for (PackageConfigData pkgConfig: pkgConfigs) { %>
						<li class="wzOpt wzOptWimg" style="width:100px;">
							<a href="#" onclick="ADDPLCTRP.nextStep('trpId=<%=pkgConfig.getId()%>'); return false;">
								<img src="<%=UIHelper.getImageURLForDataType(request, pkgConfig.getImageURL(request), FileDataType.I300X150, true)%>" width="100" height="75"/>
								<span class="u_smallF"><%=pkgConfig.getPackageName()%></span>
							</a>
						</li>
					<% } %>
					<li class="wzOpt wzOptWimg">
						<a href="#" onclick="ADDPLCTRP.nextStep(); return false;">
							<img src="#" width="100" height="75"/>
							<span>Create a New Trip...</span>
						</a>
					</li>
				</ul>
			</div>
		<% 
			}
			break;
			case CREATE_TRIP: {
		%>
			<h1>Give a Name to Your Trip</h1>
			<div>
				<div><input type="text" name="trpName" value=""/></div>
				<div>Number of Days</div>
				<ul class="wzOpts u_block">
					<% for (int i = 1; i < 6; i++) { %>
						<li class="wzOpt wzOptTxtBx"><a href="#" onclick="ADDPLCTRP.nextStep('days=<%=i%>'); return false;" class="u_bigF"><%=i%> Days</a></li>
					<% } %>
				</ul>
			</div>
		<% 
			}
			break;
			case CONFIRM_TRIP: {
			    boolean isCityIncluded = selectedPkgConfig.isCityIncluded(cityId);
		%>
			<h1><%=isCityIncluded ? "Confirm the number of days you will be staying in " + cityName: cityName + " will be added to your trip. Choose the number of days you will be staying."%></h1>
			<div>
				<ul class="wzOpts u_block">
					<% for (int i = 1; i < 6; i++) { %>
						<li class="wzOpt wzOptTxtBx"><a href="#" onclick="ADDPLCTRP.nextStep('days=<%=i%>'); return false;" class="u_bigF"><%=i%> Days</a></li>
					<% } %>
				</ul>
			</div>
		<% 
			}
			break;
			case DONE: {
		%>
			<h1>Your selections have been added to your trip "<%=selectedPkgConfig.getPackageName()%>"</h1>
			<div style="margin:3em;">
				<a href="<%=PackageDataBean.getPackageDetailsURL(request, selectedPkgConfig)%>" target="_blank" class="grBtn1">View Trip Details &raquo;</a>
			</div>
	<% 
			}
			break;
	 	} 
	%>
</form>
<script>
var ADDPLCTRP = new function() {
	this.init = function() {
	}
	this.nextStep = function(prms) {
		var isInPanel = MODAL_PANEL.isInPanel('#addToTripCtr<%=stepType.name()%>');
		var successLoaded = function(a, m, x) {
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			if (isInPanel) {
				MODAL_PANEL.show('<div>'+rspO.htm+'</div>', {title:'Add to Trip', blockClass:'lgRgBlk2'});
			} else {
				$jQ('#addToTripCtr<%=stepType.name()%>').html(rspO.htm);
				MODAL_PANEL.hide();
			}
		}
		AJAX_UTIL.asyncCall('<%=TripBean.getAddToTripURL(request)%>', 
			{params: $jQ('#addToTripForm').serialize()+'&'+prms, scope: this,
				wait: {inDialog: true, msg: 'Please wait...'}, success: {handler: successLoaded}
			});
	}
}
$jQ(document).ready(function() {
	ADDPLCTRP.init();
});
</script>
</div>