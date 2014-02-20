<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageInventory"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.via.content.ContentDataType"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.gds.data.Carrier"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.secondary.database.model.PackageExperience"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.currency.CurrencyConverter"%>
<%@page import="com.eos.b2c.holiday.data.TransportType"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageExperience experience = (PackageExperience) request.getAttribute(Attributes.PACKAGE_EXPERIENCE.toString());
	List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();
	Map<Integer, Map<SellableUnitType, List<PackageOptionalConfig>>> pkgOptionalsMap = (Map<Integer, Map<SellableUnitType, List<PackageOptionalConfig>>>) request.getAttribute(Attributes.PACKAGEDATA.toString());
	Map<Integer, List<Long>> selectedOptionalsMap = (Map<Integer, List<Long>>) request.getAttribute(Attributes.PACKAGE_OPTIONALS_SELECTED.toString());
	Map<Date, PackageInventory> inventoryDateMap = (Map<Date, PackageInventory>) request.getAttribute(Attributes.PACKAGE_INVENTORY.toString());
	String currentCurrency = SessionManager.getCurrentUserCurrency(request);
	String title = null;
	Set<Long> recommendations = null;
	if(experience != null) {
		title = "Recommended for ";
		int i = 0;
		if(experience.getTravelerEthnicities() != null && !experience.getTravelerEthnicities().isEmpty()) { 
			for(TravelerEthnicity ethnic : experience.getTravelerEthnicities()) {
				title += ethnic.getPlural();
				i++;
				if(i < experience.getTravelerEthnicities().size()) {
					title += ",";							
				}
			}
		} else {
			title += "all";
		}
		i = 0;
		if(experience.getThemeTypes() != null && !experience.getThemeTypes().isEmpty()) { 
			title += " traveling for ";
			for(HolidayThemeType theme : experience.getThemeTypes()) {
				title += theme.getDisplayName();
				i++;
				if(i < experience.getThemeTypes().size()) {
					title += ",";							
				}
			}
		}
		UserInputState rhsState = experience.getExperienceState();
		recommendations = (Set<Long>) rhsState.getUserInputForInputType(UserInputType.PACKAGE_OPTIONAL, true).getValues();
	}
