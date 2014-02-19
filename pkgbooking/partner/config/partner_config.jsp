<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%
	PartnerConfigData partnerConfigData = (PartnerConfigData) request.getAttribute(Attributes.PARTNER_CONFIG_DATA.toString());
	boolean isAdd = (partnerConfigData == null);
%>
<%@page import="com.poc.server.partner.PartnerIdentifierType"%>
<%@page import="com.poc.server.settings.AppFeatureType"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.settings.ProductSettings"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.settings.FlightSettings"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<html>
<head>
<title><%=isAdd ? "Add": "Edit"%> Partner Configs</title>
<jsp:include page="/includes/headTags.jsp">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/includes/header.jsp" />

<div class="cTab-bd tab-a-bd">
	<div class="sectionHd u_block">
		<h1 class="headFont hrDashB1"><%=isAdd ? "Add": "Edit"%> Partner Config</h1>
	</div>

	<div class="sectionBd mrgnT">
		<form id="addUpdatePartnerForm" name="addUpdatePartnerForm" class="def-form boldL wideL">
			<input type="hidden" name="partnerId" value="<%=isAdd ? "-1": partnerConfigData.getId() + ""%>"/>
			<fieldset>
				<dl>
					<dt><label>Partner Name</label></dt>
					<dd><input type="text" name="partnerName" value="<%=isAdd ? "": partnerConfigData.getPartnerName()%>"/></dd>
					<dt><label>Identifier Type</label></dt>
					<dd>
						<select name="identifierType" onchange="checkIdentifierType();">
						<% for (PartnerIdentifierType identifierType: PartnerIdentifierType.values()) { %>
							<option value="<%=identifierType.name()%>" <%=(!isAdd && partnerConfigData.getIdentifierType() == identifierType) ? "selected=\"selected\"": ""%>><%=identifierType.name()%></option>
						<% } %>
						</select>
					</dd>
					<dt><label>Identifier</label></dt>
					<dd><input type="text" name="identifier" value="<%=isAdd ? "": partnerConfigData.getIdentifier()%>"/></dd>
					<dt><label>User ID</label></dt>
					<dd><input type="text" name="userId" value="<%=isAdd ? "": partnerConfigData.getUserId()%>"/></dd>
					<%
						for (ViaProductType productType: PartnerConfigBean.getProductsToConfigureSettings(request)) {
							ProductSettings productSettings = SettingsController.getInstance(partnerConfigData).getProductSettings(productType);
					%>
						<dt class="prodSetCtr"><label><%=productType.getPromotionalText()%>:</label></dt>
						<dd class="prodSetCtr">
							<div class="u_block">
								<label><input type="checkbox" name="prodE<%=productType.name()%>" class="checkbox prodEnbl" data-prod="<%=productType.name()%>" value="true" <%=productSettings.isEnabled() ? "checked=\"checked\"": ""%>/>&nbsp;Enabled</label>
								<% if (PartnerConfigBean.allowConfigureProductSettings(request, productType)) { %>
								<div id="prodSet<%=productType.name()%>" style="<%=productSettings.isEnabled() ? "": "display:none;"%>">
									<%
										switch (productType) {
										case FLIGHT: {
										    FlightSettings flightSettings = (FlightSettings) productSettings;
									%>
										<div class="u_block">
											<label class="u_floatL">Airline Codes:</label>
											<div class="u_floatL">
												<input type="text" name="airlineCodes" id="airlineCodes" value="<%=ListUtility.toString(flightSettings.getAllowedCarrierCodes(), ", ")%>" class="span12"/>
												<span class="help-block">Comma separated airline codes</span>
											</div>
										</div>
									<%
										}
										break;
										case HOTEL:
										case FLIGHT_HOTEL:
										case HOLIDAY: {
									%>
										<div class="u_block">
											<label><input type="checkbox" class="checkbox" name="prodOMC<%=productType.name()%>" value="true" <%=productSettings.isIncludeAllData() ? "": "checked=\"checked\""%>/>&nbsp;Only my content</label>
										</div>
									<% 
										}
										break;
										} 
									%>
								</div>
								<% } %>
							</div>
						</dd>
					<% } %>
					<dt><label>Features</label></dt>
					<dd>
						<div class="u_block">
						<% 
							for (AppFeatureType featureType: PartnerConfigBean.getConfigurableFeatures(request)) {
							    boolean isFetaureEnabled = (partnerConfigData != null) ? partnerConfigData.getConfig().isFeatureEnabled(featureType): featureType.isDefaultEnabled();
						%>
							<label class="u_floatL" style="width:250px;"><input type="checkbox" class="checkbox" name="feature<%=featureType.name()%>" value="true" <%=isFetaureEnabled ? "checked=\"checked\"": ""%>>&nbsp;<%=featureType.getDisplayName()%></label>
						<% } %>
						</div>
					</dd>
					<dt></dt>
					<dd><a href="#" onclick="savePartnerConfig(); return false;" class="actiong">Save</a></dd>
				</dl>
			</fieldset>
		</form>
	</div>
</div>

<jsp:include page="/includes/footer.jsp" />
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ('#addUpdatePartnerForm .prodEnbl').click(function() {
		var prod = $jQ(this).data('prod');
		$jQ('#prodSet' + prod).toggle($jQ(this).is(':checked'));
	});
	checkIdentifierType();
});
function checkIdentifierType() {
	var idTyp = document.addUpdatePartnerForm.identifierType.value;
	$jQ('#addUpdatePartnerForm .prodSetCtr').toggle(idTyp == '<%=PartnerIdentifierType.DOMAIN%>');
}
function savePartnerConfig() {
	var successSave = function(a, m) {
		window.location.href = m;
	}
	AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.SAVE_PARTNER_CONFIG)%>',
		{form: 'addUpdatePartnerForm', scope: this, success: {parseMsg:true, handler: successSave}});
	return false;
}
</script>
</body>
</html>
