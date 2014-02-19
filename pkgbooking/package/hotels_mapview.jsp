<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%
	HelpBean.setCurrentHelpPageType(request, HelpPageType.PACKAGES_MAP_VIEW);
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.HTLS_VIEW_JS});
	String query = StringUtils.trimToNull(request.getParameter("q"));
	String filtersStr = StringUtils.trimToNull(request.getParameter("filters"));
	query = (query != null) ? query: "hotels";

	Date startDate = TripCartBean.getRequestStartDate(request);
	Date endDate = TripCartBean.getRequestEndDate(request);
%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.help.HelpBean"%>
<%@page import="com.eos.b2c.help.HelpPageType"%>
<%@page import="java.util.Date"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.poc.server.trip.TripCartBean"%>
<html>
<head>
<meta charset="UTF-8">
<title>Hotels Map View</title>

<jsp:include page="<%=SystemProperties.getHeadTagsPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>

</head>
<body>
<style type="text/css">
html, body, #doc {height:100%;}
.pageSize {width:auto;}
#hd {box-shadow:0 0 0;}
#bd {position:absolute; top:60px; bottom:0; left:0; right:0; margin:0;}
#hd div.middle, #hd div.middle .headerContent {height:auto;}
#doc {width:100%;}
#ft {display:none;}
.sb {margin-left:300px !important;}

