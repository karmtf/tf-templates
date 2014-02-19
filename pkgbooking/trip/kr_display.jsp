<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="com.eos.b2c.engagement.KnowledgeRelationshipBean"%>
<%
	KnowledgeRelationship kr = (KnowledgeRelationship) request.getAttribute(Attributes.KNOWLEDGE_RELATION.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (SearchResult) request.getAttribute(Attributes.SEARCH_RESULT.toString());

	String krTitle = KnowledgeRelationshipBean.getKRDisplayTitle(kr);

	boolean debug = SessionManager.isDebugEnabled(request);
%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.via.search.data.SearchResult"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, krTitle)%> | TripFactory</title>
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="cache-control" content="no-cache,must-revalidate"/>
<meta http-equiv="expires" content="0"/>
<meta name="description" content="<%=krTitle%>" />
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<style type="text/css">
h1.krHd {color:#333; padding:0 0 4px; font-size:22px; margin-bottom:10px; font-weight:bold; text-shadow:none; line-height:30px;}
.deals .full-width figure img {height:130px}
.deals .full-width figure {width:24%;}
@media screen and (max-width: 830px) {
.left-sidebar {display:none;}
}
@media screen and (max-width: 768px) {
.left-sidebar {display:none;}
}
@media screen and (max-width: 600px) {
.left-sidebar {display:none;}
.three-fourth {width:100%;}
.deals .full-width figure {margin-right:15px;margin-top:5px}
.deals .full-width #addrline {display:none}
.deals .description p {display:none;}
.deals .full-width figure img {height:60px}
.deals .full-width .details {width:71%;}
}
</style>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">
			<section class="three-fourth">
				<h1 class="krHd" style="color:#333; padding:0 0 4px; font-size:20px;"><%=krTitle%></h1>
				<%
					request.setAttribute(Attributes.PRODUCT_TYPE.toString(), searchQuery.getQueryParams().getOverallProductType());
					request.setAttribute(Attributes.SEARCH_RESULT_PRODUCT_LIST.toString(), searchResults.getResultObjs());
				%>
				<jsp:include page="/search/includes/general_results_list.jsp"/>
			</section>
			<aside class="right-sidebar">
				<jsp:include page="/package/includes/sidequeries.jsp" />
			</aside>
		</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
<% 
	if(debug) {
%>
<!-- KR : <%=kr%> -->
<!-- Search Params: <%=searchQuery.getQueryParams()%> -->
<% 
	}
%>
</html>