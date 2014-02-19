<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%
	AmbiguousSearchResult ambiguousSearchResult = (AmbiguousSearchResult) request.getAttribute(Attributes.AMBIGUOUS_SEARCH_RESULT.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (ambiguousSearchResult != null) ? ambiguousSearchResult.getSearchResults(): null;

	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);

	UserInputState inputState = searchQuery.getUserInputState(false);
	boolean debug = SessionManager.isDebugEnabled(request);
	boolean crossSellOrGetMoreInfoAvailable = ECFEngine.isCrossSellAvailable(request) || ECFEngine.isGetMoreInfoAvailable(request);
	Set<Integer> toCities = searchQuery.getQueryParams().getTo();
%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.PackageGroupResultItem"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.data.AmbiguousSearchResult"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileManager"%>
<%@page import="com.via.search.data.SearchResult"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.poc.server.search.data.TripSearchComponentType"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.holiday.data.ItineraryResultItem"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.poc.server.review.ReviewManager"%>
<%@page import="com.via.search.data.FilterType"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, queryStr + " - Results")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<jsp:include page="includes/search_tabs.jsp"/>
<style type="text/css">
.three-fourth {width:70%;}
.right-section {width:28%;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:10px;width:28% !important;min-height:288px;margin-right:10px !important;margin-bottom:10px !important}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;display:none;}
.right-section {width:100%;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;display:none}
.right-section {width:100%;}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;display:none}
.right-section {width:100%;}
}
.mtchRtC{margin-right:10px;}
.sideHeading {color:#333;}
</style>
<!--main-->
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<%
			if (ambiguousSearchResult != null) {
		%>
		<!--three-fourth content-->
		<section id="mainContentDiv" class="three-fourth fnScrll">
			<jsp:include page="/search/includes/search_top_extended.jsp"/>
			<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
				<p class="spSuggest u_smallF">
					<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=SellableContentSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
				</p>
			<% } %>
			<jsp:include page="includes/conflict_resolution.jsp"/>
			<jsp:include page="/search/includes/search_blocks.jsp"/>
			<% if (toCities != null && !toCities.isEmpty()) { %>			
			<div id="organize" class="mrgnB" style="display:none">
				<a href="/trip/new-trip?ci=<%=ListUtility.toString(toCities,",")%>" class="organize-link search-button" style="height:26px;font-weight:bold">Create Your Trip</a>
				<div class="clearfix"></div>
			</div>
			<% } else { %>
			<div id="organize" class="mrgnB" style="display:none">
				<a href="/trip/new-trip" class="organize-link search-button" style="height:26px;font-weight:bold">Create Your Trip</a>
				<div class="clearfix"></div>
			</div>
			<% } %>			
			<% if (!ambiguousSearchResult.getItnPkgGroupList().isEmpty()) { %>
				<div id="itnGrpRsltCtr" class="mrgnB deals" style="display:none;">
					<h2 class="sideHeading">Popular Ways to Spend Time</h2>
					<div class="clearfix"></div>
					<div class="deals clearfix" style="margin-top:5px">
					<% 
						int count = 0;
						for (PackageGroupResultItem itnPkgGroup: ambiguousSearchResult.getItnPkgGroupList()) { 
						    ItineraryResultItem itnResultItem = itnPkgGroup.getItineraryResultItem();
						    List<Destination> itnCityDestinations = itnResultItem.getMostPopularItinerary().getCityDestinations();
						    List<PackageTag> popularTags = itnPkgGroup.getPopularTags();
						    String resultURL = SellableContentSearchQuery.getContentGroupSearchURL(request, searchQuery, itnPkgGroup);
					%>
						<div class="result-outer itnGrpRslt" style="<%=(count >= 3) ? "display:none;": ""%>">
							<article class="full-width" style="padding:10px 0 10px 10px;">
								<div class="details" style="width:100%">
									<h1>
										<a href="<%=resultURL%>">
										<% 
											int cityCount = 0;
											for (Destination itnCityDest: itnCityDestinations) { 
										%>
											<span><%=itnCityDest.getName()%></span><% if (cityCount < (itnCityDestinations.size() - 1)) { %>&nbsp;&rarr;&nbsp;<% } %>
										<% cityCount++; } %>
										</a>
									</h1>
									<div class="clearfix"></div>
									<div class="description">
										<p>Duration: <%=itnPkgGroup.getMinNight()%>N<% if (itnPkgGroup.getMinNight() != itnPkgGroup.getMaxNight()) { %> - <%=itnPkgGroup.getMaxNight()%>N<% } %></p>
										<% if (!popularTags.isEmpty()) { %>
											<p style="color:#F78C0D;"><b>Recommended for: </b><%=ListUtility.toString(PackageTag.getPackageTagsDisplayNames(popularTags), ", ")%></p>
										<% } %>
									</div>
								</div>
							</article>
							<div class="clearfix"></div>
						</div>
					<% count++; } %>
					</div>
					<% if (count > 3) { %>
						<div class="itnGrpMore mrgnT u_alignC u_normalF"><a href="#" onclick="$jQ('#itnGrpRsltCtr .itnGrpRslt').show(); $jQ('#itnGrpRsltCtr .itnGrpMore').hide(); return false;" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div>
					<% } %>
				</div>
			<% } %>
			<% if (toCities != null && !toCities.isEmpty()) { 
					List<Destination> cityDest = new ArrayList<Destination>();
					for(Integer cityId : toCities) {
						cityDest.add(DestinationContentManager.getDestinationFromCityId(cityId));
					}
			%>
				<div id="topCtsCtr" class="mrgnB">
					<% request.setAttribute(Attributes.DESTINATION_LIST.toString(), cityDest); %>
					<div class="locations clearfix" style="margin-top:5px">
						<jsp:include page="/place/includes/places_list.jsp">
							<jsp:param name="showCityName" value="true"/>
							<jsp:param name="showShortView" value="true"/>
							<jsp:param name="showCollect" value="true"/>
							<jsp:param name="showImportantTags" value="true"/>
							<jsp:param name="maxPlacesToShow" value="3"/>
						</jsp:include>
					</div>
				</div>
			<% } %>
			<%
				for (Object resultTypeObj: ambiguousSearchResult.getResultsDisplayOrder()) {
				    if (resultTypeObj instanceof TripSearchComponentType) {
				        TripSearchComponentType searchComponentType = (TripSearchComponentType) resultTypeObj;
					    List<?> productResults = ambiguousSearchResult.getProductResultsBySearchComponent(searchComponentType);
					    if (productResults == null || productResults.isEmpty()) {
					        continue;
					    }

					    ViaProductType productType = searchComponentType.getProductType();
					    searchQuery.setUseUserContext(false);
					    String viewMoreURL = searchQuery.getContentSearchURL(request, null, productType, SellableContentSearchViewType.NONE, false, searchComponentType.getFilterApplied());
			%>
					<%
						String heading = "";
						List<KnowledgeRelationship> krsExecuted = ambiguousSearchResult.getPlaceKRsExecuted(searchComponentType);
						if (!krsExecuted.isEmpty()){
							heading = KnowledgeRelationship.createHeading(ViaProductType.DESTINATION, krsExecuted.get(0)); 
							if (debug) {
					%>	
					<!-- KRs Executed : <%=krsExecuted%> -->					
					<!-- Main KR Executed : <%=krsExecuted.get(0).getLhsState()%> -->
					<!-- Main KR Heading : <%=heading%> -->					
					<%
							}
						}
					%>			
					<div class="mrgnB <%=(productType != ViaProductType.DESTINATION) ? "deals": ""%>">
						<h2 class="sideHeading"><% if (StringUtils.isNotBlank(heading)) { %><%=heading%><% } else { %>Popular <%=searchComponentType.getDisplayText()%><% } %></h2>
						<div class="clearfix"></div>
						<%
							switch (productType) {
							case DESTINATION:
							    request.setAttribute(Attributes.DESTINATION_LIST.toString(), productResults);
						%>
								<div class="locations clearfix">
									<jsp:include page="/place/includes/places_list.jsp">
										<jsp:param name="showCityName" value="true"/>
										<jsp:param name="showShortView" value="true"/>
										<jsp:param name="showCollect" value="true"/>
									</jsp:include>
								</div>
						<%
							break;
							case HOTEL:
								request.setAttribute(Attributes.PRICED_HOTEL_SEARCH_RESULTS.toString(), productResults);
						%>
								<jsp:include page="/hotel/includes/hotel_results_js.jsp"/>
								<div class="deals clearfix">
									<jsp:include page="/package/includes/hotel_results.jsp">
										<jsp:param name="showCollect" value="true"/>
									</jsp:include>
								</div>
						<%
							break;
							case SIGHTSEEING_TOUR:
								request.setAttribute(Attributes.SUPPLIER_PACKAGES.toString(), productResults);
						%>
								<div class="deals clearfix">
									<jsp:include page="/activity/includes/activity_results.jsp"/>
								</div>
						<%
							break;
							case HOLIDAY:
								request.setAttribute(Attributes.PACKAGE_LIST.toString(), productResults);
						%>
								<div class="deals clearfix" style="margin-top:5px">
									<jsp:include page="/package/includes/package_results.jsp"/>
								</div>
						<% 
							break;
							} 
						%>
						<div class="mrgnT u_alignC u_normalF"><a href="<%=viewMoreURL%>" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div>
					</div>
				<%
				    } else if (resultTypeObj instanceof DestinationType) {
				        DestinationType destinationType = (DestinationType) resultTypeObj;
				        if (destinationType == DestinationType.CITY && !ambiguousSearchResult.getTopCities().isEmpty()) {
				%>
						<%
							List<KnowledgeRelationship> krsExecuted = ambiguousSearchResult.getKrsExecuted();
							String heading = "";
							if (!krsExecuted.isEmpty()){
								heading = KnowledgeRelationship.createHeading(ViaProductType.HOLIDAY, krsExecuted.get(0)); 
								if (debug) {
						%>	
						<!-- KRs Executed : <%=krsExecuted%> -->					
						<!-- Main KR Executed : <%=krsExecuted.get(0).getLhsState()%> -->
						<!-- Main KR Heading : <%=heading%> -->					
						<%
								}
							}
						%>			
						<div id="topCtsCtr" class="mrgnB">
							<h2 class="sideHeading"><% if (StringUtils.isNotBlank(heading)) { %><%=heading%><% } else { %>Popular Cities<% } %></h2>
							<div class="clearfix"></div>
							<% request.setAttribute(Attributes.DESTINATION_LIST.toString(), ambiguousSearchResult.getTopCities()); %>
							<div class="locations clearfix" style="margin-top:5px">
								<jsp:include page="/place/includes/places_list.jsp">
									<jsp:param name="showCityName" value="true"/>
									<jsp:param name="showShortView" value="true"/>
									<jsp:param name="showCollect" value="true"/>
									<jsp:param name="showImportantTags" value="true"/>
									<jsp:param name="maxPlacesToShow" value="3"/>
								</jsp:include>
							</div>
							<% if (ambiguousSearchResult.getTopCities().size() > 3) { %>
								<div class="topCtsMore mrgnT u_alignC u_normalF"><a href="#" onclick="$jQ('#topCtsCtr article').show(); $jQ('#topCtsCtr .topCtsMore').hide(); return false;" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div>
							<% } %>
						</div>
					<%
				        } else if (destinationType == DestinationType.COUNTRY && !ambiguousSearchResult.getTopCountries().isEmpty()) {
					%>
						<div id="cntyGrpRsltCtr" class="mrgnB">
							<h2 class="sideHeading">Top Countries</h2>
							<div class="clearfix"></div>
							<div class="locations" style="margin-top:5px">
							<% 
								for (Destination countryDest: ambiguousSearchResult.getTopCountries()) { 
								    String resultURL = searchQuery.getContentSearchURL(request, countryDest.getName() + " " + queryStr, null, null, null, false);
									String destinationURL = DestinationContentBean.getDestinationContentURL(request, countryDest);
									String descriptionText = UIHelper.extractRenderTextFromHTML(StringUtils.trimToEmpty(countryDest.getDescription()));							
							%>
								<article class="full-width" style="padding:0 0 10px 0">
									<figure>
										<a href="<%=resultURL%>"><img class="shot" src="<%=UIHelper.getImageURLForDataType(request, countryDest.getMainImage(), FileDataType.I300X150, true)%>" style="height:130px;width:100%;border:1px solid rgba(0,0,0,.2);border-radius:3px"/></a>
									</figure>
									<div class="details" style="padding-top:0">
										<h2 style="padding-bottom:2px;margin-bottom:2px;text-align:left">
											<a href="<%=resultURL%>" class="title" title="<%=countryDest.getName()%>"><%=countryDest.getName()%></a>
										</h2>
										<div class="clearfix"></div>
										<% if (StringUtils.isNotBlank(descriptionText)) { %>
											<div class="description" style="width:82%">
												<p><%=StringUtility.truncateAtWord(descriptionText, 150, true).replaceAll("\\?","")%></p>
											</div>
										<% } %>
										<div class="clearfix"></div>
										<div style="margin-top:5px;font-size:13px;">
											<a href="<%=resultURL%>">Holiday Experiences &raquo;</a>&nbsp;
										</div>								
									</div>
								</article>
							<% } %>
							</div>
						</div>
					<%
				        } else {
				            List<Destination> placeResults = ambiguousSearchResult.getResultsByPlaceType(destinationType);
				            if (placeResults == null || placeResults.isEmpty()) {
				                continue;
				            }
						    String viewMoreURL = searchQuery.getContentSearchURL(request, null, ViaProductType.DESTINATION, SellableContentSearchViewType.NONE, false, FilterType.createFilterAppliedForDestinationType(destinationType));
						    request.setAttribute(Attributes.DESTINATION_LIST.toString(), placeResults);
					%>
						<%
							String heading = "";
							List<KnowledgeRelationship> krsExecuted = ambiguousSearchResult.getPlaceTypeKRsExecuted(destinationType);
							if (!krsExecuted.isEmpty()){
								heading = KnowledgeRelationship.createHeading(ViaProductType.DESTINATION, krsExecuted.get(0)); 
								if (debug) {
						%>	
						<!-- KRs Executed : <%=krsExecuted%> -->					
						<!-- Main KR Executed : <%=krsExecuted.get(0).getLhsState()%> -->
						<!-- Main KR Heading : <%=heading%> -->					
						<%
								}
							}
						%>			
						<div class="mrgnB">
							<h2 class="sideHeading"><% if (StringUtils.isNotBlank(heading)) { %><%=heading%><% } else { %>Popular <%=destinationType.getTitle()%><% } %></h2>
							<div class="clearfix"></div>
							<div class="locations clearfix">
								<jsp:include page="/place/includes/places_list.jsp">
									<jsp:param name="showCityName" value="true"/>
									<jsp:param name="showShortView" value="true"/>
									<jsp:param name="showCollect" value="true"/>
								</jsp:include>
							</div>
							<div class="mrgnT u_alignC u_normalF"><a href="<%=viewMoreURL%>" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div>
						</div>
					<% } %>
				<% } %>
			<% } %>
			<% if (!ambiguousSearchResult.getCityPkgGroupList().isEmpty()) { %>
				<%
					List<Destination> topCities = new ArrayList<Destination>();
					for (PackageGroupResultItem cityPkgGroup: ambiguousSearchResult.getCityPkgGroupList()) {
						Destination destCity = cityPkgGroup.getDestination();
						if(destCity != null){
							topCities.add(destCity);
						}
					}									
					request.setAttribute(Attributes.DESTINATION_LIST.toString(), topCities);
				%>
				<div id="topCtsCtr" class="mrgnB">
					<h2 class="sideHeading">Popular Cities</h2>
					<div class="clearfix"></div>
					<div class="locations clearfix" style="margin-top:5px">
						<jsp:include page="/place/includes/places_list.jsp">
							<jsp:param name="showCityName" value="true"/>
							<jsp:param name="showShortView" value="true"/>
							<jsp:param name="showCollect" value="true"/>
							<jsp:param name="showImportantTags" value="true"/>
							<jsp:param name="maxPlacesToShow" value="10"/>
						</jsp:include>
					</div>
					<% if (topCities.size() > 10) { %>
						<div class="topCtsMore mrgnT u_alignC u_normalF"><a href="#" onclick="$jQ('#topCtsCtr article').show(); $jQ('#topCtsCtr .topCtsMore').hide(); return false;" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div>
					<% } %>
				</div>
			<% } %>
			<% if (!ambiguousSearchResult.getCountryPkgGroupList().isEmpty()) { %>
				<div id="cntyGrpRsltCtr" class="mrgnB">
					<h2 class="sideHeading">Top Countries</h2>
					<div class="clearfix"></div>
					<div class="locations" style="margin-top:5px">
					<% 
						for (PackageGroupResultItem countryPkgGroup: ambiguousSearchResult.getCountryPkgGroupList()) { 
						    Destination countryDest = countryPkgGroup.getDestination();
						    List<PackageTag> popularTags = countryPkgGroup.getPopularTags();
						    String resultURL = searchQuery.getContentSearchURL(request, countryDest.getName() + " " + queryStr, null, null, null, false);
							String destinationURL = DestinationContentBean.getDestinationContentURL(request, countryDest);
							String descriptionText = UIHelper.extractRenderTextFromHTML(StringUtils.trimToEmpty(countryDest.getDescription()));							
					%>
						<article class="full-width" style="padding:0 0 10px 0">
							<figure>
								<a href="<%=resultURL%>"><img class="shot" src="<%=UIHelper.getImageURLForDataType(request, countryPkgGroup.getGroupImageURL(), FileDataType.I300X150, true)%>" style="width:100px;height:80px;border:1px solid rgba(0,0,0,.2);border-radius:3px"/></a>
							</figure>
							<div class="details" style="width:80%;padding-top:0">
								<h2 style="padding-bottom:2px;margin-bottom:2px;text-align:left">
									<a href="<%=resultURL%>" class="title" title="<%=countryDest.getName()%>"><%=countryDest.getName()%></a>
								</h2>
								<div class="clearfix"></div>
								<div class="description"><p>Duration: <%=countryPkgGroup.getMinNight()%>N<% if (countryPkgGroup.getMinNight() != countryPkgGroup.getMaxNight()) { %> - <%=countryPkgGroup.getMaxNight()%>N<% } %></p></div>
								<% if (StringUtils.isNotBlank(descriptionText)) { %>
									<div class="description" style="width:82%">
										<p><%=StringUtility.truncateAtWord(descriptionText, 150, true).replaceAll("\\?","")%></p>
									</div>
								<% } %>
								<% if (!popularTags.isEmpty()) { %>
									<div class="description hide"><p style="color:#093;"><b>Recommended for: </b><%=UIHelper.cutLargeText(ListUtility.toString(PackageTag.getPackageTagsDisplayNames(popularTags), ", "),100)%></p></div>
								<% } %>
								<div class="clearfix"></div>
								<div style="margin-top:5px;font-size:13px">
									<a href="<%=resultURL%>">Holiday Experiences &raquo;</a>
								</div>								
							</div>
						</article>
					<% } %>
					</div>
				</div>
			<% } %>
		</section>
		<aside class="right-sidebar">
			<jsp:include page="/package/includes/sidequeries.jsp" />
		</aside>
	<% } else { %>
		<jsp:include page="includes/cross_sell.jsp"/>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
			<p class="spSuggest mrgnT u_smallF">
				<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=SellableContentSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
			</p>
		<% } %>
		<div class="sNoRes mrgn2T mrgnB rnd5Bdr">
			<% if (searchResults == null) { %>
			<div class="sInfo">We detected a problem while searching for - <span><%=searchQuery.getQueryStr()%></span>.</div>
			<div class="sInfo">Here are some suggestions:</div>
			<div class="sSug">
				<ul class="blt">
					<li>Double check the spelling of your terms.</li>
					<li>Try using various synonyms or more general terms.</li>
				</ul>
			</div>
			<% } else { %>
			<div class="sInfo">Your search - <%=queryStr%> - did not returned any result.</div>
			<div class="sSug">
				Suggestions:
				<ul class="blt">
					<li>Make sure all words are spelled correctly.</li>
					<li>Try different keywords.</li>
					<li>Try more general keywords.</li>
				</ul>
			</div>
			<% } %>
		</div>
		<div style="display:none">
			<h2 class="hd21">Here are some more options...</h2>
			<jsp:include page="/package/includes/search_results_overview.jsp"/>
		</div>
	<% } %>
	</div>
	<!--//main content-->
