<%@page import="com.poc.server.user.entity.UserEntityWrapper"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%
	List<UserEntityWrapper> entityWrappers = (List<UserEntityWrapper>) request.getAttribute(Attributes.USER_ENTITY_WRAPPERS.toString());
%>
<% if (entityWrappers != null && !entityWrappers.isEmpty()) { %>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<div style="margin-top:20px;">
	<h2 class="hd21">My Trip Ideas</h2>
	<%
		for (UserEntityWrapper entityWrapper: entityWrappers) {
		    switch (entityWrapper.getUserEntityAssociation().getProductType()) {
		    case DESTINATION:
		        Destination destination = entityWrapper.getDestination();
		    	Destination cityDestination = DestinationContentManager.getDestinationCityByCityId(destination.getMappedCityId());
		    	String destinationURL = DestinationContentBean.getDestinationContentURL(request, destination);
	%>
			<div class="cntTbV u_block">
				<div class="imgBlk"><a href="<%=destinationURL%>"><img src="<%=UIHelper.getDestinationImageURLForDataType(request, destination.getMainImage(), FileDataType.I200X100)%>" style="width:100px; height:70px;"></a></div>
				<div class="summBlk">
					<h3 class="ttl"><a href="<%=destinationURL%>" title="<%=destination.getName()%>"><%=UIHelper.cutLargeText(destination.getName(), 25)%></a></h3>
					<div class="summ"><%=destination.getDestinationType().getSingularTitle()%><% if (cityDestination != null && !destination.getDestinationType().isRegionOrCityType()) { %> in <%=cityDestination.getName()%><% } %></div>
				</div>
			</div>
		<%
			break;
		    case HOTEL:
			    request.setAttribute(Attributes.MP_HOTEL.toString(), entityWrapper.getHotel());
		%>
			<jsp:include page="/hotel/includes/hotel_thumb_view.jsp"/>
		<%
			break;
		    case HOLIDAY:
		%>
		<% 
			break;
			} 
		%>
	<% } %>
</div>
<% } %>