<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryBean"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	boolean showItnEditControls = ItineraryBean.isItineraryEditAllowed(request, pkgConfig);

	boolean showPlaceSearchBox = false; //UIHelper.isSystemUser(request);
%>
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.SubActions.PlacesAction"%>
<%@page import="com.eos.b2c.ui.action.TripAction"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<div id="itnDayDetailsUpdateDiv" style="display:none;">
	<form name="itnDayDetailsUpdateForm" id="itnDayDetailsUpdateForm" class="def-form wideL boldL" onsubmit="ITMMKR.updateDayDetails(); return false;">
		<input type="hidden" name="pkgId" value="<%=pkgConfig.getId()%>"/>
		<input type="hidden" name="day" value="-1"/>
		<input type="hidden" name="cKy" value=""/>
		<fieldset>
			<dl>
				<dt style="padding:10px 0"><label style="font-size:12px"><b>Day Title</b></label></dt>
				<dd style="margin-top:5px"><input type="text" name="title" value="" style="width:400px" /></dd>
				<dt style="padding:10px 0"><label style="font-size:12px"><b>Day Description</b></label></dt>
				<dd style="margin-top:5px"><textarea name="desc" rows="5" cols="50" style="width:400px"></textarea></dd>
				<div class="clearfix"></div>
				<dd style="margin-top:5px"><button type="submit" class="search-button">Save Day Information</button></dd>
			</dl>
		</fieldset>		
	</form>