%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.holiday.data.PackageDataManager"%>
<%@page import="com.poc.server.partner.PartnerBean"%>
<%@page import="com.eos.b2c.ui.util.EncryptionHelper"%>
<style type="text/css">
.result .option {font-size:13px;font-weight:normal;width:15%;padding:10px 0px;float:left;color:#444;position:relative;line-height:22px;}
.result .option2 {width:82%;padding-left:5px}
.booking .f-item {padding:2px 2% 2px 0;}
.booking .triplets .f-item {width:31%}
.booking .penta .f-item {width:18%}
.u_invisible{display:none;}
.booking h3 {background-color:#101001;text-indent:0;margin-bottom:0;color:#fff;margin-top:0px;background-image:linear-gradient(#101001, #66696B);background-image:-moz-linear-gradient(#101001, #66696B);background-image:-webkit-linear-gradient(#101001, #66696B);border-radius:0.3em 0.3em 0 0;padding:10px 0 10px 0;font-weight:bold;border-bottom:1px solid #000;}
.booking .row {margin-top:10px}
.booking h3 span {color:#fff;padding-left:10px;}
.booking h3.stepClose {background-color: #fafafa;color:#555;background-color: rgba(255,255,255,0);background-image: -moz-linear-gradient(rgba(255,255,255,0),rgba(0,0,0,0.05));background-image: -webkit-linear-gradient(rgba(255,255,255,0),rgba(0,0,0,0.05));background-image: linear-gradient(rgba(255,255,255,0),rgba(0,0,0,0.05));border-bottom: 1px solid #ccc;border-top: 1px solid #ccc;font-weight:normal;}
.booking h3.stepClose span {color:#444;}
.booking h3 span.edit {float:right;margin-right:10px;display:none}
.tab-content .text-wrap {box-shadow: inset 0 0 10px rgba(0,0,0,0.15);margin-bottom: 10px;border-radius: 5px;-webkit-border-radius:5px;-moz-border-radius:5px;-webkit-box-shadow:inset 0 0 10px rgba(0,0,0,0.15);padding: 10px;border: 1px solid #C3C3C3;}
h2 {font-size:15px;}
@media only screen and (max-width: 600px) {
.result .option {width:100%}
.result .option2 {width:100%;padding-left:5px}
#summarySec {display:none;}
#summaryDiv {max-width:100%;}
}
.pkgRecCtr {background:#fffed5; padding:10px;}
.pkgRecCtr h2 {font-weight:bold; border-bottom:1px solid #ddd; font-size:16px; padding-bottom:8px;}
.pkgRecCtr h3 {font-weight:bold; font-size:14px; padding:0 0 6px;}
.pkgRec {padding:8px 5px; margin-bottom:8px; border-bottom:1px dotted #ddd;}
.pkgRec .recDsc {font-size:13px; float:left; width:580px;}
.pkgRec .recPrc {font-size:14px; font-weight:bold; float:right;}
.fltSltVw {padding-left:0px !important}
</style>
<article style="padding:0;margin:0;width:100%">
	<form name="tripPRForm" id="tripPRForm" class="booking wideL" style="box-shadow:none;-webkit-box-shadow:none;background:none;padding:0;" action="/partner/booking-summary" method="post">
		<input type="hidden" name="pkgId" value="<%=pkgConfig.getId()%>" />
		<% if(inventoryDateMap != null && !inventoryDateMap.isEmpty()) { %>
		<input type="hidden" name="checkAvl" value="<%=pkgConfig.getId()%>" />
		<% } %>
		<input type="hidden" name="sltdFltJ" value="" />
		<% if (pkgConfig.getAttachedOffer() != null) { %>
			<input type="hidden" name="ao" value="<%=EncryptionHelper.encryptId(pkgConfig.getAttachedOffer().getId())%>" />
			<input type="hidden" name="fltSltCallback" value="onPkgFlightSelection" />
		<% } %>
		<h3 id="stp1">
			<span>1. </span>Enter Your Travel Preferences
			<span class="edit"><a href="#" onclick="openTravelPref();return false;">Edit</a></span>
		</h3>
		<div id="travelPref">
			<div class="row row1 triplets">
				<div class="f-item">
					<label for="when">When do you plan to go ?</label>
					<% if(inventoryDateMap == null || inventoryDateMap.isEmpty()) { %>
					<input type="text" name="travelDate" class="calInput" value="<%=ThreadSafeUtil.getDateFormat(false, false).format(DateUtility.getDateForFuture(true, false, 7))%>" />
					<% } else { %>
					<select name="travelDate" id="travelDate" style="width:100px">
					<% for(Date date : inventoryDateMap.keySet()) { %>
					<option value="<%=ThreadSafeUtil.getDateFormat(false, false).format(date)%>"><%=ThreadSafeUtil.getShortDisplayDateFormat(false, false).format(date)%></option>
					<% } %>
					</select>			
					<% } %>
				</div>
				<div class="f-item">
					<label for="when">What is your average daily budget ?</label>
					<input type="text" name="budget" value="" placeholder="(in <%=currentCurrency%>) per person" />
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="fldCtr1 u_block row4 mrgnT">
				<div class="icCtr u_floatL"><div class="spGnIc pplIc"></div></div>
				<div class="row">
					<div class="f-item">
						<label for="rooms">Select rooms needed</label>
						<select name="numRooms" id="numRooms" class="smPad" onchange="selectRooms();" style="width:25%"><% for (int i=1; i<=4; i++) { %><option value="<%=i%>"><%=i%></option><% } %></select>
					</div>
				</div>
				<% for (int i=1; i<=4; i++) { %>
					<div class="roomd room<%=i%> <%=(i>1)?"u_invisible":""%>">
						<div class="row penta">
							<div class="f-item">
								<label style="padding-top:20px" class="dCityNm u_floatL">Room <%=i%></label>
							</div>
							<div class="f-item">
								<label>Adults (12+ yrs)</label>
								<select name="adults<%=i%>" id="adults<%=i%>" class="smPad"><option value="1">1</option><option value="2">2</option><option value="3">3</option></select>
							</div>
							<div class="f-item">
								<label>Children</label>
								<select name="child<%=i%>" id="child<%=i%>" class="smPad" onchange="selectChildren(<%=i%>)"><option value="0">0</option><option value="1">1</option><option value="2">2</option></select>
							</div>
							<div id="room<%=i%>child1" class="f-item u_invisible">
								<label>Age Child 1</label>
								<select id="room<%=i%>child1Age" name="room<%=i%>child1Age" class="smPad">
									<% for(int j=1;j < 12;j++){ %>
									<option value="<%=j%>"><%=j%> yrs</option>
									<% } %>
								</select>
							</div>
							<div id="room<%=i%>child2" class="f-item u_invisible">
								<label>Age Child 2</label>
								<select id="room<%=i%>child2Age" name="room<%=i%>child2Age" class="smPad">
									<% for(int j=1;j < 12;j++){ %>
									<option value="<%=j%>"><%=j%> yrs</option>
									<% } %>
								</select>
							</div>
						</div>
					</div>
				<% } %>
			</div>
			<div class="row">
				<div class="f-item" style="margin-top:20px;margin-bottom:20px">
					<a href="#" onclick="calculatePrice();return false;" class="book-button">Calculate Price</a>
				</div>
			</div>
	</div>
	<h3 id="stp2" class="stepClose"><span>2. </span>Customize Trip Options</h3>
	<div id="config" style="display:none">
	<% if (pkgConfig.getAttachedOffer() == null) { %>
		<div id="pkgFltSlt" class="mrgnT"></div>
	<% } %>
	<% 
		if(title != null && recommendations != null && pkgOptionalsMap != null && !pkgOptionalsMap.isEmpty()) {
	%>
	<div class="text-wrap result" style="margin-top:20px">
		<h2 style="padding:15px 0 5px;"><b>Recommended Experience For You</b></h2>	
		<h2 style="padding:15px 0 5px;"><b><%=experience.getTitle()%></b></h2>	
		<% if(StringUtils.isNotBlank(experience.getDescription())) { %>
		<div class="u_normalF" style="line-height:22px;margin:10px 0">
			<%=experience.getDescription()%>
		</div>
		<% } %>
	<%
			for (CityConfig cityPkgConfig : cityConfigs) {
				int city = cityPkgConfig.getCityId();	
				Map<SellableUnitType, List<PackageOptionalConfig>> optionalsMap = 
				(Map<SellableUnitType, List<PackageOptionalConfig>>) pkgOptionalsMap.get(city);
				if(optionalsMap != null) {
					for (List<PackageOptionalConfig> optionList : optionalsMap.values()) {
						for (PackageOptionalConfig optional : optionList) {
							if(recommendations.contains(optional.getId())) {
								request.setAttribute(Attributes.PACKAGE_OPTIONALS_DATA.toString(), optional);
	%>
	<jsp:include page="option_display.jsp">
		<jsp:param name="city" value="<%=city%>" /> 
	</jsp:include>
	<%							
							}
						}
					}										
				}					
			}				
			if(experience != null) {
				int price = (int)Math.round(CurrencyConverter.convert(experience.getCurrency(), currentCurrency, experience.getPrice()));								
	%>
	<div class="option option2" id="pkgOpt<%=experience.getId()%>" style="color:#093;font-weight:bold;font-size:14px;">
		<input type="checkbox" name="experience" value="<%=experience.getId()%>" onclick="recalculatePkgPrice()" />&nbsp;&nbsp;Buy all the above together for
	</div>
	<div class="option right" style="text-align:right;font-size:16px"><b>+ <%=CurrencyType.getShortCurrencyCode(currentCurrency)%>&nbsp;<%=price%></b>
		<div class="u_vsmallF">
			<%=experience.getPricingType().getDisplayText("")%>
		</div>
	</div>
	<div class="clearfix"></div>				
	<%
		} 
	%>
	</div>
	<%
		}
	%>
	<article style="padding:0;margin-bottom:20px;width:100%;">
		<h2 style="padding:15px 0 5px"><b>Select City to Customize</b></h2>
		<div class="mrgn10T"><select id="selCty" onchange="selectCity()">
		<% 
			for (CityConfig cityPkgConfig : cityConfigs) {
				int city = cityPkgConfig.getCityId();			
		%>	
		<option value="<%=city%>"><%=LocationData.getCityNameFromId(city)%></option>
		<% } %>
		</select></div>
	</article>
	<% 
		int index = 0;
		for (CityConfig cityPkgConfig : cityConfigs) {
			int city = cityPkgConfig.getCityId();			
			int nts = cityPkgConfig.getTotalNumNights();
	%>
	<div id="<%=city%>config" class="cityCfg" style="<%=(index > 0) ? "display:none" : ""%>">
		<div class="text-wrap result">
			<div class="option option2" style="padding-left:0">
				<select name="<%=city%>nts" onchange="recalculatePkgPrice()">
					<option value="<%=nts%>"><%=nts%> nights</option>
					<option value="<%=nts+1%>"><%=nts+1%> nights</option>
					<option value="<%=nts+2%>"><%=nts+2%> nights</option>
					<option value="<%=nts+3%>"><%=nts+3%> nights</option>
					<option value="<%=nts+4%>"><%=nts+4%> nights</option>
				</select>
				&nbsp;stay in <%=LocationData.getCityNameFromId(city)%>
			</div>
		</div>
		<% 
		if(pkgOptionalsMap != null && !pkgOptionalsMap.isEmpty()) {
			Map<SellableUnitType, List<PackageOptionalConfig>> optionalsMap = 
			(Map<SellableUnitType, List<PackageOptionalConfig>>) pkgOptionalsMap.get(city);
			if(optionalsMap != null) {				
				for (SellableUnitType sUnitType : optionalsMap.keySet()) {
					List<PackageOptionalConfig> optionals = (List<PackageOptionalConfig>) optionalsMap.get(sUnitType);
		%>
		<%
			boolean isFirst = true;
			for (PackageOptionalConfig optional : optionals) {
				int price = (int)Math.round(CurrencyConverter.convert(optional.getCurrency(), currentCurrency, optional.getPrice()));
				if(recommendations != null && !recommendations.isEmpty() && recommendations.contains(optional.getId().longValue())) {
					continue;
				}
		%>
		<% if(isFirst) { %>
		<div class="text-wrap result">
		<h2 style="padding:15px 0 5px;"><b><%=sUnitType.getDisplayName()%> options</b></h2>
		<%  
			isFirst = false;} 
			request.setAttribute(Attributes.PACKAGE_OPTIONALS_DATA.toString(), optional);
		%>
		<jsp:include page="option_display.jsp">
			<jsp:param name="city" value="<%=city%>" /> 
		</jsp:include>		
		<% } %>
		<% if(!isFirst) { %>		
		</div>
		<% } %>
	<% } } } %>
	</div>	
	<% index++; } %>
	<% if (pkgConfig.getAttachedOffer() != null) { %>
		<div id="pkgFltSlt"></div>
	<% } %>
	</div>
	</form>	
</article>
<div id="pkgRecCtr" style="display:none" class="pkgRecCtr u_clear"></div>
<script type="text/javascript" >
$jQ("input:checkbox").change(function() {
    var group = "input:checkbox[name='"+$jQ(this).attr("name")+"']";
    if($jQ(group).length > 1) {
		if(this.checked) {
			$jQ(group).not(this).removeAttr("checked");
		}
	}
});

function selectRooms() {
	var rooms = $jQ('#numRooms').val();
	$jQ('.roomd').hide();
	for(var x = 1; x <= rooms; x++) {
		$jQ('.room' + x).show();
	}
	//recalculatePkgPrice();
}

function selectCity() {
	var id = $jQ('#selCty').val();
	$jQ('.cityCfg').hide();
	$jQ('#'+id+'config').show();
}

function selectChildren(i) {
	var child = $jQ('#child'+i).val();
	for(var x = 1; x <= 2; x++) {
		if(child >= x) {
			$jQ('#room' + i + 'child' + x).show();
		} else {
			$jQ('#room' + i + 'child' + x).hide();
		}
	}
	//recalculatePkgPrice();
}

function recalculatePkgPrice() {
	var successSave = function(a, m, x) {
		MODAL_PANEL.hide();
		var rspO = JS_UTIL.parseJSON($jQ(x).text());
		var tPrc = rspO.tprc;
		var cts = rspO.aCts;
		$jQ('#totalPriceDiv').html("<%=CurrencyType.getShortCurrencyCode(currentCurrency)%> " + tPrc);
		var html = '';
		for (var i = 0; i < cts.length; i++) {
			html += '<div style="font-size:13px; padding:3px 8px;font-weight:bold">';
			html += cts[i].city;
			html += '</div>';
			html += '<ul style="margin:3px 0 10px 22px; font-size:11px;">';
			for(var j = 0; j < cts[i].inc.length; j++) {
				html+= '<li style="list-style-type:disc;font-size:13px">' + cts[i].inc[j] + '</li>';
			}
			html += '</ul>';
		}
		$jQ('#tprcTxt').html(rspO.prcTxt);
		$jQ('#summarySec').html(html);
		$jQ(':checkbox').removeAttr("checked");
		var bookable = rspO.bookable;
		var experience = rspO.experience;
		if(bookable == 'true') {
			var html = '<a class="search-button" style="cursor:pointer;font-size:13px;line-height:35px;height:35px;" onclick="sendBookingRequest();return false;">Send Booking Request</a>';
			$jQ('#bookButton').html(html);
		} else if(bookable == 'instant') {
			var html = '<a class="search-button" style="cursor:pointer;font-size:13px;line-height:35px;height:35px;" onclick="instantBooking();return false;">Book Now</a>';
			$jQ('#bookButton').html(html);
		} else {
			var html = '<p style="font-size:14px;font-weight:bold">Sorry enough seats are not available for booking</p>';
			$jQ('#bookButton').html(html);
		}
		if(experience == 'true') {
			$jQ('input:checkbox[name=experience]').attr("checked","checked");
		}
		var prms = rspO.params;
		for(var key in prms) {
			var val = prms[key];
			if($jQ('input:checkbox[name=' + key + ']').length > 0) {
				$jQ('input:checkbox[name=' + key + ']').each(function(){
					if($jQ(this).val() == val) {
						$jQ(this).attr("checked","checked");
					}
				});
			}
		}
		if (rspO.fltSlt) {
			var fltSltJ = $jQ('#pkgFltSlt').html('');
			fltSltJ.append('<h3><span style="font-weight:bold;padding-left:10px">Flight options</span></h3>').append(rspO.fltSlt);
		}
		if (rspO.lFltSlt) {
			$jQ('#pkgFltSlt').html(rspO.lFltSlt);
		}
		renderPkgReco(rspO.recO);
	}
	AJAX_UTIL.asyncCall('/partner/reprice-package', {params: $jQ('#tripPRForm').serialize(), wait: {msg:'Re-calculating your trip price'}, scope: this, success: {handler:successSave}});
}

function calculatePrice() {
	recalculatePkgPrice();
	$jQ('#travelPref').slideToggle('slow');
	$jQ('#config').slideToggle('slow');
	$jQ('#pkgDiv').hide();
	$jQ('#summaryDiv').show();
	$jQ('#pkgRecCtr').show();
	$jQ('.edit').show();
	$jQ('#stp1').addClass('stepClose');
	$jQ('#stp2').removeClass('stepClose');
}

function openTravelPref() {
	$jQ('#travelPref').slideToggle('slow');
	$jQ('#config').slideToggle('slow');
	$jQ('#pkgRecCtr').hide();
	$jQ('.edit').hide();
	$jQ('#stp2').addClass('stepClose');
	$jQ('#stp1').removeClass('stepClose');
}

function onPkgFlightSelection(fltA) {
	document.tripPRForm.sltdFltJ.value = JS_UTIL.stringifyJSON(fltA);
	<% if (pkgConfig.getAttachedOffer() == null) { %>
		recalculatePkgPrice();
	<% } %>
}
function onPkgFlightRemoved() {
	document.tripPRForm.sltdFltJ.value = '';
	recalculatePkgPrice();
}
function renderPkgReco(recA) {
	if (!recA || recA.length == 0) return;
	var rcCtr = $jQ('#pkgRecCtr').html('<h2>Recommendations</h2>');
	for (var i=0;i<recA.length;i++) {
		var rcO = recA[i], rcJ = $jQ('<div class="pkgRec u_block">');
		rcJ.append('<h3>'+rcO.hd+'</h3>').append('<div class="recDsc">' + rcO.dsc + '</div>');
		rcJ.append('<div class="recPrc">' + rcO.prc + '</div>');
		rcCtr.append(rcJ);
	}
}
<% if(inventoryDateMap == null || inventoryDateMap.isEmpty()) { %>
var dtPicker = new DatePick({fromInp:document.tripPRForm.travelDate});
<% } %>

$jQ(window).scroll(function (event) {
    var y = $jQ(this).scrollTop();
    if (y >= 105) {
        $jQ('#summaryDiv').css('top','10px');
    } else {
        $jQ('#summaryDiv').css('top', (105 - y) + 'px');
    }
});
$jQ(document).ready(function() {
<% if (selectedOptionalsMap != null && !selectedOptionalsMap.isEmpty()) { %>
<% 
	for (Integer cityId: selectedOptionalsMap.keySet()) {
	    List<Long> optionalIds = selectedOptionalsMap.get(cityId);
	    for (Long optionalId: optionalIds) {
%>
	$jQ('#pkgOpt<%=optionalId%> input:checkbox').attr("checked", "checked");
<% 
	    }
	}
%>
	recalculatePkgPrice();
<% } else { %>
	renderPkgReco(<%=PartnerBean.getPackageRecommendationPrototype(request, pkgConfig, DateUtility.getDateForFuture(true, false, 7), 0)%>);
<% } %>
});
</script>