body ::-webkit-scrollbar {background-color:#E7E7E7; border:1px solid #ACACAC; height:12px; width:12px;}
body ::-webkit-scrollbar-thumb {border-radius:6px; -moz-border-radius:6px; -webkit-border-radius:6px; background:#C5CBD5; border:1px solid #949CAD;}

.mapWrapper {position:absolute; top:32px; bottom:0; left:0; right:0; overflow:hidden; border-top:1px solid #ccc; z-index:1; box-shadow:-1px 1px 10px #999;}
.rsltCtr {position:absolute; top:0; left:0; bottom:0; width:350px; overflow-y:scroll; background:#eee;}
.rsltCtr .rsltBkAct {cursor:pointer; color:#000; padding:12px 5px; font-size:12px; font-weight:bold;}
.rsltCtr .rsltBkAct a {text-decoration:none;}
.rsltCtr .rmsgCtr {background:#4F7DDD; color:#fff; padding:10px 20px; font-size:14px; font-weight:bold; margin:0 0 5px;}
.mapCtr {position:absolute; top:0; left:350px; bottom:0; right:0; overflow:hidden;}
.mapCtr .mapC {position:absolute; top:0; left:0; bottom:0; right:0; overflow:hidden;}
.mapWrapper .mapMsg {position:absolute; top:20%; left:40%; z-index:1000; padding:10px; background:#FBE65D; border-radius:5px; box-shadow:1px 1px 4px #888; font-weight:bold; max-width:200px; text-align:center; display:none;}
.rsltHider {position:absolute; top:50%; left:349px; width:14px; height:19px; background:#ff8; color:#000; font-size:20px; line-height:15px; border-radius:0 3px 3px 0; cursor:pointer; border:1px solid #999; border-left:0;}
.rsltHider div {padding-left:1px;}
.wLgMapVw .rsltCtr {width:0;}
.wLgMapVw .mapCtr {left:0;}
.wLgMapVw .rsltHider {left:0;}

.fltrCtr .grBtn5.selected {background:#FCF9D7;}
.fltrCtr a.selected {font-weight:bold;}

.pHtlSmV {padding:5px; border-bottom:1px solid #C5DFFD; background:#fff; text-align:left;}
.pHtlSmV .name {font-weight:bold; font-size:12px; overflow:hidden;}
.pHtlSmV .priceCtr {text-align:center;}
.pHtlSmV .priceBx {font-size:11px; font-weight:bold;}
.pHtlSmV .priceMlp {color:#777; font-size:10px;}
.pHtlSmV .loc {color:#777;}
.pHtlSmV .star {margin:2px 0 0 5px;}
.pHtlSmV .star .srating {display:block;}
.pHtlSmV .rate {margin-left:16px;}
.pHtlSmV .htlActC {padding:5px 0;}
.pHtlSmV .htlActC a {text-decoration:none;}

.hCtySmV {padding:5px; margin-bottom:4px; background:#fff; text-align:left;}
.hCtySmV .name {font-weight:bold; font-size:13px; overflow:hidden; color:#3551BF;}
.hCtySmV .priceRng {font-weight:bold;}
.hCtySmV .thumbnail {padding:2px; box-shadow:1px 1px 3px #999;}
.hCtySel {background:transparent; border:0; box-shadow:0 0 0;}

.pTb {padding:0; margin:0;}
.pTb li {float:left; margin-left:5px; background:-webkit-gradient(linear,left top,left bottom,from(#FFF5C8),to(#FFD616)); border:1px solid #ccc; border-radius:3px 3px 0 0; font-weight:bold; font-size:12px; list-style:none;}
.pTb li a {display:block; padding:5px 8px; color:#000; text-decoration:none;}
.pTb li.sel {background:#fff; border-bottom:1px solid #fff;}
.pTb li.sel a {color:#000;}
.pTbCnt {background:#fff; border:1px solid #ccc; margin-top:-1px; box-shadow:1px 1px 5px #999}

.htlDescV {padding:5px; background:#fff; text-align:left;}
.htlDescV .name {font-weight:bold; font-size:14px; text-align:center; padding-top:5px;}
.htlDescV .desc {padding:10px 0;}

.ctLst {margin:0; padding:0; float:left; width:100px; text-align:left; background:#eee;}
.ctLst li {border-bottom:1px solid #aaa; border-right:1px solid #aaa; list-style:none;}
.ctLst li a {display:block; text-decoration:none; padding:3px 6px;}
.ctLst li.csel {border-right:1px solid #fff; background:#fff;}
.ctLst li.csel a {font-weight:bold; color:#000;}
.ctLCtr {margin-left:99px; border-left:1px solid #aaa; text-align:left;}

.ctHtlCtr {margin:8px 0;}
.htlFCtr {margin:0 10px 10px; position:relative; z-index:1;}
.htlFCtr ul {margin:0; padding:0;}
.htlFCtr li.fltrD {float:left; margin-right:10px; position:relative; cursor:pointer;  list-style:none;}
.htlFCtr .smpNv li {width:160px; list-style:none;}
.htlFCtr .smpNv li a:hover {background:#EDF7FA}
.htlFCtr .scrlNv {overflow-y:scroll; height:250px;}
.htlFCtr .grBtn2.selected {background:#FCF9D7;}
.htlFCtr a.selected {font-weight:bold;}
.htlFCtr a.nrmlVw {text-decoration:none; color:#000; font-size:12px; padding:4px 5px 5px 28px; background:transparent url(//<%=Constants.IMAGES_SERVER%>/static/img/poccom/icon_gridview.gif) no-repeat 0 0; line-height:24px;}

.htlVHvr {cursor:pointer;}
.pHStrSel, .pHtlSel {background:#FFFF88;}
.htlPkgCtr {border:3px solid #FFFF88;}

</style>
<jsp:include page="/gmap/gmap_display_util.jsp" />
<jsp:include page="/common/includes/viacom/header.jsp" />

<div id="pkgsMapVw" style="position:absolute; top:0; bottom:0; left:0; right:0;">
	<div class="fltrCtr u_block"></div>
	<div class="mapWrapper">
		<div class="rsltCtr"></div>
		<div class="mapCtr">
			<div class="mapMsg"></div>
			<div class="mapC"></div>
		</div>
		<div class="rsltHider"><div>&laquo;</div></div>
	</div>
</div>

<div style="display:none;">
	<jsp:include page="includes/trip_idea.jsp">
		<jsp:param name="isOnMapView" value="true"/>
	</jsp:include>
	<jsp:include page="includes/search_tabs.jsp">
		<jsp:param name="isOnMapView" value="true"/>
	</jsp:include>

	<div class="hCtySmV" id="htlCtyTmpl">
		<div class="u_floatL" style="width:79px;">
			<div class="thumbnail"><img src="" width="75" height="50"></div>
		</div>
		<div class="" style="margin-left:90px;">
			<div class="name"></div>
			<div class="u_floatL htlCnt" style="padding-top:4px;"></div>
			<div style="clear:right;"></div>
			<div class="u_alignR priceRng" style="padding-top:4px;"></div>
		</div>
		<div class="u_clear"></div>
	</div>

	<div class="pHtlSmV" id="htlTmpl">
		<div class="u_floatL" style="width:75px; margin-right:10px">
			<div class="posR"><img src="" width="75" class="thumbnail"></div>
		</div>
		<div>
			<div class="name"></div>
			<div style="padding-top:4px;">
				<div class="u_floatR priceCtr">
					<div class="priceBx grBtn4"></div>
					<div class="priceMlp">per night</div>
				</div>
				<div class="u_floatL" style="width:160px;">
					<div class="loc"></div>
				</div>
			</div>
			<div class="u_clear"></div>
		</div>
		<div class="u_clear"></div>
		<div style="min-height:25px;">
			<div class="u_floatL star"></div>
			<div class="u_floatL rate"></div>
			<div class="u_floatR htlActC"></div>
		</div>
		<div class="u_clear"></div>
	</div>

	<div class="htlDescV" id="hotelDescTmpl">
		<div style="width:150px; padding:0 0 10px 0;"><img src="" width="150" class="thumbnail"></div>
		<div class="name"></div>
		<div class="u_alignJ desc"><div class="desc"></div></div>
	</div>
</div>

<jsp:include page="/common/includes/viacom/footer.jsp"/>
<script type="text/javascript">
var htlV = null;
$jQ(document).ready(function() {
	<% if (query != null) { %>
		$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(query))%>').removeClass("example");
	<% } %>
	htlV = new HtlsView({ctr:'#pkgsMapVw', query:'<%=query%>',
		currency:'<%=CurrencyType.getShortCurrencyCode(SessionManager.getCurrentUserCurrency(request))%>',
		<% if (startDate != null) { %>hdate: '<%=ThreadSafeUtil.getDateFormat(false, false).format(startDate)%>',<% } %>
		<% if (endDate != null) { %>hdate2: '<%=ThreadSafeUtil.getDateFormat(false, false).format(endDate)%>',<% } %>});
	htlV.fetchResults('<%=query%>', <%=filtersStr != null ? "'" + filtersStr + "'": "null"%>);
	$jQ("#holidaySearchForm").submit(function(e) {
		htlV.fetchResults($jQ("#hldSrchInp").val(), null);
		return false;
	}).find("button").removeAttr("onclick");
});
</script>
</body>
</html>
