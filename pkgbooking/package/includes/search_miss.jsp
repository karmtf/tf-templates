<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Set"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.SellableContentSearchBean"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<% String searchQuery = RequestUtil.getStringRequestParameter(request, "query", ""); %>
<div class="notification rounded" style="background:rgb(255, 253, 244);font-size: 13px;border:1px solid rgb(240, 235, 202); color: rgb(167, 127, 67);padding:10px;margin:0px 0 10px 0;">
	We understand what you are looking for, but we are currently building the content for this destination. We will have more options around this destination in a few days.
	<div class="mrgnT">
		<p>Please leave us your email and we will inform you as soon as we have content for this destination</p>
		<div class="mrgn10T srchFdk">
			<form id="fdbkdiv">
				<input type="text" name="email" id="email" size="50" style="width:200px;font-size:13px;padding:5px" />
				<a class="search-button mrgn10T" href="#" onclick="SRCHMIS.saveFeedback()">Submit</a>
				<div class="mrgn10T" id="srchFdbkDiv"></div>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript">
var SRCHMIS = new function() {
	var me = this; me.prms = {};
	this.init = function() {
		me.prms["q"] = '<%=searchQuery%>';
		me.ctr = $jQ('#srchFdbkDiv');me.msgCtr = $jQ('.srchFdk');
		$jQ("#fdbkdiv").validate({
			rules: {"email": {required: true}},
			messages: {"email": {required: "Please enter your email"}}
		});
	}
	this.saveFeedback = function() {
		if (!$jQ("#fdbkdiv").valid()) {
			return false;
		}
		var successSave = function(a, m) {
			$jQ('#srchFdbkDiv').html('<div class="srchRsp">'+m+'</div>');
		};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.SAVE_SEARCH_MISS)%>', 
			{params: $jQ.param(me.prms)+'&'+$jQ("#fdbkdiv").serialize(), scope: this, wait: {inDialog: false, msg:'&nbsp;', divEl:$jQ('a', me.msgCtr)}, error: {inDialog:false}, 
				success: {parseMsg:true, handler: successSave} });	
	}
}
SRCHMIS.init();
</script>