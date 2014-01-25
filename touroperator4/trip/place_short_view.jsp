<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.content.DestinationLocation"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>

<%
	User user = SessionManager.getUser(request);
	Destination place = (Destination) request.getAttribute(Attributes.DESTINATION.toString());
	DestinationLocation location = (DestinationLocation) request.getAttribute(Attributes.DESTINATION_LOCATION.toString());
	Destination city = DestinationContentManager.getDestinationCityByCityId(place.getMappedCityId());
	String viewClass = StringUtils.trimToEmpty(request.getParameter("viewClass"));
	boolean showCityName = Boolean.parseBoolean(request.getParameter("showCityName"));
	String expertText = StringUtils.trimToEmpty(request.getParameter("expertReview"));

	boolean isHidePlace = Boolean.parseBoolean(request.getParameter("isHidePlace"));
	boolean showCollect = Boolean.parseBoolean(request.getParameter("showCollect")) && place.getDestinationType().isCollectable();
	showCollect = UIHelper.isShowCollect(request, showCollect);

	DestinationMatchParam destinationMatchParam = place.getSearchMatchParams();

	boolean showImportantTags = Boolean.parseBoolean(request.getParameter("showImportantTags"));
	boolean showURLAsSearchFilter = Boolean.parseBoolean(request.getParameter("showURLAsSearchFilter"));
	List<PackageTag> importantTags = ReviewManager.getImportantTags(place.getOverallRatingMap());	
	List<DestinationCuisineType> cuisines = ReviewManager.getImportantCuisines(place.getOverallRatingMap());
	
	Review recentReview = null; 
    UserInputType inputType = UserInputType.HOLIDAY_PURPOSE;
	if(place.getDestinationType() == DestinationType.RESTAURANT) {
		inputType = UserInputType.CUISINE;
	}
	if(place.getOverallRatingMap() != null && place.getOverallRatingMap().get(inputType) != null) {
		Collection<Review> applicableReviews = place.getOverallRatingMap().get(inputType).values();
		for (Review review : applicableReviews) {
			if(StringUtils.isNotBlank(review.getExpertContent())) {
				recentReview = review;
				break;
			}
		}
	}
	AbstractConfigStep currentConfigStep = (AbstractConfigStep) request.getAttribute(Attributes.CURRENT_CONFIG_STEP.toString());
	boolean isPlaceSelected = false;	
	boolean isConfig = false;
	if(currentConfigStep != null && currentConfigStep instanceof DestinationConfigStep) { 
		DestinationConfigStep destConfigStep = (DestinationConfigStep) currentConfigStep;
		isConfig = (destConfigStep != null);
		isPlaceSelected = isConfig && destConfigStep.isPlaceSelected(place);
	}
	
	String destinationURL = showURLAsSearchFilter? DestinationContentBean.getDestinationCitySearchURLAsFilter(request, place): DestinationContentBean.getDestinationContentURL(request, place);
	String descriptionText = UIHelper.extractRenderTextFromHTML(StringUtils.trimToEmpty(place.getDescription()));
	String imageURL = UIHelper.getDestinationImageURLForDataType(request, place.getMainImage(), FileDataType.I200X100);
%>

<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collection"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.poc.server.review.ReviewManager"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.content.search.DestinationMatchParam"%>
<%@page import="com.eos.b2c.content.search.DestinationMatchDescType"%>
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.config.step.AbstractConfigStep"%>
<%@page import="com.poc.server.config.step.DestinationConfigStep"%>
	<!-- Results -->
	<ul >
	
                <div>
                  <a href="<%=destinationURL%>"><img src="<%=UIHelper.getDestinationImageURLForDataType(request, place.getMainImage(), FileDataType.I200X100)%>" style="height:150px;width:200px" alt="" class="span4" ></a>
                  <div class="span8">
                    <span ><a href="<%=destinationURL%>"><%=com.eos.gds.util.StringUtility.toCamelCase(DestinationContentManager.getDisplayNameForPlace(place))%></a></span>
                    		<p><%=UIHelper.cutLargeText(place.getAddress(),70)%></p>
		<% if(StringUtils.isNotBlank(expertText)) { %>
		<font style="font-weight:bold">Expert Tip:</font>"<%=StringUtility.truncateAtWord(expertText, 150, true).replaceAll("\\?","")%>"<br>
		<% } else { %>
		
			<%=StringUtility.truncateAtWord(descriptionText, 150, true)%>
		
		<% } %>    </div>
                  <div class="clear"></div>
                </div>
	</ul>
</article>
