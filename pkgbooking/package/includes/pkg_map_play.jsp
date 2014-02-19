<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());
%>
<% if (pkgItinerary != null) { %>
<div id="pkgsMapVw" style="width:145px; display:none;">
	<div class="mapCtr posR">
		<div class="mapC"><div class="mapMsg"></div></div>
	</div>
</div>
<jsp:include page="/package/includes/pkg_view_templates.jsp"/>

<script type="text/javascript">
$jQ(document).ready(function() {
	PKGPLAY.init();
});
var PKGPLAY = new function() {
	var me = this; this.pkgV = null;
	this.init = function() {
		me.pkgV = new PkgsView({ctr:'#pkgsMapVw', query:null, spView:true, currency:'', map: {appendHd:true, height:206}});
		me.pkgV.parseResults(<%=PackageConfigManager.getViewJSONForPackageConfig(pkgConfig, true)%>);
		me.pkgV.showResults(true);
		me.pkgV.setPkgPlaySteps(<%=pkgConfig.getId()%>, <%=DayItinerary.getItineraryPlayStepsJSON(pkgItinerary).toString()%>);
	}
	this.play = function() {
		me.pkgV.playPkgTour(); return false;
	}
}
</script>
<% }%>
