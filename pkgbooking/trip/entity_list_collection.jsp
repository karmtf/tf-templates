<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.data.UserBean"%>
<%@page import="com.poc.server.secondary.database.model.UserEntityList"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%
	User publicUser = UserBean.getPublicUser(request, false);
	UserEntityList entityList = (UserEntityList) request.getAttribute(Attributes.USER_ENTITY_LIST.toString());
	List<UserEntityWrapper> entityWrappers = entityList.getEntityWrappers();
%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.user.entity.UserEntityWrapper"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.user.entity.UserEntityBean"%>
<%@page import="com.poc.server.trip.TripBean"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, UIHelper.getUserPossessiveFirstName(publicUser) + " Wish Lists")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<style type="text/css">
#clctLstCtr .ePrdVw {position:relative;}
@media screen and (max-width: 830px) {
.left-sidebar {display:none;}
}
@media screen and (max-width: 768px) {
.left-sidebar {display:none;}
}
@media screen and (max-width: 600px) {
.left-sidebar {display:none;}
.three-fourth {width:100%;}
}
.wpCmtWd1 {width:450px !important;}
.ePrdVw .bkClose {top:0; right:0;}
</style>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">
			<section id="clctLstCtr" class="three-fourth">
				<h3><b><a href="<%=UserEntityBean.getEntityListsURL(request, publicUser)%>"><%=UIHelper.getUserPossessiveFirstName(publicUser)%> Wish Lists</a> - <%=entityList.getListName()%></b></h3>
				<% if (entityWrappers != null && !entityWrappers.isEmpty()) { %>
				<div class="deals">
					<%
						for (UserEntityWrapper entityWrapper: entityWrappers) {
					%>
						<% 
							switch (entityWrapper.getProductType()) { 
							case HOTEL: {
							    MarketPlaceHotel hotel = entityWrapper.getHotel();
							    request.setAttribute(Attributes.MP_HOTEL.toString(), hotel);
						%>
							<div class="ePrdVw deals clearfix" data-eid="<%=entityWrapper.getUserEntityAssociation().getProductId()%>", data-etyp="<%=entityWrapper.getProductType().name()%>" id="ePrdVw<%=entityWrapper.getUserEntityAssociation().getProductId() + entityWrapper.getProductType().name()%>">
								<jsp:include page="/hotel/includes/hotel_short_view.jsp"/>
							</div>
						<%
							break;
							}
							case DESTINATION: {
							    Destination destination = entityWrapper.getDestination();
							    request.setAttribute(Attributes.DESTINATION.toString(), destination);
						%>
							<div class="ePrdVw locations clearfix" data-eid="<%=entityWrapper.getUserEntityAssociation().getProductId()%>", data-etyp="<%=entityWrapper.getProductType().name()%>" id="ePrdVw<%=entityWrapper.getUserEntityAssociation().getProductId() + entityWrapper.getProductType().name()%>">
								<jsp:include page="/place/includes/place_short_view.jsp"/>
							</div>
						<%
							break;
							}
							case HOLIDAY: {
							    PackageConfigData pkgConfig = entityWrapper.getPkgConfig();
							    request.setAttribute(Attributes.PACKAGE.toString(), pkgConfig);
						%>
							<div class="ePrdVw deals clearfix" data-eid="<%=entityWrapper.getUserEntityAssociation().getProductId()%>", data-etyp="<%=entityWrapper.getProductType().name()%>" id="ePrdVw<%=entityWrapper.getUserEntityAssociation().getProductId() + entityWrapper.getProductType().name()%>">
								<jsp:include page="/package/includes/package_short_view.jsp"/>
							</div>
						<%
							break;
							}
							} 
						%>
					<% } %>
				</div>
				<% } else { %>
				<div style="margin:4em 0;">
					<div class="u_alignC noDtBB dkC">
						<p>You haven't added anything to this wishlist yet</p>
					</div>
				</div>
				<% } %>
			</section>
		</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("#clctLstCtr .ePrdVw").hover(function() {
			var eId = $jQ(this).data("eid"), eTyp = $jQ(this).data("etyp");
			$jQ(this).append($jQ('<div class="bkClose">').click(function() {if(!window.confirm('Are you sure you want to remove it from your wishlist?')) return false; removeEntity(eId, eTyp); return false;}));
		}, function() {
			$jQ(this).find('.bkClose').remove();
		});
});
function removeEntity(eId, eTyp) {
	var successRemove = function(a, m, x) {
		$jQ('#ePrdVw'+eId+eTyp).remove();
		MODAL_PANEL.hide();
	}
	AJAX_UTIL.asyncCall('<%=TripBean.getRemoveEntityFromTripURL(request)%>', 
		{params: 'productType='+eTyp+'&productId='+eId, scope: this,
			wait: {}, success: {handler: successRemove}
		});
}
</script>
</body>
</html>