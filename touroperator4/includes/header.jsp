<%
	String docType = (request.getParameter("doc_type") != null) ? request.getParameter("doc_type"): "";
	boolean hideHeader = UIConfig.isHideHeader(request);
	boolean showMinHd = Boolean.parseBoolean(request.getParameter("minHd"));
	Destination destination = null;
	JSONObject json = null;
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	User user = SessionManager.getUser(request);
	User partnerUser = null;
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
		UserPreference socialContacts = partnerConfig.getUserPreferenceValue(UserPreferenceKey.SOCIAL_CONTACTS);
		if(socialContacts != null && StringUtils.isNotBlank(socialContacts.getValue())) {
			json = new JSONObject(socialContacts.getValue());
		}		
	}
%>
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.user.UserPreferenceKey"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.settings.AppSettingType"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.TourAction"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0047)http://hammockholidays.com/main/package/Special -->
 
<link href="/static/css/themes/touroperator4/css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/bootstrap-fileupload.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/stylesheet.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/jquery.autocompletefb.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/style.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/bootstrap-select.css" rel="stylesheet" type="text/css" media="screen">
<link href="/static/css/themes/touroperator4/css/animate.css" rel="stylesheet" type="text/css">
<link href="/static/css/themes/touroperator4/css/master.css" rel="stylesheet" type="text/css">

<script src="/static/css/themes/touroperator4/js/cb=gapi.loaded_1" async=""></script>
<script id="facebook-jssdk" src="/static/css/themes/touroperator4/js/all.js"></script>
<script id="twitter-wjs" src="/static/css/themes/touroperator4/js/widgets.js"></script>
<script type="text/javascript" async="" src="/static/css/themes/touroperator4/js/cse.js"></script>
<script async="" src="/static/css/themes/touroperator4/js/analytics.js"></script>
<script src="/static/css/themes/touroperator4/js/cb=gapi.loaded_0" async=""></script>
<script src="/static/css/themes/touroperator4/js/jquery-1.9.1.min.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery-migrate-1.1.1.min.js"></script>
<script src="/static/css/themes/touroperator4/js/bootstrap.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery-ui.js"></script>
<script src="/static/css/themes/touroperator4/js/modernizr.js"></script>
<script src="/static/css/themes/touroperator4/js/jquery.lazyload.min.js"></script>
    
<script type="text/javascript" src="/static/css/themes/touroperator4/js/plusone.js" gapi_processed="true"></script>
<script src="/static/css/themes/touroperator4/js/bootstrap-select.js"></script>   

<style>
    

.meeting
{
		opacity:1;
	-webkit-transition: all .6s ease;
-moz-transition: all .6s ease;
-o-transition: all .6s ease;
transition: all .6s ease;	
}
.meeting:hover
{

	opacity:.5;
	-webkit-transition: all .6s ease;
-moz-transition: all .6s ease;
-o-transition: all .6s ease;
transition: all .6s ease;	

}

.hiden
{
   height: 320px;
    overflow: hidden;
    position: relative;
    width: 300px;
	cursor:pointer;
}    
    
input.btncrud {
        background-color:#CCCCCC;
        margin:5px 0pt 2pt;
        border:1px solid;
        padding:3px 8px;
        font-size:12px;
        color:#000000;
}
.btn4{display:none;}
		
#share *{
   filter:alpha(opacity=0.1); 
   opacity:0.01;/*Hide Facebook button*/
}

.inside
{
	position:absolute;
	top:318px;
	left:0;

}
.meeting
{
	position:absolute;
	top:0;
	left:0;
}

#share{
  display:inline-block;

  /*The width and height of your image. Not bigger than the Like button!*/
  width: 10px;
  height: 10px;

  /*Your image*/
  background:url(fb.png);
}
</style>

 <script src="/static/css/themes/touroperator4/js/jsapi" type="text/javascript"></script><link type="text/css" href="/static/css/themes/touroperator4/css/default+en.css" rel="stylesheet"><link type="text/css" href="/static/css/themes/touroperator4/css/default.css" rel="stylesheet"><script type="text/javascript" src="/static/css/themes/touroperator4/js/default+en.I.js"></script><script type="text/javascript" src="/static/css/themes/touroperator4/js/search.I.js"></script><style type="text/css">
