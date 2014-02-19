<%@page import="java.util.Calendar"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileBean"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.data.ResourcesPoC"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.engagement.rules.ECFRecommendation"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.engagement.rules.ECFRecommendations"%>
<%@page import="com.poc.server.search.ExtendedSearchResults"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.user.wall.UserWallItemWrapper"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.page.TopicPageType"%>
<%@page import="com.poc.server.review.ReviewManager"%>
<%@page import="com.poc.server.review.ReviewBean"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	ExtendedSearchResults<?, ?> extendedResults = (ExtendedSearchResults<?, ?>) request.getAttribute(Attributes.EXTENDED_SEARCH_RESULT.toString());
	
	boolean debug = SessionManager.isDebugEnabled(request);
	
	ECFRecommendations recommendations  = (ECFRecommendations)request.getAttribute(Attributes.ECF_RECOMMENDATIONS.toString());
	ECFRecommendations impLinks  = (ECFRecommendations)request.getAttribute(Attributes.ECF_IMPORTANT_LINKS.toString());
	ECFRecommendations getMoreInfo  = (ECFRecommendations)request.getAttribute(Attributes.ECF_GET_MORE_INFO.toString());
	getMoreInfo = null;
	// No get more info here. Everything is in Popular Queries.
	boolean loadRecommendations = Boolean.parseBoolean(request.getParameter("loadRecommendations"));

	ProductSupplierRecommendationsCollection recommendationsCollection = (extendedResults != null) ? extendedResults.getRecommendationsCollection(): null;

	ECFRecommendations popularQueries  = (ECFRecommendations)request.getAttribute(Attributes.ECF_POPULAR_QUERIES.toString());
	
	boolean recommendationsDisplayEnabled = ECFEngine.isRcommendationsDisplayEnabled(); 
	boolean impLinksDisplayEnabled = ECFEngine.isImpLinksDisplayEnabled();
	boolean getMoreInfoDisplayEnabled = ECFEngine.isGetMoreInfoDisplayEnabled();
	boolean popularQueriesDisplayEnabled = ECFEngine.isPopularQueriesDisplayEnabled();

	Collection<ViaProductType> relatedResultProductTypes = ExtendedSearchResults.getRelatedResultProductTypes(searchQuery);
	Destination cityDestination = DestinationContentManager.getDestinationFromCityId(7104);
	AbstractPage<UserWallItemWrapper> wallPaginationData = null;
	Set<Integer> toCities = (searchQuery != null) ? searchQuery.getQueryParams().getTo(): null;

	boolean showSearchFeedback = searchQuery != null;
