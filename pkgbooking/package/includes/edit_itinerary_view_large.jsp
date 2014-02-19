<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryBean"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryStep"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageItineraryTemplate"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryDescription"%>
<%@page import="com.poc.server.secondary.database.model.DestinationRoute"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	Map<String, PackageItineraryTemplate> pkgItnTplsByCity = (Map<String, PackageItineraryTemplate>) request.getAttribute(Attributes.ITINERARY_TEMPLATES.toString());
	List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();
	boolean showItnEditControls = true;
	String addItnItemURL = ItineraryBean.getItinearyItemAddURL(request, pkgConfig);

	ContentWorkItem workItem = (ContentWorkItem) request.getAttribute(Attributes.CONTENT_WORK_ITEM.toString());
	boolean showAdvanceEditOptions = (workItem != null || loggedInUser.getRoleType() == RoleType.CALLCENTER);
%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="java.util.Map"%>
<%@page import="com.poc.server.secondary.database.model.ContentWorkItem"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.eos.b2c.ui.FileUploadNavigation"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.b2c.util.image.ImageData"%>
<%@page import="com.via.content.FileDataType"%>
<style type="text/css">
.itnItmCtr .item {float:left;}
.itnItmCtr .slot {float:left; margin-left:8px;}
.itnItmCtr .actions {float:left;margin-left:0;}
#pkgImg {width:300px;}
#pkgImg h3 {margin:0; padding:5px 0; font-size:13px; font-weight:bold;}
.pkgImgCtr {padding:0 0 5px; position:relative;}
.itnDayImg {position:relative; margin-right:10px; padding:5px 0;}
.itnDayImgCtr .bkClose, .pkgImgCtr .bkClose {display:none; top:-14px; right:-14px;}
.itnDayImgCtr .imgActive .bkClose, .pkgImgCtr.imgActive .bkClose {display:block;}
</style>
<div class="u_block">
<div id="pkgImg" class="u_floatL one-half">
	<h3>Itinerary Image (only .jpg or .gif files):</h3>
	<div class="pkgImgCtr u_floatL"></div>
	<div class="u_clear"><span id="uploadFileButton">Browse</span></div>
	<div id="fileUploadProgBar" class="uplProgBar"></div>