</div>
<script type="text/javascript">
var ITMMKR = new function() {
	var me = this; this.itnRcJ = null;
	this.init = function() {
		var sltsG = <%=ActivityTimeSlot.toJSONArray(ActivityTimeSlot.values())%>;
	}
	<% if (showItnEditControls) { %>
	this.addItem = function(iId, slt, prmsO, el) {
		var successSaved = function(a, m, x) {
			var prntEl = $jQ(el).parents('.itnPlcStp');
			if (prntEl && prntEl.length > 0) {prntEl.after(m);}
			else {$jQ('#itnPlcLst'+prmsO.day).append(m);}
			$jQ(el).parent('.plcTrpAddAct').html('<b class="signSmIc tckSmIc">Added to Trip</b>');
		}
		var prms = $jQ.extend(prmsO, {id:iId, slt:slt, showAdd:true, showRecommendations:true, showCollect:false});
		AJAX_UTIL.asyncCall('<%=ItineraryBean.getItinearyItemAddURL(request, pkgConfig)%>', 
			{params: $jQ.param(prms), scope: this,
				wait: {inDialog:false, divEl:$jQ(el).parent('.plcTrpAddAct')},
				success: {handler: successSaved, parseMsg:true}
			});
	}
	this.loadRecommendations = function(cKy, day, slt, iId, el) {
		var prms = {cKy:cKy, day:day, slt:slt, id:iId};
		var successSaved = function(a, m, x) {
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			me.itnRcJ = $jQ('<div>' + rspO.htm + '</div>');
			me.showRecommendations(prms);
		}
		AJAX_UTIL.asyncCall('<%=TripBean.getItinearyLoadRecommendationsURL(request, pkgConfig)%>', 
			{params: $jQ.param(prms), scope: this,
				wait: {inDialog:false, msg:'Loading Recommendations...', divEl:$jQ(el).parent()},
				success: {handler: successSaved}
			});
	}
	this.loadCollectRecommendations = function(cKy, day, el) {
		var prms = {cKy:cKy, day:day};
		var successSaved = function(a, m, x) {
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			var itnRcJ = $jQ('<div>' + rspO.htm + '</div>');
			$jQ('.add', itnRcJ).click(function() {
				me.addItem($jQ(this).data('product-id'), $jQ(this).data('product-slot'), prms, this);
			});
			$jQ('#itnReco'+prms.cKy+prms.day).html(itnRcJ).show();
		}
		AJAX_UTIL.asyncCall('<%=TripBean.getItinearyLoadCollectionRecommendationsURL(request, pkgConfig)%>', 
			{params: $jQ.param(prms), scope: this,
				wait: {inDialog:false, msg:'Loading Shortlist...', divEl:$jQ(el).parent()},
				success: {handler: successSaved}
			});
	}
	this.showRecommendations = function(prms) {
		if (!me.itnRcJ) return;
		<% if (showPlaceSearchBox) { %>
		$jQ('#plcSearchForm', me.itnRcJ).submit(function() {
			me.searchPlaces();
			return false;
		});
		<% } %>
		$jQ('.add', me.itnRcJ).click(function() {
			me.addItem($jQ(this).data('product-id'), $jQ(this).data('product-slot'), prms, this);
		});
		$jQ('#itnReco'+prms.cKy+prms.day+(prms.id ? prms.id: '')).html(me.itnRcJ).show();
	}
	this.removeItem = function(cKy, day, iId, slt) {
		var x = window.confirm('Are you sure you want to remove this from the itinerary?');
		if (!x) return;
		var successSaved = function(a, m, x) {
			$jQ('#itnStp'+day+slt+iId).remove();
		}
		var prms = {cKy:cKy, day:day, id:iId, slt:slt};
		AJAX_UTIL.asyncCall('<%=ItineraryBean.getItinearyItemRemoveURL(request, pkgConfig)%>', 
			{params: $jQ.param(prms), scope: this,
				wait: {inDialog:false},
				success: {handler: successSaved}
			});
	}
	this.removeDay = function(cKy, day) {
		if (!window.confirm('Are you sure you want to remove this day from the trip?')) return;
		var successSaved = function(a, m, x) {
			me.successLoadTrip(x);
			MODAL_PANEL.hide();
		}
		var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy, day:day, showAdd:true, showCollect:false, showRecommendations:true};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_REMOVE)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved} });
	}
	this.addDay = function(cKy) {
		var successSaved = function(a, m, x) {
			me.successLoadTrip(x);
			MODAL_PANEL.hide();
		}
		var prms = {pkgId:<%=pkgConfig.getId()%>, cKy:cKy, showAdd:true, showCollect:false, showRecommendations:true};
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE_ADD)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved} });
	}
	this.successLoadTrip = function(x) {
		var rspO = JS_UTIL.parseJSON($jQ(x).text());
		$jQ('#pkgItnV<%=pkgConfig.getId()%>').replaceWith(rspO.htm);
	}
	this.showDayUpdate = function(cKy, day) {
		document.itnDayDetailsUpdateForm.cKy.value = cKy;
		document.itnDayDetailsUpdateForm.day.value = day;
		$jQ(document.itnDayDetailsUpdateForm.title).val($jQ('#itnDatTtl'+day+cKy).text());
		$jQ(document.itnDayDetailsUpdateForm.desc).val($jQ('#itnDayDsc'+day+cKy).text());
		MODAL_PANEL.show('#itnDayDetailsUpdateDiv', {blockClass:'wdBlk2', title:'Update Day Title'});
	}
	this.updateDayDetails = function() {
		var successSaved = function(a, m) {
			var cKy = document.itnDayDetailsUpdateForm.cKy.value;
			var day = document.itnDayDetailsUpdateForm.day.value;
			$jQ('#itnDatTtl'+day+cKy).text(document.itnDayDetailsUpdateForm.title.value);
			var dscJ = $jQ('#itnDayDsc'+day+cKy);
			if (dscJ.length == 0) {dscJ = $jQ('<p id="itnDayDsc'+day+cKy+'" class="itnmrgn10B"></p>'); $jQ('#itnCtr'+day+cKy+' h1:eq(0)').after(dscJ);}
			dscJ.text(document.itnDayDetailsUpdateForm.desc.value);
			$jQ('.notification').show();
			MODAL_PANEL.hide();
		}
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.ITN_DAY_TITLE_UPDATE)%>', 
			{form: 'itnDayDetailsUpdateForm', scope: this, success: {handler: successSaved} });
	}
	this.renderPkgImg = function(imgO, prms) {
		var iCtr = $jQ('#pkgImg .pkgImgCtr').html('');
		var hasImg = !!imgO.url;
		iCtr.append('<div><img src="'+(hasImg?imgO.url:'/static/img/photos/no_photo_200x150.jpg')+'"/></div>');
		if (hasImg) {
			iCtr.append($jQ('<div class="bkClose">').click(function() {
				if(!window.confirm('Are you sure you want to remove this image?')) return false; me.removeItnImg(imgO, prms); return false;
			}));
		}
		iCtr.hover(function() {$jQ(this).toggleClass('imgActive');})
	}
	this.renderItnImgs = function(imgA, prms) {
		if (!imgA || imgA.length == 0) return;
		for (var i=0;i<imgA.length;i++) {
			me.renderItnImg(imgA[i], prms);
		}
	}
	this.renderItnImg = function(imgO, prms) {
		var iCtr = $jQ('#itnDayImg'+prms.day+prms.cKy+' .itnDayImgCtr');
		var imgId = JS_UTIL.keepAlphaNumeric(imgO.url.toLowerCase());
		var iJ = $jQ('#itnImg'+imgId), newImg = true;
		if (iJ.length > 0) {iJ.html(''); newImg = false;}
		else {iJ = $jQ('<div class="itnDayImg u_floatL">').attr("id", "itnImg"+imgId);}
		iJ.append('<div><img src="'+imgO.url+'"/></div>');
		iJ.append('<div class="imgCap padTB"><span class="u_smallF">'+(imgO.cap?imgO.cap:'')+'</span></div>');
		iJ.append('<div class="imgActs"><a href="#" class="editCapA">Edit Caption</a></div>');
		iJ.append($jQ('<div class="bkClose">').click(function() {
			if(!window.confirm('Are you sure you want to remove this image?')) return false; me.removeItnImg(imgO, prms); return false;
		}));
		$jQ('a.editCapA', iJ).click(function() {
			var cJ = $jQ('<div class="u_block">').append('<input type="text" name="imgCaption" class="u_floatL" style="font-size:11px; width:125px;"/>');
			cJ.append('<a href="#" class="button rounded u_floatL">Save</a>');
			$jQ('a', cJ).click(function() {
				me.updateItnImgCaption($jQ('input', cJ).val(), imgO, prms);
				return false;
			});
			if (imgO.cap) {$jQ('input', cJ).val(imgO.cap);}
			$jQ('.imgCap', iJ).html(cJ); $jQ('.imgActs', iJ).hide();
			$jQ('input', cJ).focus();
			return false;
		});
		iJ.hover(function() {$jQ(this).toggleClass('imgActive');})
		if (newImg) {iCtr.append(iJ);}
	}
	this.updateItnImgCaption = function(cap, imgO, prms) {
		var successSaved = function(a, m) {
			imgO.cap = cap;
			me.renderItnImg(imgO, prms);
			MODAL_PANEL.hide();
		}
		prms.img = imgO.turl; prms.imgCaption = cap;
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.ITN_IMAGE_CAPTION_UPDATE)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved} });
	}
	this.removeItnImg = function(imgO, prms) {
		var successSaved = function(a, m) {
			if (prms.cKy) {
				imgId = JS_UTIL.keepAlphaNumeric(imgO.url.toLowerCase());
				$jQ('#itnImg'+imgId).remove();
			} else {
				me.renderPkgImg({}, prms);
			}
			MODAL_PANEL.hide();
		}
		prms.img = imgO.turl;
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.ITN_IMAGE_DELETE)%>', 
			{params: $jQ.param(prms), scope: this, success: {handler: successSaved} });
	}
	this.successItnImgUpload = function(rsp, prms, isPkg) {
		var aO = JS_UTIL.parseJSON(rsp);
		if (isPkg) {me.renderPkgImg(aO, prms);}
		else {me.renderItnImg(aO, prms);}
	}
	<% if (showPlaceSearchBox) { %>
	this.searchPlaces = function() {
		var successSearch = function(a, m, x) {
			if (!me.itnRcJ) return;
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			$jQ('.placeRecCtr', me.itnRcJ).hide();
			$jQ('.placeRsltCtr', me.itnRcJ).html('<div class="locations clearfix">'+rspO.htm+'</div>');
			var addTrpJ = $jQ('<div><span class="plcTrpAddAct"><a href="#" class="t_icon t_add">Add to Trip</a></span></div>');
			$jQ('a', addTrpJ).click(function() {
				ITMMKR.addItem($jQ(this).parents('.details').find('h1 a').data('product-id'), this);
				return false;
			});
			$jQ('article .details', me.itnRcJ).append(addTrpJ);
		}
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PLACES, PlacesAction.SEARCH_PLACES)%>?showShortView=true', 
			{form: 'plcSearchForm', scope: this,
				wait: {inDialog:false},
				success: {handler: successSearch}
			});
	}
	<% } %>
	<% if (ItineraryBean.isItineraryAdvanceControlAllowed(request, pkgConfig)) { %>
	this.toggleItemOptional = function(cKy, day, iId, slt) {
		var successSaved = function(a, m, x) {
			$jQ('#itnStp'+day+slt+iId+' .tgOptAct').replaceWith('<span><b>'+m+'</b></span>');
		}
		var prms = {cKy:cKy, day:day, id:iId, slt:slt};
		AJAX_UTIL.asyncCall('<%=ItineraryBean.getItinearyItemToggleOptionalURL(request, pkgConfig)%>', 
			{params: $jQ.param(prms), scope: this, wait: {inDialog:false}, success: {handler: successSaved, parseMsg:true}	});
	}
	<% } %>
	<% } %>
};

