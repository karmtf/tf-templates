<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.gds.util.ListUtility"%>

<%@page import="com.eos.accounts.user.UserPreferenceManager"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.FixedPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>


<%@page import="com.eos.b2c.ui.NavigationHelper"%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%
	SupplierPackage transportPackage = (SupplierPackage)request.getAttribute(Attributes.PACKAGE.toString());
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SupplierPackage selectedPackage = null;
	long pkgId = request.getParameter("pkgId") != null ? Long.parseLong(request.getParameter("pkgId")) : -1L;
	long pricingId = request.getParameter("pricingId") != null ? Long.parseLong(request.getParameter("pricingId")) : -1L;
	if(pkgId > 0) {
		for(SupplierPackage pkg : packages.values()) {
			if(pkg.getId() == pkgId) {
				selectedPackage = pkg;
				break;
			}
		}
	}
	TransportPackageUnit packageUnit = null;
	List<CitywiseItinerary> cities = null;
	if(transportPackage != null) {
		packageUnit = (TransportPackageUnit)transportPackage.getSellableUnit();
		cities = packageUnit.getCitywiseItinerary();
	}
	List<PackageTag> packageTags = null;
	if(selectedPackage != null) {
		packageTags = selectedPackage.getPackageTags();
	}
	User supplier = SessionManager.getUser(request);
	String currentCurrency = null;
	if(supplier.getUserPreferences() != null && !supplier.getUserPreferences().isEmpty()) {
		currentCurrency = UserPreferenceManager.getCurrencyPreference(supplier.getUserPreferences());
	}
	if(currentCurrency == null) {
		currentCurrency = SessionManager.getCurrentUserCurrency(request);            	
	}
	List<PackageTag> tags = PackageTag.getImportantList();
	CurrencyType currencyType = CurrencyType.getCurrencyByCode(currentCurrency);
	Map<Long,List<SupplierPackagePricing>> pricings =   (Map<Long,List<SupplierPackagePricing>>)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());;
	SupplierPackagePricing selectedPackagePricing = null;
	if(pkgId > 0 && pricingId > 0) {
		List<SupplierPackagePricing> selPricing = pricings.get(pkgId);
		for(SupplierPackagePricing pr : selPricing) {
			if(pr.getId() == pricingId) {
				selectedPackagePricing = pr;
				break;
			}
		}
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	PricingComponents pricingComponents = selectedPackagePricing != null ? selectedPackagePricing.getPricingComponents() : null;
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	if(selectedPackagePricing != null) {
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_SINGLE) {
					single = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_TWIN) {
					twin = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_EXTRA_ADULT) {
					adult = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD) {
					cwb = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD_WITHOUT_BED) {
					cob = price.getPriceAmount();
				}
			}
		}
	}
%>
<html>
<head>
<title>Add Price for Package</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>