</div>
<% if(StringUtils.isNotBlank(pkgConfig.getPackageDesc(false))) { %>
<article class="one-half" style="padding-bottom:0;padding-top:15px"><p class="mrgnT" style="margin:0;padding:0">
<%=pkgConfig.getPackageDesc(false)%>
</p></article>
<% } %>
</div>
<div id="pkgItnV<%=pkgConfig.getId()%>" class="tab-content">
<%
	int count = 1;
	int currCity = -1;
	int cityCount = 0;
	int pkgDay = 0;
	int lastCityId = -1;
	PackageItineraryTemplate template = null;
	for (CityConfig day : cityConfigs) { 
		currCity = day.getCityId();
		String cityConfigKey = pkgConfig.getCityKeyForCityConfig(day);
		template = pkgItnTplsByCity.get(cityConfigKey);
		
		// last city has one extra day
		int numNights = day.getTotalNumNights();
		if (cityCount == cityConfigs.size() - 1) {
		    numNights++;
		}
		for (int j = 1; j <= numNights; j++) { 
			int cnt = 0;
			pkgDay = count;
			ItineraryDescription desc = null;
			if(template != null) {
				desc = template.getItineraryDescriptionForDay(j);
			}
			
			String itnDayKey = pkgDay + cityConfigKey;
%>
<article id="itnCtr<%=itnDayKey%>" class="locations" style="margin-bottom:10px;padding:5px 0">
	<h1 style="font-size:15px">Day <%=count%>: 
		<span id="itnDatTtl<%=itnDayKey%>"><%=(desc != null && StringUtils.isNotBlank(desc.getDayTitle()))?desc.getDayTitle():""%></span>
		<a href="#" style="font-size:12px;font-weight:normal" onclick="ITMMKR.showDayUpdate('<%=cityConfigKey%>', <%=pkgDay%>); return false;">Edit</a>
		<a href="#" style="<%=showAdvanceEditOptions ? "": "display:none;"%>font-size:12px;font-weight:normal;float:right" onclick="addPlace(<%=currCity%>,'');return false;">Add new place in this city</a>
	</h1>
	<% if (desc != null && StringUtils.isNotBlank(desc.getDaySchedule())) { %>
	<p id="itnDayDsc<%=itnDayKey%>" class="itnmrgn10B"><%=desc.getDaySchedule()%></p>
	<% } %>
	<div id="itnDayImg<%=itnDayKey%>">
		<div class="itnDayImgCtr u_block"></div>
		<div class="padTB u_smallF">
			<div><b>Add an Image: </b><span id="uploadFileButton<%=itnDayKey%>">Browse</span></div>
			<div id="fileUploadProgBar<%=itnDayKey%>" class="uplProgBar"></div>
		</div>
	</div>
	<div style="<%=showAdvanceEditOptions ? "": "display:none;"%>">
	<%
		for (ActivityTimeSlot timeSlot : ActivityTimeSlot.getTimeSlotInChronologicalOrder()) {		
	%>
	<h1 style="font-size:13px"><%=timeSlot.getDisplayText()%></h1>
	<div id="itnDaySlotCtr<%=timeSlot.name()%><%=count%><%=cityConfigKey%>">
	<% 
		if(template != null) {
			List<ItineraryStep> steps = template.getItinerarySteps();
			for(ItineraryStep step : steps) {
				if(step.getDay() == j && step.getTimeSlot() == timeSlot) {
				request.setAttribute(Attributes.PACKAGE_DAY_ACTIVITY.toString(), step);
	%>
		<jsp:include page="edit_itinerary_step.jsp">
			<jsp:param name="cKy" value="<%=cityConfigKey%>"/>
			<jsp:param name="day" value="<%=pkgDay%>"/>
		</jsp:include>		
	<% } } } %>
	</div>
	<div class="<%=count%>day">
		<article style="padding:0">
			<div class="text-wrap">
				<div id="addItnItemAct<%=timeSlot.name()%><%=count%>"><a href="#" class="t_icon t_add" style="font-size:1.2em;color:#008BDA">Add a New Experience to this Day</a></div>			
			</div>
		</article>
		<div class="clearfix"></div>
	</div>	
	<script type="text/javascript">
	var itmSel<%=timeSlot.name()%><%=count%> = null;
	$jQ(document).ready(function() {
		itmSel<%=timeSlot.name()%><%=count%> = new ItnItemSelector({ctrDiv:$jQ('#addItnItemAct<%=timeSlot.name()%><%=count%>'), sltsG:['<%=timeSlot.name()%>'], showSlt:false, askCmt:true, acOps: {extraParams:{cIds:'<%=currCity%><%=(lastCityId > 0 && j == 1) ? "," + lastCityId: ""%>'}},
			addOps: {url:'<%=addItnItemURL%>', prms:{cKy:'<%=cityConfigKey%>', day:<%=pkgDay%>, createMode:true}, afterHdlr:function(dO) {$jQ('#itnDaySlotCtr<%=timeSlot.name()%><%=count%><%=cityConfigKey%>').append(dO.htm);} }});
	});
	</script>
	<% 
		}
	%>
	</div>
<script type="text/javascript">
$jQ(document).ready(function() {
	var itnPrms = {pkgId:<%=pkgConfig.getId()%>, day:<%=pkgDay%>, cKy:'<%=cityConfigKey%>'};
	var uploadImg = new UploadImg({swfuversion: '<%=StaticFileVersions.SWF_UPLOAD_VERSION%>', uploadURL: '<%=FileUploadNavigation.getFileUploadBaseURL(request)%>', uploadDiv: null, swfSetting: {button_placeholder_id:'uploadFileButton<%=itnDayKey%>'}, custom_settings: {progressTarget:'fileUploadProgBar<%=itnDayKey%>'},
		params: {creator_id:'<%=loggedInUser.getUserId()%>', pkgId:'<%=pkgConfig.getId()%>', day:'<%=pkgDay%>', cKy:'<%=cityConfigKey%>', action1: '<%=FileUploadNavigation.UPLOAD_ITINERARY_PIC_ACTION%>'}, success: {handler: function(m) {ITMMKR.successItnImgUpload(m, itnPrms, false);}}});
	uploadImg.showUpload();
	<% if (desc != null) { %>
		ITMMKR.renderItnImgs(<%=ImageData.toDisplayJSON(desc.getImageURLs(), FileDataType.I200X150)%>, itnPrms);
	<% } %>
});
</script>
</article>
<% 
		count++;
		}
		cityCount++;
		lastCityId = day.getCityId();
	} 
%>
<script type="text/javascript">
$jQ(document).ready(function() {
	var itnPrms = {pkgId:<%=pkgConfig.getId()%>};
	var uploadImg = new UploadImg({swfuversion: '<%=StaticFileVersions.SWF_UPLOAD_VERSION%>', uploadURL: '<%=FileUploadNavigation.getFileUploadBaseURL(request)%>', uploadDiv: null, swfSetting: {button_placeholder_id:'uploadFileButton'}, custom_settings: {progressTarget:'fileUploadProgBar'},
		params: {creator_id:'<%=loggedInUser.getUserId()%>', pkgId:'<%=pkgConfig.getId()%>', action1: '<%=FileUploadNavigation.UPLOAD_ITINERARY_PIC_ACTION%>'}, success: {handler: function(m) {ITMMKR.successItnImgUpload(m, itnPrms, true);}}});
	uploadImg.showUpload();
	ITMMKR.renderPkgImg(<%=StringUtils.isNotBlank(pkgConfig.getMainImageURL()) ? (new ImageData(pkgConfig.getMainImageURL())).toDisplayJSON(FileDataType.I200X100).toString(): "{}"%>, itnPrms);
});
</script>
<jsp:include page="/package/includes/package_itn_edit_js.jsp"/>
</div>