<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.UserEntityList"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.user.entity.UserEntityWrapper"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.poc.server.user.entity.UserEntityBean"%>
<%@page import="com.poc.server.secondary.database.model.UserEntityAssociation"%>
<%
	List<UserEntityList> entityLists = (List<UserEntityList>) request.getAttribute(Attributes.USER_ENTITY_LISTS.toString());
	UserEntityList entityListSelected = (UserEntityList) request.getAttribute(Attributes.USER_ENTITY_LIST_SELECTED.toString());
	UserEntityWrapper entityWrapper = (UserEntityWrapper) request.getAttribute(Attributes.USER_ENTITY_WRAPPER.toString());
	UserEntityAssociation userEntity = entityWrapper.getUserEntityAssociation();

	JSONObject entityJSON = entityWrapper.toJSON();
%>
<%@page import="java.util.Date"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="com.eos.b2c.user.destination.UserDestinationListType"%>
<style type="text/css">
select {
padding:6px 15px;
width:250px;
font-size:14px;
margin: 0;
-webkit-border-radius:4px;
-moz-border-radius:4px;
border-radius:4px;
background:-webkit-gradient(linear, center top, center bottom, from(#f6f6f6), to(#e5e5e5));
background:-moz-linear-gradient(top, #f6f6f6, #e5e5e5);
filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#fff6f6f6', endColorstr='#ffe5e5e5', GradientType=0);
-webkit-box-shadow:inset 0 1px 0 rgba(255,255,255,0.8),inset 0 -1px 0 rgba(255,255,255,0.4),0 0 0 transparent;
box-shadow:inset 0 1px 0 rgba(255,255,255,0.8),inset 0 -1px 0 rgba(255,255,255,0.4),0 0 0 transparent;
height:43px;
color:#333;
border:none;
outline:none;
border:1px solid #cbcbcb;
display: inline-block;
-webkit-appearance:none;
-moz-appearance:none;
appearance:none;
cursor:pointer;
}
</style>
<div class="u_block">
	<div class="u_floatL">
		<img src="<%=entityJSON.optString("img")%>" width="100"/>
	</div>
	<div style="margin-left:120px;">
		<p style="font-size:18px; font-weight:bold;"><%=entityJSON.optString("nm")%></p>
		<p><%=entityJSON.optString("dsc")%></p>
	</div>
	<div class="u_clear"></div>
	<form name="addToEntityListForm" id="addToEntityListForm">
		<input type="hidden" name="productType" value="<%=entityWrapper.getProductType().name()%>">
		<input type="hidden" name="productId" value="<%=userEntity.getProductId()%>">
		<input type="hidden" name="ePrms" value="<%=userEntity.getEntityParams().toJSON()%>">
		<div class="mrgnT u_block normalF">
			<div class="u_floatL" style="width:300px;">
				<textarea name="notes" rows="5" class="example" placeholder="Add a comment"><%=StringEscapeUtils.escapeHtml(StringUtils.trimToEmpty(userEntity.getNotes()))%></textarea>
			</div>
			<div class="u_floatL" style="width:300px; margin-left:15px;">
				<div>
					<select name="listId" onchange="ADDENTLST.showListOpts();">
					<% for (UserEntityList entityList: entityLists) { %>
						<option value="<%=entityList.getId()%>" id="entList<%=entityList.getId()%>" data-ltype="<%=entityList.getListType().name()%>" <%=(userEntity.getListId() != null && entityList.getId().longValue() == userEntity.getListId()) ? "selected=\"selected\"": ""%>><%=entityList.getListName()%></option>
					<% } %>
					</select>
				</div>
				<div class="padTB lstOpt lstOpt<%=UserDestinationListType.NEXT_VACATION.name()%>" style="display:none;">
					<select name="tdate">
						<option value="">- Planning to go in -</option>
						<% for (Date dateOption: UserEntityBean.getTravelDateOptionsForUserEntityList()) { %>
							<option value="<%=ThreadSafeUtil.getDateFormat(false, false).format(dateOption)%>" <%=(userEntity.getDateOfTravel() != null && DateUtils.isSameDay(dateOption, userEntity.getDateOfTravel())) ? "selected=\"selected\"": ""%>><%=ThreadSafeUtil.getMMMMMYYYYDateFormat(false, false).format(dateOption)%></option>
						<% } %>
					</select>
				</div>
				<div class="padTB u_normalF" style="padding:10px 0"><label><input type="checkbox" class="checkbox" name="goingAgain" value="true" <%=userEntity.getGoingAgain() != null && userEntity.getGoingAgain() ? "checked=\"checked\"": ""%>/>&nbsp;I am going here again!</label></div>
				<div class="mrgn10T"><a href="#" onclick="ADDENTLST.save(); return false;" class="search-button" style="font-size:15px; line-height:35px; height:35px; padding:0px 50px">Save</a></div>
			</div>
		</div>
	</form>
</div>
<script type="text/javascript">
var ADDENTLST = new function() {
	var me = this;
	this.init = function() {
		me.showListOpts();
	}
	this.save = function() {
		var successAdd = function(a, m) {
			MODAL_PANEL.hide();
		}
		AJAX_UTIL.asyncCall('<%=UserEntityBean.getAddToEntityListURL(request)%>', 
			{form: 'addToEntityListForm', scope: this,
				success: {parseMsg:true, handler: successAdd}
			});
	}
	this.showListOpts = function() {
		var lId = $jQ(document.addToEntityListForm.listId).val();
		var lTyp = $jQ('#entList'+lId).data('ltype');
		$jQ('#addToEntityListForm .lstOpt').hide();
		$jQ('#addToEntityListForm .lstOpt'+lTyp).show();
	}
}
$jQ(document).ready(function() {
	ADDENTLST.init();
});
</script>