<script type="text/javascript" src="/static/js/package/packages_config.js"></script>
<style type="text/css">
.result .heading {font-size:16px;font-weight:normal !important;padding:10px 2px 0;width:110px;float:left;font-style:italic;font-family:georgia,serif}
.result .suggest {position:absolute; right:0px;line-height:45px; font-size:11px;padding-top:10px;}
.result .suggest a {font-size:13px;height:25px;line-height:25px; font-weight:bold;color:#F78C0D;}
.result .pos1 {position: relative; top: -35px; height: 0px; left: 155px;opacity:0.25;width:6px}
.result .pos2 {position: relative; top: -35px; height: 0px; left: 402px;opacity:0.25;width:6px}
.result .pos3 {position: relative; top: -35px; height: 0px; left: 637px;opacity:0.25;width:6px}
.result img{max-width:none;}
.result .option {font-size:12px;font-weight:normal;padding:10px 5px;width:230px;float:left;color:#444;position:relative;}
.result .option a {color:#444;text-decoration:none;}
.option input, .option select, .option2 select, .option2 input {-moz-box-shadow:none !important;-webkit-box-shadow:none !important;box-shadow:none !important;padding:2px 5px !important;}
.result .selected a {color:red !important;}
.result .option .minus {background:#FFCCCC;font-size:7pt;margin-top:2px;padding:1px 5px;-moz-border-radius:5px 5px 5px 5px;-webkit-border-radius:5px 5px 5px 5px;border-radius:5px 5px 5px 5px;color:#222;font-weight: bold; position: absolute;display:none}
.result .option .plus {background:#BCED91;font-size:7pt;margin-top:2px;padding:1px 5px;-moz-border-radius:5px 5px 5px 5px;-webkit-border-radius:5px 5px 5px 5px;border-radius:5px 5px 5px 5px;color:#222;font-weight: bold; position: absolute;display:none}
.result .option .deal {background:url("http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/deal_icon.png") no-repeat;position:absolute;height:14px;width:30px;left:-52px;top:10px}
.result .option2 {font-size:13px;font-weight:normal;padding:10px 0px 2px 10px;width:100px;float:left;color:#444;margin-top:5px}
.result .option input {float:left;margin-right:5px;color:#777777;font-family:arial;font-size:13px;padding:6px 5px}
.result .option select {margin-right:5px;color:#777777;font-family:arial;font-size:13px;padding:6px 5px}
.result .option span, .result .option a.hPOpt {display:block;text-decoration:none}
.result .option a:hover {text-decoration:underline}
.result .destination {font-size:18px;color:#4A9D0F;width:99%;font-weight:bold !important;float:left;padding:15px 10px 0;margin-top:25px;}
.result div.seprator {background:url("/static/img/v1/border-bg.gif") repeat-x scroll 0 13px transparent;clear:both;font-size:1e-9em;height:14px;width:100%}
.result div.seprator3 {background: url("/static/img/v1/border-bg.gif") repeat-x scroll 0 1px transparent;clear: both;height: 6px;width: 100%;}
.result .hide{display:none}
.errMsg {font-size: 14px; margin-bottom: 10px; background: #FDFFEA; padding: 5px; border: 1px solid #FAE257; font-weight: bold;}
.result .selected {color:#4A9D0F !important;font-weight:bold}
.price {color:#F78C0D !important;font:20px georgia,serif;font-weight:bold;}
.result .label_radio {width:21px; float:left;}
.result label.r_on {}
.result .label_radio input {}
.dest_filter {font-size:14px;font-family:arial;width:150px}
.result .includes {padding-left:10px;padding-top:5px;float:left;font-size:8pt;font-weight:normal;width:550px}
h6.bestsellers {3px solid #FBDB0C;color:#FA8503;font-bold;font-size:14px;border-bottom:2px solid #FA8503;line-height:25px;;margin-top:2px}
div.bestseller {color:#555555;font-size:12px;margin-top:10px}
.sUlthd{color: green;font-size:20px;}
.packName{font-size:22px;font-family:arial;color:#2f2f2f;border-bottom:3px solid #FFC136 !important;padding:5px 0px;margin-top:15px}
.packInc{font-size:12px;font-family:arial;font-weight: bold;color:#444;padding:0 5px 5px;}
.sUl {margin:0 5px 0 20px; padding-left:0;}
.sUl li{list-style:disc;border-bottom: 1px solid #DDD;padding: 5px;color:#444;font-size:12px;line-height:15px}
.result .seprator {height:20px;}
.result .selected {color:red !important;font-weight:bold}
.bnrGBlk {-moz-border-radius:5px; -moz-box-shadow:1px 1px 5px 1px #888; -webkit-border-radius:5px; -webkit-box-shadow:1px 1px 5px 1px #888;
	border-radius:5px; box-shadow:1px 1px 5px 1px #888; border:10px solid #FFF;}
.start {display:inline-block;height:30px;line-height:30px;text-align:center;text-decoration:none;vertical-align:top;width:120px;background:#FF8D2D;border:1px solid #D87114;font-size:16px;text-shadow:0 -1px 0 #AAAAAA;color:#fff;font-weight:bold;}
.priceCtr {width:175px; position:relative; border-left:1px solid #DDD; float:left; min-height:105px;}
.priceSec {padding:0 0 0 25px;}
.priceSecF {background:#fff; padding:5px 25px 15px; box-shadow:1px 1px 3px #000;-moz-box-shadow:1px 1px 3px #000}
.city {background:none repeat scroll 0 0 #DEDEDE;font-weight:bold;color:#333333;width:145px !important;font-weight:bold !important;border-bottom:1px solid #AAA;border-right:1px solid #fff;border-left:1px solid #fff;padding:7px 5px !important}
.sel {background:#FFFFFF !important;}
#summary {background:-moz-linear-gradient(center bottom , #FFFCD1 0%, #FFF9B1 40%, #FFF9B1 100%) repeat scroll 0 0 transparent;background:linear-gradient(center bottom , #FFFCD1 0%, #FFF9B1 40%, #FFF9B1 100%) repeat scroll 0 0 transparent;border:1px solid #DDDDDD;position:absolute;right:2px;top:10px;width:550px;padding:10px 0}
.link {padding: 0pt; color:#F78C0D; font-size: 13px; text-decoration: none; font-weight: bold ! important;float:right;margin-right:10px}
#JT_arrow_left{background-image: url(http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/tooltips/arrow_left.gif);background-repeat: no-repeat;background-position: left top;position: absolute;z-index:101;left:-12px;height:23px;width:10px;top:117px;}
#JT_arrow_right{background-image: url(http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/tooltips/arrow_right.gif);background-repeat: no-repeat;background-position: left top;position: absolute;z-index:101;height:23px;width:11px;top:-2px;}
#JT {position: absolute;z-index:100;border:1px solid #CCCCCC;background-color: #fff;}
#JT_copy {padding-left:10px;padding-right:10px;padding-bottom:10px;color:#666;}
.JT_loader{background-image: url(http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/tooltips/loader.gif);background-repeat: no-repeat;background-position: center center;width:100%;height:12px;}
#JT_close_left{background-color:#fff;text-align: left;padding-left:10px;padding-bottom:10px;padding-top:10px;font-size:14px;font-weight:bold;color:#333;padding-right:10px;}
#JT_close_right{background-color:#fff;text-align: left;padding-left:10px;padding-bottom:10px;padding-top:10px;font-weight:bold;color:#333;padding-right:10px;}
#JT_copy p{margin:2px 0;}
#JT_copy img{}
#summaryBtn {top:120px;left:0;position:fixed;z-index:10;}
.footer-nag {background:#fff;top:93px;-moz-box-shadow:0 8px 10px rgba(0, 0, 0, 0.45);-webkit-box-shadow:0 8px 10px rgba(0, 0, 0, 0.45);
box-shadow:0 8px 10px rgba(0, 0, 0, 0.45);color:#CCCCCC;left:0;margin-left:-10px;padding-right:10px;position:fixed;text-align:center;width:360px;z-index:10; border:1px solid #ddd;}
.footer-nag .container {margin:0 auto;padding:5px 0 10px 10px;position:relative;text-align:left;width:360px;}
.footer-nag .container h3 {display:block;font-size:14px;font-weight:normal;line-height:21px;}
.footer-nag .container .primary-actions {position:absolute;right:0px;top:10px;}
.pkgSmV {margin-right:8px;border:1px solid #DDD;width:210px;}
.pkgSmV p {text-align:justify;margin-top:10px;line-height:15px;color:#333;font-size:11px;margin-bottom:0;font-weight:normal;}
.pkgSmV .pNm{height:20px;margin-top:10px;margin-left:0 !important;}
.pkgSmV .pvW{border-top: 1px solid #DDD;margin-left:0 !important;font-size:12px;font-weight:bold;padding:10px 0 0;color:#F78C0D;}
.pkgSmV .pNm .selected {color:red !important;}
.changeBoxDiv{display:block;padding-left:5px;width:100%;}
.itn{border-bottom:1px solid #AAA;padding-bottom:7px !important;width:135px !important;background:#fff;}
</style>
</head>
<body>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".select").select2();
	$jQ(".datepicker").datepicker({
		defaultDate: +7,
		showOtherMonths:true,
		autoSize: true,
		appendText:'(dd-mm-yyyy)',
		dateFormat:'dd/mm/yy'
	});
	$jQ(".spinner-currency").spinner({
		min: 0,
		max: 2500,
		step: 5,
		start: 1000,
		numberFormat:"C"
	});
});
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:850px;">
	<div class="spacer"></div>
	<% if(packages != null && !packages.isEmpty() && pricings != null) { %>
	<h5 class="widget-name">Fixed Packages Uploaded</h5>
	<table class="table">
		<tr>
			<th>Name</th>
			<th>Edit</th>
			<th>Delete</th>
			<th>Publish</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				List<SupplierPackagePricing> prices = pricings.get(pkg.getId());
				if(prices != null) {
					for(SupplierPackagePricing pricing : prices) { 
						isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:470px"><%=pkg.getName()%></td>
			<td style="width:50px"><a href="/partner/price-grid?selectedSideNav=packages&pkgId=<%=pkg.getId()%>&transportpkgid=<%=transportPackage.getId()%>&pricingId=<%=pricing.getId()%>">Edit</a></td>
			<td style="width:50px"><a href="/partner/delete-fixed-package?selectedSideNav=packages&pkgid=<%=pkg.getId()%>&transportpkgid=<%=transportPackage.getId()%>">Delete</a></td>
			<td style="width:150px"><%=pkg.getPackageConfigId() > 0 ? "<span style=\"font-size:11px\">Published!  </span>" : ""%><a href="/partner/publish-fixed-package?transportpkgid=<%=transportPackage.getId()%>&selectedSideNav=packages&pkgId=<%=pkg.getId()%>"><%=pkg.getPackageConfigId() > 0 ? "Publish again &raquo;" : "Publish to Website &raquo;"%></a></td>
		</tr>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td colspan=5 style="font-size:11px"><%=pkg.getSupplierSpecificDesc()%></td>
		</tr>
		<% } } } %>
	</table>
	<div class="spacer"></div>
	<% } %>
	<h5 class="widget-name">Add Price for Package <%=transportPackage.getName()%> </h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-fixed-packages" method="post">
		<input type="hidden" name="transportpkgid" value="<%=(transportPackage != null)?transportPackage.getId():"-1"%>" />
		<input type="hidden" name="pricingId" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="pkgId" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<input type="hidden" name="ht" value="-1" />
		<input type="hidden" name="pht" value="-1" />
		<input type="hidden" name="rt" value="-1" />
		<input type="hidden" name="optionals" value="-1" />
		<fieldset>
		<!-- General form elements -->
		<div class="result va-ga" style="background:#fff">
			<div class="itin"></div>
			<div class="u_clear"></div>
			<div class="c00 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="c01 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="c02 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line4.gif" /></div>
			<div class="c10 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>
			<div class="c11 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="c12 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="c20 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line5.gif" /></div>
			<div class="c21 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>
			<div class="c22 pos3 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="cr0 pos1 hide" style="left:155px;top:16px"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line6.gif" /></div>	
			<div class="cr1 pos1 hide" style="left:402px;top:20px"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line6.gif" /></div>	
			<div class="cr2 pos1 hide" style="left:637px;top:16px"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line6.gif" /></div>	
			<div class="sopt"></div>
			<div class="d00 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="d01 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="d02 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line4.gif" /></div>
			<div class="d10 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>
			<div class="d11 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="d12 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="d20 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line5.gif" /></div>
			<div class="d21 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>							
			<div class="d22 pos3 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="hopt"></div>
			<div class="e00 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="e01 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="e02 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line4.gif" /></div>
			<div class="e10 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>
			<div class="e11 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="e12 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="e20 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line5.gif" /></div>
			<div class="e21 pos2 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>							
			<div class="e22 pos3 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="er0 pos1 hide" style="left:155px;top:16px"></div>	
			<div class="er1 pos1 hide" style="left:391px;top:16px"></div>	
			<div class="er2 pos1 hide" style="left:637px;top:16px"></div>	
			<div class="meals"></div>			
			<div class="g00 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="g01 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="g02 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line4.gif" /></div>
			<div class="g10 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>
			<div class="g11 pos2 hide" style="left:391px"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="g12 pos2 hide" style="left:391px"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line2.gif" /></div>
			<div class="g20 pos1 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line5.gif" /></div>
			<div class="g21 pos2 hide" style="left:391px"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line3.gif" /></div>
			<div class="g22 pos3 hide"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/line1.gif" /></div>
			<div class="gr0 pos1 hide" style="left:155px;top:16px"></div>
			<div class="gr1 pos1 hide" style="left:402px;top:16px"></div>	
			<div class="gr2 pos1 hide" style="left:637px;top:16px"></div>	
			<div class="ropt"></div>
			<div class="pkgs"></div>
			<div class="tsfr"></div>
			<div class="extras"></div>
			<div class="ssopt"></div>
			<div class="heading hide">Total</div>
			<div id="0i" class="heading hide" style="font-size:13px;font-weight:normal !important;width:500px">(for 2 persons)</div>
			<div class="price hide"><div id="pkgPrcCtr" class="u_floatL" style="margin-right:10px"><%=currentCurrency%>&nbsp;0</div></div>
			<div class="u_clear"></div>
		</div>
		<div class="spacer"></div>
		<div class="widget row-fluid">
			<div class="control-group">
				<label class="control-label">Package Name:</label>
				<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Applicable For:</label>
				<div class="controls">
					<select data-placeholder="Any of these themes" name="purpose"  class="select" multiple="multiple" tabindex="0">
						<% for(PackageTag tag : tags) { %>
						<option value="<%=tag.name()%>" <%=(packageTags != null && packageTags.contains(tag))?"selected":""%>><%=tag.getDisplayName()%></option>
						<% } %>
					</select>
				</div>
			</div>				
			<div class="control-group">
				<label class="control-label">Other Inclusions:</label>
				<%
					List<String> inclusions = null;
					List<String> terms = null;
					List<String> exclusions = null;
					if(selectedPackage != null) {
						inclusions = selectedPackage.getFreeTextInclusions();
						exclusions = selectedPackage.getExclusions();
						terms = selectedPackage.getTerms();
					}
				%>
				<div class="controls">
					<textarea rows="5" cols="5" name="inclusions" id="inclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(inclusions != null && inclusions.size() >= 1)?inclusions.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Exclusions:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="exclusions" id="exclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(exclusions != null && exclusions.size() >= 1)?exclusions.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Cancellation Policy:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>		
			<div class="control-group">
				<label class="control-label">Validity:</label>
				<div class="controls">
					<ul class="dates-range no-append">
						<li><input type="text" placeholder="Start Travel Date" value="<%=fromDateStr%>" id="date" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
						<li class="sep">-</li>
						<li><input type="text" placeholder="End Travel Date" value="<%=toDateStr%>" id="date2" name="toDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=toDateStr%></span></li>
					</ul>
				</div>
			</div>	
			<div class="control-group">
				  <label class="control-label">Currency:</label>
				  <div class="controls">
				  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
						<% for (CurrencyType curr: CurrencyType.values()) { %>
							<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
						<% } %>
				  </select>						  
				</div>
			</div>	
			<div class="control-group">
				<label class="control-label">Pricing:</label>
				<div class="controls">
					<div class="row-fluid">
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="singleAdult" value="<%=single%>" /><span class="help-block">Single Adult</span>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="twinSharing" value="<%=twin%>" /><span class="help-block">Twin Sharing</span>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="extraAdult" value="<%=adult%>" /><span class="help-block">Extra Adult</span>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="cwb" value="<%=cwb%>" /><span class="help-block">Child with Bed</span>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="cob" value="<%=cob%>" /><span class="help-block">Child no Bed</span>
						</div>
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Website URL<br>(if applicable)</label>
				<div class="controls"><input type="text" name="supplierUrl" id="supplierUrl" value="<%=(selectedPackage != null && selectedPackage.getSupplierRedirectUrl() != null)?selectedPackage.getSupplierRedirectUrl():""%>" class="span12"></div>
			</div>									
			<div class="form-actions align-right">
				<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Update Package Information</button>
			</div>		
		</div>
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
//setInterval(savePkgCfgDraft, 30000);
//window.onbeforeunload = confirmPageLeave;
//JS_UTIL.handleIEError();
//lastSavedCfgSrl = $jQ("#holidayForm3").serialize();
var pkgV = new Config({currency:'<%=CurrencyType.getShortCurrencyCode(SessionManager.getCurrentUserCurrency(request))%>'});
<% if(selectedPackage != null) { %>
pkgV.fetchResults('/partner/configure',<%=(transportPackage != null)?transportPackage.getId():"-1"%>,<%=cities.get(0).getCityId()%>,null,'<%=ListUtility.toString(selectedPackage.getAllChildSupplierPackageIds(), ":")%>:');
<% } else { %>
pkgV.fetchResults('/partner/configure',<%=(transportPackage != null)?transportPackage.getId():"-1"%>,<%=cities.get(0).getCityId()%>);
<% } %>
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