</div>
</div>
<!--//main-->
<script type="text/javascript">
$jQ(document).ready(function() {
	//INDTLS.init('#topCtsCtr, #srchCmptRsltCtr, #cntyGrpRsltCtr, .inner-nav, #rightPanel','.productUrl');
	$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(searchQuery.getQueryStr()))%>').removeClass("example");
	$jQ('#holidaySearchForm').append('<input type="hidden" name="ctype" value="<%=searchQuery.getQueryParams().getOverallProductType().name().toLowerCase()%>">');
});
$jQ('#organize').on("click", '.organize-link', function(e) {
	var actJ = $jQ(e.currentTarget);
	var successLoadWid = function(a, m) {
		MODAL_PANEL.show('<div>' + m+ '</div>', {title:'Create your trip', blockClass:'lgnRgBlk'});
	}
	AJAX_UTIL.asyncCall(actJ.attr('href'), 
		{params:'', scope:this, wait:{inDialog:true},success:{parseMsg:true, handler: successLoadWid}});
	return false;
});
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp"/>
</body>
<% 
	if(debug) {
%>
<!-- Search Params: <%=searchQuery.getQueryParams()%> -->
<!-- Eng Params: <%=inputState%> -->
<!-- User Profile: <%=UserPersonalProfileManager.getCurrentUserPersonalProfile().getUserInputState().toString()%> -->
<!-- User Session Profile: <%=UserPersonalProfileManager.getCurrentUserPersonalProfile().getUserSessionInputState().toString()%> -->
<% 
	}
%>
</html>
