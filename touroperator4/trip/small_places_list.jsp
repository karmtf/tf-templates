<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
<%
	List<Destination> placesList = (List<Destination>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
	String viewClass = StringUtils.trimToEmpty(request.getParameter("viewClass"));
	String orientation = StringUtils.trimToEmpty(request.getParameter("orientation"));
	int numPlacesInRow = RequestUtil.getIntegerRequestParameter(request, "numPlacesInRow", 2);
	Map<Long, Review> reviewMap = (Map<Long, Review>) request.getAttribute(Attributes.REVIEWS_WRAPPER.toString());
%>
<% 
	boolean isFirstRow = true;
	boolean isFirstInRow = true;
	int placesCount = 0;
	for (Destination place: placesList) {
	    request.setAttribute(Attributes.DESTINATION.toString(), place);
		if (placesCount % numPlacesInRow == 0) {
		    isFirstInRow = true;
		}
		Review review = null;
		if(reviewMap != null) {
			review = reviewMap.get(place.getId());
		}
		if(orientation.equals("block")) { 
%>
	<jsp:include page="place_block_view.jsp">
		<jsp:param name="viewClass" value="<%=viewClass + (isFirstInRow ? " first": "") + (isFirstRow ? " first-row": "")%>"/>
		<jsp:param name="numReviews" value="<%=(review != null)?review.getTotalReviews():"0"%>"/>
		<jsp:param name="expertReview" value="<%=(review != null)?review.getExpertContent():""%>"/>
	</jsp:include>
<% } else { %>
	<div class="locations clearfix mrgn10T">
		<jsp:include page="place_short_view.jsp">
			<jsp:param name="viewClass" value="<%=viewClass + (isFirstInRow ? " first": "") + (isFirstRow ? " first-row": "")%>"/>
			<jsp:param name="numReviews" value="<%=(review != null)?review.getTotalReviews():"0"%>"/>
			<jsp:param name="expertReview" value="<%=(review != null)?review.getExpertContent():""%>"/>
		</jsp:include>
	</div>
	<% } if (placesCount % numPlacesInRow == (numPlacesInRow - 1)  || placesCount == (placesList.size()-1)) { %><% } %>
<% 
		placesCount++;
		if (placesCount / numPlacesInRow != 0) {
		    isFirstRow = false;
		}
		
		isFirstInRow = false;
	} 
%>