%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Set"%>
<%@page import="com.poc.server.supplier.ProductSupplierRecommendationsCollection"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.SellableContentSearchBean"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<% if (showSearchFeedback) { %>
<style type="text/css">
.srchFdbkCtr {width:86%;}
.srchFdbkCtr .srchFdkRt {margin-bottom:10px}
.srchFdbkCtr .srchFdkRt a {display:block; float:left;}
.srchFdbkCtr .srchFdkMsg {}
.srchFdbkCtr .srchFdkMsg .grBtn1 {background:#093; color:#fff;}
.srchFdbkCtr .srchRsp {font-size:13px; font-weight:bold; text-align:center; padding:10px; border-radius:5px; background:#CDEB8B;}
</style>
<div class="srchFdbkCtr" id="srchFdbkCtrDiv" style="display:none">
	<h2 class="sideHeading">Did you like the quality of our search?</h2>
	<div class="srchFdkRt u_block">
		<a href="#" data-rate="1" style="font-size:12px">No</a>
		<a href="#" data-rate="5" style="font-size:12px;margin-left:10px">Yes</a>
	</div>
	<div class="srchFdkMsg" style="display:none;">
		<form>
			<div><textarea name="message" rows="4" class="example" title="Any feedback you have?"></textarea></div>
			<div class="u_alignR"><a href="#" onclick="SRCHFDK.saveFeedback(); return false;" class="search-button">Send</a></div>
		</form>
	</div>
</div>
<% } %>
<% 
	if (extendedResults != null && extendedResults.hasGeneralSearchResults()) { 
	    request.setAttribute(Attributes.SEARCH_RESULT_ITEM.toString(), ListUtility.getFirstInCollection(extendedResults.getGeneralSearchResults().getResults()));
%>
<article class="default clearfix sideBlock" style="padding:10px;margin-bottom:15px;border:1px solid #eee">
	<h2 class="mrgn10B sideHeading">Are you looking for:</h2>
	<div>
		<jsp:include flush="true" page="/search/includes/general_result_thumb_view.jsp"/>
	</div>
	<div class="clearfix left">
		<a href="<%=searchQuery.getContentSearchURL(request, null, ViaProductType.GENERAL, SellableContentSearchViewType.NONE, false)%>" style="font-size:12px">View More</a>
	</div>
</article>
<% } %>

<% if (loadRecommendations) { %>
	<div id="rcmndCltCtr"></div>
<% } else { %>
	<% if (recommendationsCollection != null && recommendationsCollection.hasUnbundledRecommendations()) { %>
	<article class="default clearfix sideBlock" id="rcmndCltCtr">
		<div class="deal-of-the-day">
			<h2 class="mrgn10B sideHeading">Featured Recommendations</h2>
			<% 
			    request.setAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString(), recommendationsCollection.getUnbundledRecommendations().getRecommendations());
			%>
			<jsp:include page="/recommendation/includes/supplier_reco_results.jsp">
				<jsp:param name="showThumbView" value="true"/>
				<jsp:param name="maxResultsToShow" value="<%=ProductSupplierRecommendationsCollection.MAX_UNBUNDLED_RECOMMEDATIONS_TO_SHOW%>"/>
			</jsp:include>
			<div class="clearfix right">
				<a href="<%=searchQuery.getContentSearchURL(request, null, recommendationsCollection.getProductType(), SellableContentSearchViewType.RECOMMENDATION, false)%>" style="font-size:12px">View More</a>
			</div>
		</div>
	</article>
	<% } %>
<% } %>
<%	if(getMoreInfoDisplayEnabled && getMoreInfo!= null &&  getMoreInfo.isNotEmpty() 
		|| popularQueriesDisplayEnabled && popularQueries !=null  && popularQueries.isNotEmpty()) { %>
<article class="default clearfix sideBlock" style="display:none">
	<div class="deal-of-the-day">
		<h2 class="mrgn10B sideHeading">You could also search for</h2>
		<%	if(getMoreInfoDisplayEnabled && getMoreInfo !=null  && getMoreInfo.isNotEmpty()) { %>
			<% 
				int moreInfoCounter = 0;
				String classname = "";
				for(ECFRecommendation query : getMoreInfo.getList()) { 
				
			%>
					<p style="width:100%" class="<%=classname%>"><a style="font-size:12px;" href="<%=query.getUrl()%>"><%=query.getTitle()%></a></p>
			<% 
					moreInfoCounter++;
					if(moreInfoCounter > 6){
						classname="moresearches hide";
					}
				}
				if(moreInfoCounter > 6) {
			%>
			<p style="width:100%;text-align:right">
				<a href="#" onclick="$jQ('.moresearches').show();return false;" style="font-size:12px">View more</a>
			</p>		
			<%
				}
			%>
		<%	} %>
		<%  if(popularQueriesDisplayEnabled && popularQueries !=null  && popularQueries.isNotEmpty()) { %>
			<% 
				int moreInfoCounter = 0;
				String classname = "";
				for(ECFRecommendation query : popularQueries.getList()) { 
			%>
					<p style="width:100%" class="<%=classname%>"><a style="font-size:12px;" href="<%=query.getUrl()%>"><%=query.getTitle()%></a></p>
			<% 
					moreInfoCounter++;
					if(moreInfoCounter > 6){
						classname="moresearches hide";
					}
				} 
				if(moreInfoCounter > 6) {
			%>
			<p style="width:100%;text-align:right"><a href="#" onclick="$jQ('.moresearches').show();return false;" style="font-size:12px">View more</a></p>
			<%
				}
			%>
		<% } %>
	</div>
<div class="clearfix"></div>
</article>
<%	} %>
<% for (ViaProductType productType: relatedResultProductTypes) { %>
	<div id="relatedResult<%=productType.name()%>" style="display:none;"></div>
<% } %>
<div class="clearfix"></div>
</article>
<%	if(recommendationsDisplayEnabled && recommendations !=null  && recommendations.isNotEmpty()) { %>
<article class="default clearfix" style="display:none">
	<div class="deal-of-the-day">
		<h3 class="mrgn10B">Recommended for you</h3>
		<% for(ECFRecommendation impLink : recommendations.getList()) { %>
			<p>
				<a style="font-size:12px;" href="<%=impLink.getUrl()%>"><%=impLink.getTitle()%></a>
			</p>
		<% } %>
	</div>
</article>
<%	} %>
<div id="topExperts"></div>
<% 
	if(debug) {
%>
<!--  Recs: <%=debug && recommendations !=null ? recommendations.toString() : "" %>  -->
<!--  Imp Links: <%=debug && impLinks !=null ? impLinks.toString() : "" %>  -->
<!--  Get More Info: <%=debug && getMoreInfo !=null ? getMoreInfo.toString() : "" %>  -->
<!--  Popular Queries: <%=debug && popularQueries !=null ? popularQueries.getList().size() : "" %>  -->
<% 
	}
