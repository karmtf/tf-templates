<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="java.util.Date"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.b2c.ui.B2cCallcenterNavigation"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%
	User loggedInUser = SessionManager.getUser(request);
%>
<%@page import="com.eos.b2c.lead.LeadItemStatus"%>
<%@page import="com.eos.b2c.lead.LeadItemReason"%>
<div id="leadUpdateDiv" class="u_smallF" style="display:none;">
	<form name="leadUpdateForm" id="leadUpdateForm" class="def-form boldL wideL">
		<input type="hidden" name="lead_id" value="-1"/>
		<input type="hidden" name="status" value=""/>
		<input type="hidden" name="followupTime" value=""/>
		<fieldset>
			<dl>
				<dt class="sIn sInFOLLOW_UP sInFOLLOW_UP_PRODUCT_GAP"><label>Follow Up Time</label></dt>
				<dd class="sIn sInFOLLOW_UP sInFOLLOW_UP_PRODUCT_GAP">
					<select name="atime_hh"></select>
					<select name="atime_mm"></select>
					<select name="atime_a"></select>
				</dd>
				<dt class="sIn sInFOLLOW_UP sInFOLLOW_UP_PRODUCT_GAP"><label>Follow Up Date</label></dt>
				<dd class="sIn sInFOLLOW_UP sInFOLLOW_UP_PRODUCT_GAP">
					<input type="text" name="acallDate" value="<%= ThreadSafeUtil.getDateFormat(true, false).format(new Date()) %>" size="10" class="calInput">
				</dd>
				<dt class="sIn sInSUCCESS"><label>Order Reference</label></dt>
				<dd class="sIn sInSUCCESS"><input type="text" name="orderRef"></dd>
				<dt class="sIn sInINVALID sInNOT_INTERESTED"><label>Reason</label></dt>
				<dd class="sIn sInINVALID sInNOT_INTERESTED">
					<select name="leadReason" style="width:200px;">
						<option value="">-- Select --</option>
						<% for (LeadItemReason lReason: LeadItemReason.values()) { %>
							<option value="<%=lReason.name()%>"><%=lReason.getDisplayText()%></option>
						<% } %>
					</select>
				</dd>
				<dt><label>Comments</label></dt>
				<dd><textarea name="comments" rows="6" cols="60"></textarea></dd>
			</dl>
		</fieldset>
		<div class="u_alignR mrgnT"><button type="button" onclick="return saveLeadChanges();" class="actiong">Submit</button></div>
	</form>
</div>

<div id="leadAssignDiv" class="u_smallF" style="display:none;">
	<form name="leadAssignForm" id="leadAssignForm" class="def-form boldL">
		<input type="hidden" name="leadId" value="-1"/>
		<input type="hidden" name="uId" value="-1"/>
		<fieldset>
			<dl>
				<dt><label>Assign To</label></dt>
				<dd><input type="text" id="assignUserId" value=""/></dd>
				<dt></dt>
				<dd><a href="#" onclick="return reassignLead();" class="actiong">Assign Lead</a></dd>
			</dl>
		</fieldset>
	</form>
</div>

<script type="text/javascript">
$jQ(document).ready(function() {
	<%-- Not required as of now.
	$jQ("#assignUserId").autocomplete('<%=Constants.SERVLET_ADMIN%>?action1=<%=B2cNavigationConstantBean.AC_USERS_X_ACTION%>&rl=<%=RoleType.CALLCENTER.name()%>,<%=RoleType.SUPERVISOR.name()%>', {
		selectFirst:true, autoFill:true, matchInside:false, matchSubset:true, maxItemsToShow:0, mustMatch:true, remoteDataType:'json', sortResults: true,
		showResult: null,
		onItemSelect: function(item) {
			document.leadAssignForm.uId.value = item.data.id;
		}
	});
	--%>
	
	var aappDateCal = new DatePick({fromInp:document.leadUpdateForm.acallDate});
	JS_UTIL.populateTimeFields(document.leadUpdateForm.atime_hh, document.leadUpdateForm.atime_mm, document.leadUpdateForm.atime_a, true);
});

function showULead(lId, sts, fTm, updTxt) {
	document.leadUpdateForm.lead_id.value=lId;
	document.leadUpdateForm.status.value=sts;
	if (fTm) {JS_UTIL.setTimeFields(fTm, document.leadUpdateForm.atime_hh, document.leadUpdateForm.atime_mm, document.leadUpdateForm.atime_a);}
	$jQ('#leadUpdateDiv .sIn').hide();
	$jQ('#leadUpdateDiv .sIn'+sts).show();
	MODAL_PANEL.show('#leadUpdateDiv', {title:updTxt, blockClass:'wdBlk2'});
	return false;
}
function saveLeadChanges() {
	document.leadUpdateForm.followupTime.value= document.leadUpdateForm.acallDate.value+' '+JS_UTIL.getTimeFromElements(document.leadUpdateForm.atime_hh, document.leadUpdateForm.atime_mm, document.leadUpdateForm.atime_a);
	AJAX_UTIL.asyncCall('/partner/update-hotel-lead', 
		{form:"leadUpdateForm", scope: this, error: {}, success: {handler: function() {MODAL_PANEL.showAlert("Lead Updated Successfully"); window.location.reload();}}});
	return false;
}
function showReassignLead(lId, uId) {
	document.leadAssignForm.leadId.value=lId;
	document.leadAssignForm.uId.value=uId;
	MODAL_PANEL.show('#leadAssignDiv', {title:'Reassign Lead #'+lId});
	return false;
}
function reassignLead() {
	AJAX_UTIL.asyncCall('<%=Constants.SERVLET_ADMIN%>?action1=<%=B2cNavigationConstantBean.REASSIGN_LEAD_ACTION%>', 
		{form:"leadAssignForm", scope: this, error: {}, success: {handler: function() {window.location.reload();}}});	
	return false;
}
function sendLeadEmail(lId, eml) {
	SNDEMLSMS.showSendEmail(lId, '<%=loggedInUser.getName()%>', '<%=loggedInUser.getEmail()%>', eml, 'holiday.response@via.com', '');
	return false;
}
function updateStatus(leadId) {
	AJAX_UTIL.asyncCall('/callcenter', 
		{params: 'action1=<%=B2cCallcenterNavigation.UPDATE_LEAD_ITEM_STATUS_ACTION%>&lead_id='+leadId+'&status='+$jQ('#leadStatus'+leadId).val(), scope: this,
			wait: {inDialog:false, msg:'Updating', divEl:$jQ('#leadStatusCol'+leadId)}, success: {}
		});
}
</script>