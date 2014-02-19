<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%
	String fileCategoryTypeStr = StringUtils.trimToEmpty(request.getParameter("file_cattyp"));
	List<ContentFileCategoryType> categoryList = (List<ContentFileCategoryType>) request.getAttribute(Attributes.FILE_CATEGORY_LIST.toString());
	Map<String, String> tagsMap = (Map<String, String>) request.getAttribute(Attributes.FILE_TAGS_MAP.toString());

	boolean isCategorySingle = (categoryList.size() == 1);
	boolean showTagsAsCheckbox = false;
	User loggedInUser = SessionManager.getUser(request);
%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.via.content.ContentFileType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.FileUploadNavigation"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.SubActions"%>
<%@page import="com.eos.b2c.ui.util.EncryptionHelper"%>
<%@page import="java.util.Map"%>
<div id="mceImageSelectorDiv" style="display:none;">
	<div id="imgUpldDiv" style="margin:10px">
		<form name="imgUploadForm" id="imgUploadForm" class="def-form boldL wideL u_vsmallF smmrgnT" method="post" enctype="multipart/form-data">
			<% if (isCategorySingle) { %><input type="hidden" name="file_category" value=""/><% } %>
			<% if (showTagsAsCheckbox) { %><input type="hidden" name="file_tags" value=""/><% } %>
			<input type="hidden" name="file_desc" value="" />
			<input type="hidden" name="file_name" value="" />
			<input type="hidden" name="file_tags" value="" />

			<div class="statement-group" style="margin-bottom:10px">
			<fieldset>

				<dd style="display:none"><select name="file_sizegrp"><% for (FileSizeGroupType sizeGroupType: FileSizeGroupType.getSizeGroupsForDestination()) { %><option value="<%=sizeGroupType.name()%>" <%=(FileSizeGroupType.RECT_2_1 == sizeGroupType)?"selected":""%>><%=sizeGroupType.getDisplayName()%></option><% } %></select></dd>			
				<p class="u_smallF">Select a file on your computer (2MB max): (Please upload a horizontal image ideally with aspect ratio 2:1)</p>
				<span id="uploadFileButton">Browse</span>
				<button style="padding:4px 10px;vertical-align:top" data-dismiss="modal">Cancel</button>
				<div id="fileUploadProgBar" class="uplProgBar"></div>
			</fieldset>

			</div>
		</form>
	</div>
	<div id="imgSearchDiv" style="display: none;">
		<div class="u_alignR"><a href="#" onclick="return ImageSelector.toggleShowLibrary();" class="t_icon t_add">Upload New</a></div>
		<form name="imgSearchForm" class="flab_form u_vsmallF smmrgnT">
			<% if (isCategorySingle) { %><input type="hidden" name="file_category" value=""/><% } %>
			<input type="hidden" name="pg" value="1"/>
			<input type="hidden" name="file_cattyp" value="<%=fileCategoryTypeStr%>"/>
			<table width="100%">
				<tr>
					<% if (!isCategorySingle) { %><td><b>Category:</b></td><td><select name="file_category"></select></td><% } %>
					<td><b>Size Group:</b></td><td><select name="file_datatyp"><% for (FileSizeGroupType sizeGroupType: FileSizeGroupType.getSizeGroupsForDestination()) { %><option value="<%=sizeGroupType.getMainFileDataType().name()%>"><%=sizeGroupType.getDisplayName()%></option><% } %></select></td>
					<td><b>Name:</b></td><td><input type="text" name="file_name"/></td>
					<td><button type="submit" class="actionb" onclick="return ImageSelector.search(1);">Search</button></td>
				</tr>
			</table>
		</form>
		<div id="imgRsltsDiv" class="u_vsmallF smmrgnT" style="border: 1px solid #666; overflow-y: auto; height: 370px; padding: 5px;"></div>
		<div id="imgRsltsPgDiv" class="u_vsmallF"></div>
	</div>
