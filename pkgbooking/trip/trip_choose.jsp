<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	List<PackageConfigData> pkgConfigs = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	PackageConfigData selectedPkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());

	boolean createNewTrip = (pkgConfigs == null || pkgConfigs.isEmpty() || selectedPkgConfig == null);
%>
<%@page import="com.poc.server.config.PackageConfiguratorBean"%>
<html>
<head>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<title>Choose or Create a Trip</title>
</head>
<body>
<style type="text/css">
.wzOpts {margin:0 2em 0;}
.wzOpts .wzOpt {list-style:none; float:left; margin:0 20px 20px 0; position:relative; max-height:120px; min-height:120px;}
.wzOpts .wzOpt a {display:block; text-align:center; text-decoration:none;}
.wzOpts .wzOptWimg img {display:block; padding-bottom:5px;}
.wzOpts .wzOptTxtBx a {background:#246; border:3px solid #152a3f; width:80px; height:80px; color:#fff; font-weight:bold; line-height:80px; border-radius:10px;}
.wzOpts .wzOptTxtBx a:hover {background:#59b; border-color:#3b7694;}
.wzOpts .optPtr {position:absolute; bottom:-22px; left:40px;}
.wzOpts .optPtr div {border:15px solid; border-color:#666 transparent; border-top-width:0; position:absolute; width:0; height:0; content:''; visibility:hidden;}
.wzOpts .wzOptSel .optPtr div {visibility:visible;}
</style>
<jsp:include page="/common/includes/viacom/header_new.jsp" />

<!--main-->
<div class="main" role="main">		
	<div class="wrap clearfix">
	<!--main content-->
	<div class="content clearfix">
		<section class="three-fourth">
			<article class="tab-content"><h1>Select the Trip</h1></article>
			<div class="clearfix"></div>
			<article class="full-width">
			<div>
				<ul class="wzOpts u_block">
					<li id="trpOpt-1" class="wzOpt wzOptWimg">
						<a href="#" onclick="TRPCHS.loadChangePkgItn(-1); return false;">
							<img src="#" width="100" height="75"/>
							<span>Create a New Trip...</span>
						</a>
						<div class="optPtr"><div></div></div>
					</li>
					<% for (PackageConfigData pkgConfig: pkgConfigs) { %>
						<li id="trpOpt<%=pkgConfig.getId()%>" class="wzOpt wzOptWimg" style="width:100px;">
							<a href="#" onclick="TRPCHS.loadChangePkgItn(<%=pkgConfig.getId()%>); return false;">
								<img src="<%=UIHelper.getImageURLForDataType(request, pkgConfig.getImageURL(request), FileDataType.I300X150, true)%>" width="100" height="75"/>
								<span class="u_smallF"><%=pkgConfig.getPackageName()%></span>
							</a>
							<div class="optPtr"><div></div></div>
						</li>
					<% } %>
				</ul>
			</div>
			</article>
			<article class="full-width" style="padding:10px; background:#fff; border:5px solid #666;">
				<div id="pkgPreCfgCtr" style="<%=(createNewTrip || selectedPkgConfig != null) ? "": "display:none;"%>">
					<% if (createNewTrip || selectedPkgConfig != null) { %>
						<jsp:include page="/config/includes/config_prerequisites.jsp">
							<jsp:param name="askPaxInfo" value="true"/>
							<jsp:param name="isCustF" value="true"/>
							<jsp:param name="orgnzTrip" value="true"/>
						</jsp:include>
					<% } %>
				</div>
			</article>
		</section>
	</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp">
	<jsp:param name="hideWidget" value="true" />
</jsp:include>
<script type="text/javascript">
$jQ(document).ready(function() {
	TRPCHS.setOptSelected(<%=(selectedPkgConfig != null) ? selectedPkgConfig.getId(): -1L%>);
});
var TRPCHS = new function() {
	var me = this; this.chgItns = {};
	this.setOptSelected = function(pId) {
		$jQ('.wzOpts li').removeClass('wzOptSel');
		$jQ('#trpOpt'+pId).addClass('wzOptSel');
	}
	this.loadChangePkgItn = function(pId) {
		//if (me.chgItns[pId]) {me.showChangePkgItn(pId); return;}
		var successLoad = function(a, m, x) {
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			me.chgItns[pId] = $jQ('<div>' + rspO.htm + '</div>');
			MODAL_PANEL.hide();
			me.showChangePkgItn(pId);
			me.setOptSelected(pId);
		}
		AJAX_UTIL.asyncCall('<%=PackageConfiguratorBean.getItineraryPreConfiguratorBaseURL(request)%>', 
			{params: 'itnId='+pId+'&askPaxInfo=true&orgnzTrip=true&isCustF=true', scope: this,
				success: {handler: successLoad}	});
	}
	this.showChangePkgItn = function(pId) {
		$jQ('#pkgPreCfgCtr').html(me.chgItns[pId]).show();
	}
}
</script>
</body>
</html>