.gsc-control-cse {
font-family: Arial, sans-serif;
border-color: #FFFFFF;
background-color: #FFFFFF;
}
.gsc-control-cse .gsc-table-result {
font-family: Arial, sans-serif;
}
input.gsc-input, .gsc-input-box, .gsc-input-box-hover, .gsc-input-box-focus {
border-color: #D9D9D9;
}
input.gsc-search-button, input.gsc-search-button:hover, input.gsc-search-button:focus {
border-color: #666666;
background-color: #CECECE;
background-image: none;
filter: none;
}
.gsc-tabHeader.gsc-tabhInactive {
border-color: #E9E9E9;
background-color: #E9E9E9;
}
.gsc-tabHeader.gsc-tabhActive {
border-color: #FF9900;
border-bottom-color: #FFFFFF;
background-color: #FFFFFF;
}
.gsc-tabsArea {
border-color: #FF9900;
}
.gsc-webResult.gsc-result,
.gsc-results .gsc-imageResult {
border-color: #FFFFFF;
background-color: #FFFFFF;
}
.gsc-webResult.gsc-result:hover,
.gsc-imageResult:hover {
border-color: #FFFFFF;
background-color: #FFFFFF;
}
.gs-webResult.gs-result a.gs-title:link,
.gs-webResult.gs-result a.gs-title:link b,
.gs-imageResult a.gs-title:link,
.gs-imageResult a.gs-title:link b {
color: #0000CC;
}
.gs-webResult.gs-result a.gs-title:visited,
.gs-webResult.gs-result a.gs-title:visited b,
.gs-imageResult a.gs-title:visited,
.gs-imageResult a.gs-title:visited b {
color: #0000CC;
}
.gs-webResult.gs-result a.gs-title:hover,
.gs-webResult.gs-result a.gs-title:hover b,
.gs-imageResult a.gs-title:hover,
.gs-imageResult a.gs-title:hover b {
color: #0000CC;
}
.gs-webResult.gs-result a.gs-title:active,
.gs-webResult.gs-result a.gs-title:active b,
.gs-imageResult a.gs-title:active,
.gs-imageResult a.gs-title:active b {
color: #0000CC;
}
.gsc-cursor-page {
color: #0000CC;
}
a.gsc-trailing-more-results:link {
color: #0000CC;
}
.gs-webResult .gs-snippet,
.gs-imageResult .gs-snippet,
.gs-fileFormatType {
color: #000000;
}
.gs-webResult div.gs-visibleUrl,
.gs-imageResult div.gs-visibleUrl {
color: #008000;
}
.gs-webResult div.gs-visibleUrl-short {
color: #008000;
}
.gs-webResult div.gs-visibleUrl-short {
display: none;
}
.gs-webResult div.gs-visibleUrl-long {
display: block;
}
.gs-promotion div.gs-visibleUrl-short {
display: none;
}
.gs-promotion div.gs-visibleUrl-long {
display: block;
}
.gsc-cursor-box {
border-color: #FFFFFF;
}
.gsc-results .gsc-cursor-box .gsc-cursor-page {
border-color: #E9E9E9;
background-color: #FFFFFF;
color: #0000CC;
}
.gsc-results .gsc-cursor-box .gsc-cursor-current-page {
border-color: #FF9900;
background-color: #FFFFFF;
color: #0000CC;
}
.gsc-webResult.gsc-result.gsc-promotion {
border-color: #336699;
background-color: #FFFFFF;
}
.gsc-completion-title {
color: #0000CC;
}
.gsc-completion-snippet {
color: #000000;
}
.gs-promotion a.gs-title:link,
.gs-promotion a.gs-title:link *,
.gs-promotion .gs-snippet a:link {
color: #0000CC;
}
.gs-promotion a.gs-title:visited,
.gs-promotion a.gs-title:visited *,
.gs-promotion .gs-snippet a:visited {
color: #0000CC;
}
.gs-promotion a.gs-title:hover,
.gs-promotion a.gs-title:hover *,
.gs-promotion .gs-snippet a:hover {
color: #0000CC;
}
.gs-promotion a.gs-title:active,
.gs-promotion a.gs-title:active *,
.gs-promotion .gs-snippet a:active {
color: #0000CC;
}
.gs-promotion .gs-snippet,
.gs-promotion .gs-title .gs-promotion-title-right,
.gs-promotion .gs-title .gs-promotion-title-right * {
color: #000000;
}
.gs-promotion .gs-visibleUrl,
.gs-promotion .gs-visibleUrl-short {
color: #008000;
}
</style><style type="text/css">.fb_hidden{position:absolute;top:-10000px;z-index:10001}
.fb_invisible{display:none}
.fb_reset{background:none;border:0;border-spacing:0;color:#000;cursor:auto;direction:ltr;font-family:"lucida grande", tahoma, verdana, arial, sans-serif;font-size:11px;font-style:normal;font-variant:normal;font-weight:normal;letter-spacing:normal;line-height:1;margin:0;overflow:visible;padding:0;text-align:left;text-decoration:none;text-indent:0;text-shadow:none;text-transform:none;visibility:visible;white-space:normal;word-spacing:normal}
.fb_reset > div{overflow:hidden}
.fb_link img{border:none}
.fb_dialog{background:rgba(82, 82, 82, .7);position:absolute;top:-10000px;z-index:10001}
.fb_dialog_advanced{padding:10px;-moz-border-radius:8px;-webkit-border-radius:8px;border-radius:8px}
.fb_dialog_content{background:#fff;color:#333}
.fb_dialog_close_icon{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/yq/r/IE9JII6Z1Ys.png) no-repeat scroll 0 0 transparent;_background-image:url(http://static.ak.fbcdn.net/rsrc.php/v2/yL/r/s816eWC-2sl.gif);cursor:pointer;display:block;height:15px;position:absolute;right:18px;top:17px;width:15px;top:8px\9;right:7px\9}
.fb_dialog_mobile .fb_dialog_close_icon{top:5px;left:5px;right:auto}
.fb_dialog_padding{background-color:transparent;position:absolute;width:1px;z-index:-1}
.fb_dialog_close_icon:hover{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/yq/r/IE9JII6Z1Ys.png) no-repeat scroll 0 -15px transparent;_background-image:url(http://static.ak.fbcdn.net/rsrc.php/v2/yL/r/s816eWC-2sl.gif)}
.fb_dialog_close_icon:active{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/yq/r/IE9JII6Z1Ys.png) no-repeat scroll 0 -30px transparent;_background-image:url(http://static.ak.fbcdn.net/rsrc.php/v2/yL/r/s816eWC-2sl.gif)}
.fb_dialog_loader{background-color:#f2f2f2;border:1px solid #606060;font-size:24px;padding:20px}
.fb_dialog_top_left,
.fb_dialog_top_right,
.fb_dialog_bottom_left,
.fb_dialog_bottom_right{height:10px;width:10px;overflow:hidden;position:absolute}
.fb_dialog_top_left{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/ye/r/8YeTNIlTZjm.png) no-repeat 0 0;left:-10px;top:-10px}
.fb_dialog_top_right{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/ye/r/8YeTNIlTZjm.png) no-repeat 0 -10px;right:-10px;top:-10px}
.fb_dialog_bottom_left{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/ye/r/8YeTNIlTZjm.png) no-repeat 0 -20px;bottom:-10px;left:-10px}
.fb_dialog_bottom_right{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/ye/r/8YeTNIlTZjm.png) no-repeat 0 -30px;right:-10px;bottom:-10px}
.fb_dialog_vert_left,
.fb_dialog_vert_right,
.fb_dialog_horiz_top,
.fb_dialog_horiz_bottom{position:absolute;background:#525252;filter:alpha(opacity=70);opacity:.7}
.fb_dialog_vert_left,
.fb_dialog_vert_right{width:10px;height:100%}
.fb_dialog_vert_left{margin-left:-10px}
.fb_dialog_vert_right{right:0;margin-right:-10px}
.fb_dialog_horiz_top,
.fb_dialog_horiz_bottom{width:100%;height:10px}
.fb_dialog_horiz_top{margin-top:-10px}
.fb_dialog_horiz_bottom{bottom:0;margin-bottom:-10px}
.fb_dialog_iframe{line-height:0}
.fb_dialog_content .dialog_title{background:#6d84b4;border:1px solid #3b5998;color:#fff;font-size:14px;font-weight:bold;margin:0}
.fb_dialog_content .dialog_title > span{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/yd/r/Cou7n-nqK52.gif)
no-repeat 5px 50%;float:left;padding:5px 0 7px 26px}
body.fb_hidden{-webkit-transform:none;height:100%;margin:0;overflow:visible;position:absolute;top:-10000px;left:0;width:100%}
.fb_dialog.fb_dialog_mobile.loading{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/ya/r/3rhSv5V8j3o.gif)
white no-repeat 50% 50%;min-height:100%;min-width:100%;overflow:hidden;position:absolute;top:0;z-index:10001}
.fb_dialog.fb_dialog_mobile.loading.centered{max-height:590px;min-height:590px;max-width:500px;min-width:500px}
#fb-root #fb_dialog_ipad_overlay{background:rgba(0, 0, 0, .45);position:absolute;left:0;top:0;width:100%;min-height:100%;z-index:10000}
#fb-root #fb_dialog_ipad_overlay.hidden{display:none}
.fb_dialog.fb_dialog_mobile.loading iframe{visibility:hidden}
.fb_dialog_content .dialog_header{-webkit-box-shadow:white 0 1px 1px -1px inset;background:-webkit-gradient(linear, 0% 0%, 0% 100%, from(#738ABA), to(#2C4987));border-bottom:1px solid;border-color:#1d4088;color:#fff;font:14px Helvetica, sans-serif;font-weight:bold;text-overflow:ellipsis;text-shadow:rgba(0, 30, 84, .296875) 0 -1px 0;vertical-align:middle;white-space:nowrap}
.fb_dialog_content .dialog_header table{-webkit-font-smoothing:subpixel-antialiased;height:43px;width:100%
}
.fb_dialog_content .dialog_header td.header_left{font-size:12px;padding-left:5px;vertical-align:middle;width:60px
}
.fb_dialog_content .dialog_header td.header_right{font-size:12px;padding-right:5px;vertical-align:middle;width:60px
}
.fb_dialog_content .touchable_button{background:-webkit-gradient(linear, 0% 0%, 0% 100%, from(#4966A6),
color-stop(0.5, #355492), to(#2A4887));border:1px solid #29447e;-webkit-background-clip:padding-box;-webkit-border-radius:3px;-webkit-box-shadow:rgba(0, 0, 0, .117188) 0 1px 1px inset,
rgba(255, 255, 255, .167969) 0 1px 0;display:inline-block;margin-top:3px;max-width:85px;line-height:18px;padding:4px 12px;position:relative}
.fb_dialog_content .dialog_header .touchable_button input{border:none;background:none;color:#fff;font:12px Helvetica, sans-serif;font-weight:bold;margin:2px -12px;padding:2px 6px 3px 6px;text-shadow:rgba(0, 30, 84, .296875) 0 -1px 0}
.fb_dialog_content .dialog_header .header_center{color:#fff;font-size:16px;font-weight:bold;line-height:18px;text-align:center;vertical-align:middle}
.fb_dialog_content .dialog_content{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/y9/r/jKEcVPZFk-2.gif) no-repeat 50% 50%;border:1px solid #555;border-bottom:0;border-top:0;height:150px}
.fb_dialog_content .dialog_footer{background:#f2f2f2;border:1px solid #555;border-top-color:#ccc;height:40px}
#fb_dialog_loader_close{float:left}
.fb_dialog.fb_dialog_mobile .fb_dialog_close_button{text-shadow:rgba(0, 30, 84, .296875) 0 -1px 0}
.fb_dialog.fb_dialog_mobile .fb_dialog_close_icon{visibility:hidden}
.fb_iframe_widget{display:inline-block;position:relative}
.fb_iframe_widget span{display:inline-block;position:relative;text-align:justify}
.fb_iframe_widget iframe{position:absolute}
.fb_iframe_widget_lift{z-index:1}
.fb_hide_iframes iframe{position:relative;left:-10000px}
.fb_iframe_widget_loader{position:relative;display:inline-block}
.fb_iframe_widget_fluid{display:inline}
.fb_iframe_widget_fluid span{width:100%}
.fb_iframe_widget_loader iframe{min-height:32px;z-index:2;zoom:1}
.fb_iframe_widget_loader .FB_Loader{background:url(http://static.ak.fbcdn.net/rsrc.php/v2/y9/r/jKEcVPZFk-2.gif) no-repeat;height:32px;width:32px;margin-left:-16px;position:absolute;left:50%;z-index:4}
.fb_connect_bar_container div,
.fb_connect_bar_container span,
.fb_connect_bar_container a,
.fb_connect_bar_container img,
.fb_connect_bar_container strong{background:none;border-spacing:0;border:0;direction:ltr;font-style:normal;font-variant:normal;letter-spacing:normal;line-height:1;margin:0;overflow:visible;padding:0;text-align:left;text-decoration:none;text-indent:0;text-shadow:none;text-transform:none;visibility:visible;white-space:normal;word-spacing:normal;vertical-align:baseline}
.fb_connect_bar_container{position:fixed;left:0 !important;right:0 !important;height:42px !important;padding:0 25px !important;margin:0 !important;vertical-align:middle !important;border-bottom:1px solid #333 !important;background:#3b5998 !important;z-index:99999999 !important;overflow:hidden !important}
.fb_connect_bar_container_ie6{position:absolute;top:expression(document.compatMode=="CSS1Compat"? document.documentElement.scrollTop+"px":body.scrollTop+"px")}
.fb_connect_bar{position:relative;margin:auto;height:100%;width:100%;padding:6px 0 0 0 !important;background:none;color:#fff !important;font-family:"lucida grande", tahoma, verdana, arial, sans-serif !important;font-size:13px !important;font-style:normal !important;font-variant:normal !important;font-weight:normal !important;letter-spacing:normal !important;line-height:1 !important;text-decoration:none !important;text-indent:0 !important;text-shadow:none !important;text-transform:none !important;white-space:normal !important;word-spacing:normal !important}
.fb_connect_bar a:hover{color:#fff}
.fb_connect_bar .fb_profile img{height:30px;width:30px;vertical-align:middle;margin:0 6px 5px 0}
.fb_connect_bar div a,
.fb_connect_bar span,
.fb_connect_bar span a{color:#bac6da;font-size:11px;text-decoration:none}
.fb_connect_bar .fb_buttons{float:right;margin-top:7px}
.fb_edge_widget_with_comment{position:relative;*z-index:1000}
.fb_edge_widget_with_comment span.fb_edge_comment_widget{position:absolute}
.fb_edge_widget_with_comment span.fb_send_button_form_widget{z-index:1}
.fb_edge_widget_with_comment span.fb_send_button_form_widget .FB_Loader{left:0;top:1px;margin-top:6px;margin-left:0;background-position:50% 50%;background-color:#fff;height:150px;width:394px;border:1px #666 solid;border-bottom:2px solid #283e6c;z-index:1}
.fb_edge_widget_with_comment span.fb_send_button_form_widget.dark .FB_Loader{background-color:#000;border-bottom:2px solid #ccc}
.fb_edge_widget_with_comment span.fb_send_button_form_widget.siderender
.FB_Loader{margin-top:0}
.fbpluginrecommendationsbarleft,
.fbpluginrecommendationsbarright{position:fixed !important;bottom:0;z-index:999}
.fbpluginrecommendationsbarleft{left:10px}
.fbpluginrecommendationsbarright{right:10px}</style><style type="text/css">.gscb_a{display:inline-block;font:27px/13px arial,sans-serif}.gsst_a .gscb_a{color:#a1b9ed;cursor:pointer}.gsst_a:hover .gscb_a,.gsst_a:focus .gscb_a{color:#36c}.gsst_a{display:inline-block}.gsst_a{cursor:pointer;padding:0 4px}.gsst_a:hover{text-decoration:none!important}.gsst_b{font-size:16px;padding:0 2px;position:relative;user-select:none;-webkit-user-select:none;white-space:nowrap}.gsst_e{opacity:0.55;}.gsst_a:hover .gsst_e,.gsst_a:focus .gsst_e{opacity:0.72;}.gsst_a:active .gsst_e{opacity:1;}.gsst_f{background:white;text-align:left}.gsst_g{background-color:white;border:1px solid #ccc;border-top-color:#d9d9d9;box-shadow:0 2px 4px rgba(0,0,0,0.2);-webkit-box-shadow:0 2px 4px rgba(0,0,0,0.2);margin:-1px -3px;padding:0 6px}.gsst_h{background-color:white;height:1px;margin-bottom:-1px;position:relative;top:-1px}.gsib_a{width:100%;padding:4px 6px 0}.gsib_a,.gsib_b{vertical-align:top}.gssb_c{border:0;position:absolute;z-index:989}.gssb_e{border:1px solid #ccc;border-top-color:#d9d9d9;box-shadow:0 2px 4px rgba(0,0,0,0.2);-webkit-box-shadow:0 2px 4px rgba(0,0,0,0.2);cursor:default}.gssb_f{visibility:hidden;white-space:nowrap}.gssb_k{border:0;display:block;position:absolute;top:0;z-index:988}.gsdd_a{border:none!important}.gscsep_a{display:none}.gsq_a{padding:0}.gssb_a{padding:0 7px}.gssb_a,.gssb_a td{white-space:nowrap;overflow:hidden;line-height:22px}#gssb_b{font-size:11px;color:#36c;text-decoration:none}#gssb_b:hover{font-size:11px;color:#36c;text-decoration:underline}.gssb_g{text-align:center;padding:8px 0 7px;position:relative}.gssb_h{font-size:15px;height:28px;margin:0.2em;-webkit-appearance:button}.gssb_i{background:#eee}.gss_ifl{visibility:hidden;padding-left:5px}.gssb_i .gss_ifl{visibility:visible}a.gssb_j{font-size:13px;color:#36c;text-decoration:none;line-height:100%}a.gssb_j:hover{text-decoration:underline}.gssb_l{height:1px;background-color:#e5e5e5}.gssb_m{color:#000;background:#fff}.gsfe_a{border:1px solid #b9b9b9;border-top-color:#a0a0a0;box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);-moz-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);-webkit-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);}.gsfe_b{border:1px solid #4d90fe;outline:none;box-shadow:inset 0px 1px 2px rgba(0,0,0,0.3);-moz-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.3);-webkit-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.3);}.gssb_a{padding:0 9px}.gsib_a{padding-right:8px;padding-left:8px}.gsst_a{padding-top:3px}.gssb_e{border:0}.gssb_l{margin:5px 0}.gssb_c .gsc-completion-container{position:static}.gssb_c{z-index:5000}.gsc-completion-container table{background:transparent;font-size:inherit;font-family:inherit}.gssb_c > tbody > tr,.gssb_c > tbody > tr > td,.gssb_d,.gssb_d > tbody > tr,.gssb_d > tbody > tr > td,.gssb_e,.gssb_e > tbody > tr,.gssb_e > tbody > tr > td{padding:0;margin:0;border:0}.gssb_a table,.gssb_a table tr,.gssb_a table tr td{padding:0;margin:0;border:0}</style></head>

<div class=" js boxshadow pointerevents placeholder">
<div class="topmenu">
    
<!-- top nav -->
<div class="row-fluid">
  <div class="span12 top_menu_wrapper">
    <div class="container top_menu_wrapper2">
                   
    	<div class="navbar navbar-inverse">
                    <div class="navbar-inner">
                        <div class="container top_menu_wrapper">
                            <button class="btn btn-navbar" data-target=".nav-collapse" data-toggle="collapse" type="button">
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <div class="home pull-left btn-link"><a href="/" data-hint="Home" class="hint--bottom"><img src="/static/css/themes/touroperator4/img/home.gif"></a></div>
                            <div class="nav-collapse collapse">
                                <ul class="nav">
                                  <li class=""><a href="/" id="show_slide1">About us <span class="caret caret1" id="caret1"></span></a> </li>
                                  <li class=""><a href="/" id="show_slide3">Last minute deals <span class="caret caret1" id="caret3"></span></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
	</div>
  </div>
</div>



<div class="row-fluid border_bottom nav2_gradiant">
  <div class="span12">
    <div class="container">
      <div class="navbar span5">
        <ul class="nav nav2">
          <li><a href="/tours/welcome" id="active2">Home</a></li>
					<li><a href="/tours/packages">Packages</a></li>
					<li><a href="/tours/tips">Travel Guide</a></li>
					<li><a href="/tours/reviews">Travel Tips</a></li>
					<li><a href="/tours/contactus">Contact</a></li>
         </ul>
      </div>
      <div class="span3">
      <div class="logo_holder"><a href="/" class="navbar-brand logo"><img src="<%=PartnerConfigBean.getPartnerConfigLogoURL(request, partnerConfigData)%>"  style="height:50px;width:150px"></a></div></div>

        <div class="span4">
      <div class="navbar-search_holder">

  
<script>
  (function() {
    var cx = '009514069806777361294:breczqi04p0';
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + cx;
  //  gcse.setLinkTarget(google.search.Search.LINK_TARGET_SELF);
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);
  })();
</script>
<div id="___gcse_0"><div class="gsc-control-cse gsc-control-cse-en"><div class="gsc-control-wrapper-cse" dir="ltr"><form class="gsc-search-box gsc-search-box-tools" accept-charset="utf-8"><table cellspacing="0" cellpadding="0" class="gsc-search-box"><tbody><tr><td class="gsc-input"><div class="gsc-input-box" id="gsc-iw-id1"><table cellspacing="0" cellpadding="0" id="gs_id50" class="gstl_50 " style="width: 100%; padding: 0px;"><tbody><tr><td id="gs_tti50" class="gsib_a"><input autocomplete="off" type="text" size="10" class="gsc-input" name="search" title="search" id="gsc-i-id1" style="width: 100%; padding: 0px; border: none; margin: 0px; height: auto; outline: none;" dir="ltr" spellcheck="false"></td><td class="gsib_b"><div class="gsst_b" id="gs_st50" dir="ltr"><a class="gsst_a" href="javascript:void(0)" style="display: none;"><span class="gscb_a" id="gs_cb50">×</span></a></div></td></tr></tbody></table></div></td><td class="gsc-search-button"><input type="image" src="/static/css/themes/touroperator4/img/search_box_icon.png" class="gsc-search-button gsc-search-button-v2" title="search"></td><td class="gsc-clear-button"><div class="gsc-clear-button" title="clear results">&nbsp;</div></td></tr></tbody></table><table cellspacing="0" cellpadding="0" class="gsc-branding"><tbody><tr style="display: none;"><td class="gsc-branding-user-defined"></td><td class="gsc-branding-text"><div class="gsc-branding-text">powered by</div></td><td class="gsc-branding-img"><img src="/static/css/themes/touroperator4/img/small-logo.png" class="gsc-branding-img"></td></tr></tbody></table></form><div class="gsc-results-wrapper-overlay"><div class="gsc-results-close-btn" tabindex="0"></div><div class="gsc-tabsAreaInvisible"><div class="gsc-tabHeader gsc-inline-block gsc-tabhActive">Web</div><span class="gs-spacer"> </span><div tabindex="0" class=" gsc-tabHeader gsc-tabhInactive gsc-inline-block">Image</div><span class="gs-spacer"> </span></div><div class="gsc-refinementsAreaInvisible"></div><div class="gsc-above-wrapper-area-invisible"><table cellspacing="0" cellpadding="0" class="gsc-above-wrapper-area-container"><tbody><tr><td class="gsc-result-info-container"><div class="gsc-result-info-invisible"></div></td><td class="gsc-orderby-container"><div class="gsc-orderby-invisible"><div class="gsc-orderby-label gsc-inline-block">Sort by:</div><div class="gsc-option-menu-container gsc-inline-block"><div class="gsc-selected-option-container gsc-inline-block"><div class="gsc-selected-option">Relevance</div><div class="gsc-option-selector"></div></div><div class="gsc-option-menu-invisible"><div class="gsc-option-menu-item gsc-option-menu-item-highlighted"><div class="gsc-option">Relevance</div></div><div class="gsc-option-menu-item"><div class="gsc-option">Date</div></div></div></div></div></td></tr></tbody></table></div><div class="gsc-adBlockInvisible"></div><div class="gsc-wrapper"><div class="gsc-adBlockInvisible"></div><div class="gsc-resultsbox-invisible"><div class="gsc-resultsRoot gsc-tabData gsc-tabdActive"><table cellspacing="0" cellpadding="0" class="gsc-resultsHeader"><tbody><tr><td class="gsc-twiddleRegionCell"><div class="gsc-twiddle"><div class="gsc-title">Web</div></div><div class="gsc-stats"></div><div class="gsc-results-selector gsc-all-results-active"><div class="gsc-result-selector gsc-one-result" title="show one result">&nbsp;</div><div class="gsc-result-selector gsc-more-results" title="show more results">&nbsp;</div><div class="gsc-result-selector gsc-all-results" title="show all results">&nbsp;</div></div></td><td class="gsc-configLabelCell"></td></tr></tbody></table><div><div class="gsc-expansionArea"></div></div></div><div class="gsc-resultsRoot gsc-tabData gsc-tabdInactive"><table cellspacing="0" cellpadding="0" class="gsc-resultsHeader"><tbody><tr><td class="gsc-twiddleRegionCell"><div class="gsc-twiddle"><div class="gsc-title">Image</div></div><div class="gsc-stats"></div><div class="gsc-results-selector gsc-all-results-active"><div class="gsc-result-selector gsc-one-result" title="show one result">&nbsp;</div><div class="gsc-result-selector gsc-more-results" title="show more results">&nbsp;</div><div class="gsc-result-selector gsc-all-results" title="show all results">&nbsp;</div></div></td><td class="gsc-configLabelCell"></td></tr></tbody></table><div><div class="gsc-expansionArea"></div></div></div></div></div></div><div class="gsc-modal-background-image" tabindex="0"></div></div></div></div>
<!--       <form class="navbar-search">
          <input type="text" placeholder="Search" class="search-query input-medium">
          <div class="icon-search"></div>
        </form>-->
        </div>
      </div>
    </div>
  </div>
</div>
</div>



<script type="text/javascript">
SERVER_VARS._DOCTYPE = '<%=docType%>';
</script>