</div>
<script type="text/javascript">
var ImageSelector = new function() {
	var me = this;
	var sizeGrpO = <%=FileSizeGroupType.getFileDataTypesJSON()%>;
	var uploadImg = null;
	this.tgt = null; this.iframeSel = false; this.tmpltSelect = true;
	this.init = function() {
		uploadImg = new UploadImg({swfuversion: '<%=StaticFileVersions.SWF_UPLOAD_VERSION%>', uploadURL: '<%=FileUploadNavigation.getFileUploadBaseURL(request) %>',
			params: {'creator_id': '<%=loggedInUser.getId()%>', 'file_type': '<%=ContentFileType.IMAGE%>', 'action1': '<%=FileUploadNavigation.UPLOAD_CONTENT_FILE_ACTION%>'},
			fileNameId: null, swfSetting: {}, success: {handler: this.successUploadImg}, before: {handler: this.setUploadParams}});
		uploadImg.showUpload();
		this.populateCategory(document.imgUploadForm.file_category, false);
		this.populateCategory(document.imgSearchForm.file_category, true);
	}
	this.showSelector = function(tgt, iframeSel, tmpltSelect, szGrp) {
		this.tgt=tgt; this.iframeSel=iframeSel; this.tmpltSelect=tmpltSelect;
		if (szGrp) {
			JS_UTIL.setSelectBoxByText(document.imgUploadForm.file_sizegrp, szGrp);
			JS_UTIL.setSelectBoxByText(document.imgSearchForm.file_datatyp, szGrp);
		}
		MODAL_PANEL.show('#mceImageSelectorDiv', {title: 'Image Selector', blockClass: 'lgnRgBlk'});
		return false;
	}
	this.toggleShowLibrary = function() {
		$jQ("#imgUpldDiv").toggle();
		$jQ("#imgSearchDiv").toggle();
		return false;
	}
	this.search = function(pg) {
		if (pg) document.imgSearchForm.pg.value=pg;
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.FILEMANAGE, SubActions.FileManagerAction.SEARCH_X)%>', 
			{scope: this, params: $jQ(document.imgSearchForm).serialize(), wait: {msg: 'Loading results ...', blkEl: "#imgRsltsDiv"},
				success: {handler: this.successResultsLoaded}});
		return false;
	}
	this.successResultsLoaded = function(args, msg, xml, o) {
		var data = JS_UTIL.parseJSON($jQ(xml).text());
		var resA = data.res, pg = data.page;
		var resD = $jQ("#imgRsltsDiv").html(""), pgD = $jQ("#imgRsltsPgDiv");
		$jQ(resA).each(function(i, resO) {
			var res = $jQ('<div class="u_floatL" style="padding: 0 8px 8px 0; min-height: 120px;">').append('<div><a href="#"><img src="'+resO.url+'" width="100" style="border: 1px solid #999;"/></a>');
			res.append('<div><a href="#" class="u_lnc"><b>'+resO.name+'</b></a><br/>('+resO.cat+')</div>');
			$jQ("a", res).attr("title", resO.desc).click(function() {me.selectFile(resO)});
			resD.append(res);
		});
		pgD.html('<div class="u_block"><div class="u_floatL">Total '+pg.ttl+' found</div>'+'<div class="u_floatR">'+(pg.num>0?'<a href="#" class="u_lnc prevA">&laquo; Prev</a> ':'')+(pg.num<pg.lst?'<a href="#" class="u_lnc nextA">Next &raquo;</a>':''));
		$jQ("a", pgD).click(function() {
			var pg = parseInt(document.imgSearchForm.pg.value);
			document.imgSearchForm.pg.value=$jQ(this).hasClass("prevA")?pg-1:pg+1;
			me.search();
		});
	}
	this.populateCategory = function(sElm, all) {
		<% if (isCategorySingle) { %>
			$jQ(sElm).val('<%=categoryList.get(0).name()%>');
		<% } else { %>
			$jQ(sElm).html((all?'<option value="">All</option>':'')+'<% for (ContentFileCategoryType fileCategory: categoryList) { %><option value="<%=fileCategory.name()%>"><%=fileCategory.getDisplayString()%></option><% } %>');
		<% } %>
	}
	this.setUploadParams = function(prms) {
		prms['file_name']='';
		prms['file_desc']='';
		prms['file_wm']='true';
		prms['file_tags']='';
		prms['file_category_type']='<%=categoryList.get(0).name()%>';
		var dataA = sizeGrpO['<%=FileSizeGroupType.RECT_2_1.name()%>'];
		for (var i=0; i<dataA.length; i++) {
			prms['dataType'+dataA[i]]="true";
		}
		return prms;
	}
	this.successUploadImg = function(rsp) {
		var aO = JS_UTIL.parseJSON(rsp);
		aO["desc"]=document.imgUploadForm.file_desc.value;
		me.selectFile(aO);
	}
	this.selectFile = function(imgO) {
		if (this.iframeSel) {
			var iw = $jQ(".mceWrapper iframe").get(0).contentWindow;
			$jQ("#" + this.tgt, iw.document).val(imgO.url);
			$jQ("#" + this.tgt, iw.document).change();
		} else {
			$jQ("#"+this.tgt).val(this.tmpltSelect?imgO.turl:imgO.url);
			$jQ("#pvw"+this.tgt).html('<img src="'+imgO.url+'" width="150"/>');
		}
		MODAL_PANEL.hide();
	}
}
$jQ(document).ready(function() {
	ImageSelector.init();
});
</script>