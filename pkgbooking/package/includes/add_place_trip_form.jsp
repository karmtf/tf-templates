<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageConfiguration"%>
<%@page import="java.util.List"%>
<%
	List<PackageConfiguration> pkgConfigs = (List<PackageConfiguration>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	List<ValidPackageItinerary> validPkgItineraries = (List<ValidPackageItinerary>) request.getAttribute(Attributes.PACKAGE_VALID_ITINERARIES.toString());
%>
<%@page import="com.eos.b2c.holiday.data.ValidPackageItinerary"%>
<div>
	<form name="apPkgForm" id="apPkgForm" class="boldL rightL">
		<input type="hidden" name="action1" value="ADDPLCTRIP">
		<input type="hidden" name="dst" value="<%=request.getParameter("dst")%>">
		<% if (!pkgConfigs.isEmpty()) { %>
			<div style="overflow-y:auto; max-height:160px; border:1px solid #ddd;">
			<% 
				for (PackageConfiguration pkgConfig: pkgConfigs) { 
			%>
				<label for="apPkgCfg<%=pkgConfig.getId()%>" class="pkgOptCtr u_clear" style="padding:5px; display:block;">
					<div class="u_floatL"><input type="radio" name="apPkgCfg" value="<%=pkgConfig.getId()%>" id="apPkgCfg<%=pkgConfig.getId()%>"></div>
					<div style="margin-left:20px;">
						<h3 style="margin:0 0 5px;"><%=pkgConfig.getPackageName()%></h3>
					</div>
				</label>
			<% } %>
			</div>
		<% } %>
		<div style="margin-top:5px;">
			<label for="apPkgCfgNew" class="pkgOptCtr u_block" style="padding:5px; display:block;">
				<div class="u_floatL"><input type="radio" name="apPkgCfg" value="-1" id="apPkgCfgNew"></div>
				<div style="margin-left:20px;">
					<h3 style="margin:0 0 5px;"><em>Create a new trip</em></h3>
					<div id="apPkgCfgNFm" class="def-form" style="display:none;">
						<fieldset>
							<dl>
								<dt><label>Your Trip Name:</label></dt>
								<dd><input type="text" name="pkgName"></dd>
								<dt><label>Itinerary:</label></dt>
								<dd><select name="itinerary"><% for (ValidPackageItinerary pkgItinerary: validPkgItineraries) { %><option value="<%=pkgItinerary.getItineraryStr()%>"><%=pkgItinerary.getItineraryStr()%></option><% } %></select></dd>
							</dl>
						</fieldset>
					</div>
				</div>
			</label>
		</div>
	</form>
	<div class="mrgnT u_block"><div class="u_floatR"><a href="#" onclick="return PLCTRIPF.addToTrip();" class="grBtn1">Continue &raquo;</a></div></div>
</div>
<script>
$jQ(document).ready(function() {
	$jQ("#apPkgForm .pkgOptCtr").hover(function() {$jQ(this).addClass('lghtGBg');}, function() {$jQ(this).removeClass('lghtGBg');});
	$jQ("#apPkgForm input[name='apPkgCfg']").change(function() {
		if ($jQ("#apPkgForm input[name='apPkgCfg']:checked").val() == '-1') {
			$jQ("#apPkgCfgNFm").show();
		} else {
			$jQ("#apPkgCfgNFm").hide();
		}
	}).filter(':first').attr("checked", "checked").change();
});
var PLCTRIPF = new function () {
	this.addToTrip = function() {
		AJAX_UTIL.asyncCall('/viacard', 
			{form: 'apPkgForm', scope: this,
				wait: {inDialog: true, msg: 'Please wait...'}, success: {parseMsg:true, inDialog:true}
			});
		return false;
	}
}
</script>