%>
<script type="text/javascript">
$jQ(document).ready(function() {
	<% if (showSearchFeedback) { %>
		SRCHFDK.init();
	<% } %>
	<% if (loadRecommendations) { %>
		var loadRecommendations = function() {
			var successRecLoaded = function(a, m, x) {
				var rsltO = JS_UTIL.parseJSON($jQ(x).text());
				$jQ('#rcmndCltCtr').html($jQ('<div>'+rsltO.rsltH+'</div>'));
			};
			AJAX_UTIL.asyncCall('<%=SellableContentSearchBean.getExtendedRecommendationsSearchURL(request)%>', 
				{params: '<%=(searchQuery != null) ? "q=" + StringUtility.encodeURLString(searchQuery.getQueryStr()): ""%>&type=<%=ViaProductType.HOTEL.name()%>', scope: this,
					wait: {inDialog: false, msg: 'Loading...'}, error: {inDialog:false},
					success: {parseMsg:true, handler: successRecLoaded}
			});
		}
		loadRecommendations();
	<% } %>

	var successResultsLoaded = function(a, m, x) {
		var rsltO = JS_UTIL.parseJSON($jQ(x).text());
		$jQ('#relatedResult'+rsltO.typ).replaceWith($jQ('<div class="related">'+rsltO.rsltH+'</div>'));
	};
	<% for (ViaProductType productType: relatedResultProductTypes) {
			if(searchQuery != null && productType != null) { 
	%>
	AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.LOAD_EXTENDED_RELATED_RESULTS)%>', 
		{params: 'q=<%=StringUtility.encodeURLString(searchQuery.getQueryStr())%>&type=<%=productType.name()%>', scope: this,
			wait: {inDialog: false, msg: 'Loading...'}, error: {inDialog:false},
			success: {parseMsg:true, handler: successResultsLoaded}
		});
	<% } } %>
	<% if(toCities != null && !toCities.isEmpty()) { %>
	var successResultsLoaded = function(a, m) {
		$jQ('#topExperts').html(m);
	};
	AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.LOAD_TOP_CONTRIBUTIONS)%>', 
		{params: 'ci=<%=ListUtility.toString(toCities, ",")%>', scope: this, wait: {inDialog: false, msg: 'Loading...'}, error: {inDialog:false}, 
		success: {parseMsg:true, handler: successResultsLoaded} 
		});	
	<% } %>
});
<% if (showSearchFeedback) { %>
var SRCHFDK = new function() {
	var me = this; me.prms = {};
	this.init = function() {
		me.prms["q"] = '<%=StringEscapeUtils.escapeJavaScript(searchQuery.getQueryStr())%>';
		me.ctr = $jQ('#srchFdbkCtrDiv'); me.rtCtr = $jQ('.srchFdkRt', me.ctr); me.msgCtr = $jQ('.srchFdkMsg', me.ctr);
		$jQ('.example', me.msgCtr).example(function() {return $jQ(this).attr('title')});
		$jQ("form", me.msgCtr).validate({
			rules: {"message": {required: true}},
			messages: {"message": {required: "Please enter your message"}}
		});
		$jQ('a', me.rtCtr).click(function() {
			var rtJ = $jQ(this);
			me.saveRating(rtJ.data('rate'));
			return false;
		});
	}
	this.saveRating = function(rt) {
		var successSave = function(a, m) {
			me.prms.fdkId = m;
		};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.SAVE_SEARCH_RATING)%>', 
			{params: $jQ.param(me.prms)+'&rate='+rt, scope: this, wait: {inDialog: false}, error: {inDialog:false}, 
				success: {parseMsg:true, handler: successSave} });
		if (!me.msgCtr.is(':visible')) {me.rtCtr.hide(); me.msgCtr.show();}
	}
	this.saveFeedback = function() {
		if (!$jQ("form", me.msgCtr).valid()) {
			return false;
		}
		var successSave = function(a, m) {
			me.ctr.html('<div class="srchRsp">'+m+'</div>');
		};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.SAVE_SEARCH_FEEDBACK)%>', 
			{params: $jQ.param(me.prms)+'&'+$jQ("form", me.msgCtr).serialize(), scope: this, wait: {inDialog: false, msg:'&nbsp;', divEl:$jQ('a', me.msgCtr)}, error: {inDialog:false}, 
				success: {parseMsg:true, handler: successSave} });	
	}
}
<% } %>
</script>