function ItnItemSelector(opts) {
	var defaults = {ctrDiv:null, itemDiv:null, slotDiv:null, acOps: {selectFirst:true, autoFill:true, maxItemsToShow:0, mustMatch:true, extraParams:{}},
		uniqueKey:'', showSlt:true, sltsG:[], askCmt:false, ctrIsLn:true, addOps: {url:'', prms:{}, hdlr:null, afterHdlr:null}};
	this.opts = $jQ.extend(true, {}, defaults, opts || {});
	var me = this;
	this.item = {};

	this.init = function() {
		if (me.opts.ctrIsLn) {
			$jQ("a", me.opts.ctrDiv).click(function() {
				me.opts.ctrDiv.html('<form class="def-form itnItmCtr u_block"><div class="item"></div><div class="slot"></div><div class="actions"><div class="action"><a href="#" class="search-button">Add</a></div></div></form>');
				me.opts.itemDiv = $jQ('.item', me.opts.ctrDiv); me.opts.slotDiv = $jQ('.slot', me.opts.ctrDiv);
				if (me.opts.askCmt) {
					me.opts.cmtDiv = $jQ('<div class="cmts"></div>');
					me.opts.slotDiv.after(me.opts.cmtDiv);
				}
				$jQ('a.search-button', me.opts.ctrDiv).click(function() {
					me.addItem();
					return false;
				});
				
				me.render();
				return false;
			});
		}
	}
	this.render = function() {
		this.item.selector = $jQ('<input type="text" name="'+me.getUniqueName('itnItemName')+'" style="width:400px;font-size:12px" placeholder="Enter Place Name to Add">');
		me.opts.itemDiv.append(this.item.selector);
		this.item.slot = $jQ('<span class="slotC"></span>');
		me.opts.slotDiv.append(this.item.slot);
		if (me.opts.askCmt) {me.opts.cmtDiv.html('<div class="clearfix"></div><h1 style="font-size:12px">Add comments for this place</h1><textarea rows="4" cols="30" name="'+me.getUniqueName('itmCmt')+'"></textarea>');}
		this.setSlots(null);
		this.attachItmAC();
		this.item.selector.focus();
	}
	this.getSlots = function(sltA) {
		if (sltA && sltA.length > 0) {
			return sltA;
		}
		return this.opts.sltsG;
	}
	this.setSlots = function(sltA) {
		sltA = me.getSlots(sltA);
		var sltSel = '';
		if (me.opts.showSlt) {
			var sltSel = $jQ('<select name="' + me.getUniqueName('tSlot') + '">');
			for (var i=0; i<sltA.length; i++) {
				sltSel.append('<option value="' + sltA[i].id + '">' + sltA[i].nm + '</option>');
			}
		} else {
			sltSel = $jQ('<input type="hidden" name="' + me.getUniqueName('tSlot') + '" value="'+sltA[0]+'"/>');
		}
		this.item.slot.html(sltSel);
	}
	this.getUniqueName = function(name) {
		return '_' + name + this.opts.uniqueKey;
	}
	this.addItem = function() {
		if (me.opts.addOps.hdlr) {me.opts.addOps.hdlr(); return;}
		var selItm = me.getSelectedItem();
		if (!selItm) {alert('Please select something.'); return;}
		selItm = $jQ.extend(true, {}, selItm, me.opts.addOps.prms || {});
		var successSaved = function(a, m, x) {
			if (me.opts.addOps.afterHdlr) {
				var dO = {day:selItm.day, slt:selItm.slt, htm:m};
				me.opts.addOps.afterHdlr(dO); return;
			}
		}
		AJAX_UTIL.asyncCall(me.opts.addOps.url, 
			{params: $jQ.param(selItm), scope: this,
				wait: {inDialog:false},
				success: {parseMsg:true, handler: successSaved}
			});
	}
	this.getSelectedItem = function() {
		if (!me.item.selectedItem) return null;
		me.item.selectedItem.slt = $jQ(me.opts.showSlt?'select':'input', me.item.slot).val();
		if (me.opts.askCmt) {me.item.selectedItem.cmts = $jQ('textarea', me.opts.cmtDiv).val();}
		return me.item.selectedItem;
	}
	this.onItemSelect = function(item) {
		me.item.selectedItem = item.data;
		if (me.opts.showSlt) {me.setSlots(item.data.slts);}
	}
	this.attachItmAC = function() {
		$jQ(this.item.selector).autocomplete('/package/itn-item-suggest', {
			selectFirst:me.opts.acOps.selectFirst, autoFill:me.opts.acOps.autoFill, matchInside:true, matchSubset:true, extraParams:me.opts.acOps.extraParams,
			maxItemsToShow:me.opts.acOps.maxItemsToShow, mustMatch:me.opts.acOps.mustMatch, filterResults:true, remoteDataType:'json', sortResults:true,
			showResult: null,
			onItemSelect: me.onItemSelect
		});
	}
	this.init();
}
$jQ(document).ready(function() {
	ITMMKR.init();
});
</script>