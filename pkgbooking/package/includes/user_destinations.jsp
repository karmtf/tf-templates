<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.secondary.database.model.UserDestinationAssociation"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%
	List<UserDestinationAssociation> userAssociationsList = (List<UserDestinationAssociation>) request.getAttribute(Attributes.USER_DEST_ASSOCIATIONS.toString());
	Integer cityId = (Integer) request.getAttribute(Attributes.CITY_ID.toString());
	Destination destinationCity = (cityId != null) ? DestinationContentManager.getDestinationFromCityId(cityId): null;
%>
<% if (userAssociationsList != null && !userAssociationsList.isEmpty()) { %>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<div id="usrDPLst">
	<% 
		for (UserDestinationAssociation userDestAssociation: userAssociationsList) { 
		    Destination destination = userDestAssociation.getDestination();
		    if (destination == null) {
		        continue;
		    }
		    
		    request.setAttribute(Attributes.DESTINATION.toString(), destination);
	%>
		<div id="usrDP<%=userDestAssociation.getId()%>" class="boxPad10 hrDotB posR">
			<jsp:include page="destination_short_view.jsp"/>
			<div class="usrDPAct itmActCtr rnd2Bdr" style="position:absolute; bottom:20px; right: 10px; display:none;"><div><a href="#" onclick="USRDSTPKG.remove(<%=userDestAssociation.getId()%>, <%=userDestAssociation.getDestinationId()%>); return false;" class="bnLnIcon bnSmDel">Remove</a></div></div>
		</div>
	<% } %>
</div>
<script>
$jQ(document).ready(function() {
	USRDSTPKG.init();
});
var USRDSTPKG = new function () {
	this.init = function() {
		$jQ("#usrDPLst .posR").hover(function() {
				$jQ(".usrDPAct", this).show();
			}, function() {
				$jQ(".usrDPAct", this).hide();
			});
	}
	this.remove = function(udId, dId) {
		var successRemove = function() {
			$jQ("#usrDP"+udId).remove();
		}
		AJAX_UTIL.asyncCall('/viacard', 
			{params: 'action1=RMVPLCTRIP&apPkgCfg='+udId+'&dst='+dId, scope: this, error: {}, wait:{inDialog: false, msg:'&nbsp;', divEl: $jQ('#usrDP'+udId+' .usrDPAct div')},  success: {handler:successRemove}});
	}
}
</script>
<% } else if (destinationCity != null) { %>
	<div style="margin:3em 0;">
		<div class="u_alignC noDtBB dkC">
			<p><a href="<%=DestinationContentBean.getDestinationContentURL(request, destinationCity)%>" class="b2c_buttonImgSrch b2cButtonIS1">Explore <%=destinationCity.getName()%></a></p>
		</div>
	</div>
<% } %>