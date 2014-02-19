<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());

	User loggedInUser = SessionManager.getUser(request);
	PartnerConfigData partnerConfigData = (PartnerConfigData) request.getAttribute(Attributes.PARTNER_CONFIG_DATA.toString());
	String template = "";
	String fbKey = "";
	String fbSecret = "";
	if(partnerConfigData != null) {
		template = partnerConfigData.getConfig().getSettingValue(AppSettingType.TEMPLATE_NAME);
		fbKey = StringUtils.trimToEmpty(partnerConfigData.getConfig().getSettingValue(AppSettingType.FB_API_KEY));
		fbSecret = StringUtils.trimToEmpty(partnerConfigData.getConfig().getSettingValue(AppSettingType.FB_API_SECRET));
		if(fbKey.equals("741549982538163")) {
			fbKey = "";
		}
		if(fbSecret.equals("6d52fd8814e63c28af97d220aea01ec1")) {
			fbSecret = "";
		}
	}
%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.poc.server.settings.ProductSettings"%>
<%@page import="com.poc.server.settings.FlightSettings"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.settings.AppFeatureType"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.widget.WidgetBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.poc.server.settings.AppSettingType"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.eos.b2c.ui.FileUploadNavigation"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFileManager"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.via.content.ContentFileType"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<html>
<head>
<title>Manage Configuration Profile</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.SWF_UPLOAD_JS, null)%>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.UPLOAD_UTILS_JS, null)%>
</head>
<body>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<% if(loggedInUser.getRoleType() == RoleType.AIRLINE) { %>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
	<jsp:param name="selectedSideNav" value="website" />
	<jsp:param name="selectNav" value="website" />
	<jsp:param name="hideSidebar" value="true" />
</jsp:include>
<% } else { %>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
	<jsp:param name="selectedSideNav" value="website" />
	<jsp:param name="selectNav" value="website" />
</jsp:include>
<% } %>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Your Website Settings</h5>
	<div style="margin-bottom:10px">
	An example of a live website is here: <a target="_blank" href="http://www.anirudhtravels.com">www.anirudhtravels.com</a>
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.SAVE_CONFIGURE_PROFILE)%>" method="post">
		<input type="hidden" name="destid" value="-1" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<% if (partnerConfigData != null) { %>
				<div class="control-group">
					<label class="control-label">Your website is live:</label>
					<div class="controls"><a target="_blank" href="http://<%=(partnerConfigData != null) ? PartnerConfigManager.getSubdomainIdentifier(partnerConfigData): ""%>.tripfactory.com"><%=(partnerConfigData != null) ? PartnerConfigManager.getSubdomainIdentifier(partnerConfigData): ""%>.tripfactory.com</a></div>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label">Enter your sub-domain:</label>
					<div class="controls"><input type="text" name="subdomain" id="subdomain" value="<%=(partnerConfigData != null) ? PartnerConfigManager.getSubdomainIdentifier(partnerConfigData): ""%>" class="span12" style="width:400px" />&nbsp;<%=Constants.SUBDOMAIN_SUFFIX%></div>
					<div class="controls" style="margin-top:10px">
						To check your live website, please email <b>partners@tripfactory.com</b> with your subdomain to make the website live. We take 3-4 hours before it goes live. 
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Enter your website:</label>
					<div class="controls"><input type="text" name="websiteURL" id="websiteURL" value="<%=(partnerConfigData != null) ? StringUtils.trimToEmpty(partnerConfigData.getConfig().getSettingValue(AppSettingType.WEBSITE_URL)): ""%>" class="span12" style="width:400px" />&nbsp;(e.g: www.tripfactory.com)</div>
					<div class="controls" style="margin-top:10px">
						To map your own domain to your website, please follow these steps:
						<ul>
							<li><b>1.</b> Add a CNAME record for your domain in your domain control panel to the following entry: <b>poc-pb-1048239211.ap-southeast-1.elb.amazonaws.com</b></li>
							<li><b>2.</b> Please send a email request to <b>partners@tripfactory.com</b> with your domain name to make the website live on your domain. We usually take 3-4 hours to make the website live.</li>
						</ul>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Your Logo:</label>
					<div class="controls u_block">
						<div class="u_floatL">
							<img src="<%=PartnerConfigBean.getPartnerConfigLogoURL(request, partnerConfigData)%>" width="96" id="logoPic"/>
						</div>
						<div style="margin-left:115px;">
							<p><b>Upload Your Logo</b></p>
							<p class="u_smallF">Select an image file (only jpg or gif files) on your computer (2MB max):</p>
							<div>
								<input type="hidden" name="logo_filename" id="logo_filename" readonly="true" value="<%=(partnerConfigData != null) ? StringUtils.trimToEmpty(partnerConfigData.getConfig().getSettingValue(AppSettingType.LOGO_URL)): ""%>" style="margin-bottom: 7px;"/>&nbsp;<span id="uploadFileButton">Browse</span>
							</div>
							<div id="fileUploadProgBar" class="uplProgBar"></div>
						</div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Choose a template:</label>
					<div class="controls u_block">
						<div class="u_floatL">
							<img src="http://images.tripfactory.com/static/img/templates/template1.jpg" style="width:120px" />&nbsp;
							<input type="radio" name="template" value="touroperator" <%=(template.equals("touroperator")?"checked":"")%> />
						</div>
						<div class="u_floatL" style="margin-left:20px">
							<img src="http://images.tripfactory.com/static/img/templates/template2.jpg" style="width:120px" />&nbsp;
							<input type="radio" name="template" value="touroperator2" <%=(template.equals("touroperator2")?"checked":"")%> />
						</div>
						<div class="u_floatL" style="margin-left:20px">
							<img src="http://images.tripfactory.com/static/img/templates/template3.jpg" style="width:120px" />&nbsp;
							<input type="radio" name="template" value="touroperator4" <%=(template.equals("touroperator4")?"checked":"")%> />
						</div>
					</div>
				</div>				
				<%
					for (ViaProductType productType: PartnerConfigBean.getProductsToConfigureSettings(request)) {
						ProductSettings productSettings = SettingsController.getInstance(partnerConfigData).getProductSettings(productType);
						if(productType == ViaProductType.FLIGHT_HOTEL || productType == ViaProductType.FLIGHT) {
							continue;
						}
				%>
				<div class="control-group">
					<label class="control-label"><%=productType.getPromotionalText()%>:</label>
					<div class="controls">
						<label><input type="checkbox" name="prodE<%=productType.name()%>" class="prodEnbl" data-prod="<%=productType.name()%>" value="true" <%=productSettings.isEnabled() ? "checked=\"checked\"": ""%>/>&nbsp;Enabled</label>
						<% if (PartnerConfigBean.allowConfigureProductSettings(request, productType)) { %>
						<div id="prodSet<%=productType.name()%>" style="<%=productSettings.isEnabled() ? "": "display:none;"%>">
							<%
								switch (productType) {
								case FLIGHT: {
								    FlightSettings flightSettings = (FlightSettings) productSettings;
							%>
								<div class="control-group" style="display:none">
									<label class="control-label">Airline Codes:</label>
									<div class="controls">
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
								<div class="control-group">
									<label><input type="checkbox" name="prodOMC<%=productType.name()%>" value="true" <%=productSettings.isIncludeAllData() ? "": "checked=\"checked\""%>/>&nbsp;Only my content</label>
								</div>
							<% 
								}
								break;
								} 
							%>
						</div>
						<% } %>
					</div>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label"></label>
					<div class="controls" style="margin-top:10px">
						To enable facebook login on your website, please provide the below details:
					</div>
				</div>			
				<div class="control-group">
					<label class="control-label">Facebook API Key:</label>
					<div class="controls"><input type="text" name="fbAPI" id="fbAPI" value="<%=fbKey%>" class="span12" style="width:400px" />&nbsp;</div>
					<div class="controls" style="margin-top:10px">
						To get the Facebook API Key and Secret, please follow the steps in this <a href="http://infoheap.com/facebook-app-for-fconnect-website-login/" target="_blank">link</a>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Facebook API Secret:</label>
					<div class="controls"><input type="text" name="fbSecret" id="fbSecret" value="<%=fbSecret%>" class="span12" style="width:400px" />&nbsp;</div>
				</div>				
				<div class="control-group" style="display:none">
					<label class="control-label">Features:</label>
					<div class="controls u_block">
					<% 
						for (AppFeatureType featureType: PartnerConfigBean.getConfigurableFeatures(request)) {
						    boolean isFetaureEnabled = (partnerConfigData != null) ? partnerConfigData.getConfig().isFeatureEnabled(featureType): featureType.isDefaultEnabled();
					%>
						<label class="u_floatL" style="width:250px;"><input type="checkbox" name="feature<%=featureType.name()%>" value="true" <%=isFetaureEnabled ? "checked=\"checked\"": ""%>>&nbsp;<%=featureType.getDisplayName()%></label>
					<% } %>
					</div>
				</div>
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Update Settings</button>
				</div>
				<% if (partnerConfigData != null) { %>
					<div class="control-group">
						<label class="control-label">Embed Search Box:</label>
						<div class="controls">
							<textarea rows="5" cols="100">
								<%=StringEscapeUtils.escapeHtml(WidgetBean.getEmbedCodeForSearchBox(request))%>
							</textarea>
						</div>
					</div>
				<% } %>						
				</div>
			</div>
			<!-- /HTML5 inputs -->
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
var uploadImg = null;
$jQ(document).ready(function() {
	$jQ('.prodEnbl').click(function() {
		var prod = $jQ(this).data('prod');
		$jQ('#prodSet' + prod).toggle($jQ(this).is(':checked'));
	});
	$jQ(".styled").uniform({ radioClass: 'choice' });
	uploadImg = new UploadImg({swfuversion: '<%=StaticFileVersions.SWF_UPLOAD_VERSION%>', uploadURL: '<%=FileUploadNavigation.getFileUploadBaseURL(request)%>', uploadDiv: null,
		params: {creator_id: '<%=loggedInUser.getUserId()%>', 'file_type': '<%=ContentFileType.IMAGE%>', file_category_type: '<%=ContentFileCategoryType.PARTNER%>', file_sizegroup:'<%=FileSizeGroupType.WL_LOGO.name()%>', action1: '<%=FileUploadNavigation.UPLOAD_CONTENT_FILE_ACTION%>'}, swfSetting: {}, success: {handler: successUploadLogo}});
	uploadImg.showUpload();
});
function successUploadLogo(rsp) {
	var aO = JS_UTIL.parseJSON(rsp);
	$jQ("#logoPic").attr("src", aO.url);
	$jQ("#logo_filename").val(aO.turl);
}
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
