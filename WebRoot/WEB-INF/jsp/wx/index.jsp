<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <title>选卡网</title>
    <link href="<%=path%>/css/wx/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <link href="<%=path%>/css/wx/alongsty.css" rel="stylesheet" type="text/css"/>
    <link href="<%=path%>/css/wx/style.css?v=4" rel="stylesheet" type="text/css"/>
    <link href="<%=path%>/css/wx/app.css" rel="stylesheet" type="text/css"/>
    <link href="<%=path%>/css/wx/secList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript" src="<%=path%>/js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="<%=path%>/js/wx/kendo.core.min.js"></script>
    <script type="text/javascript" src="<%=path%>/js/wx/fontscroll.js"></script>
    <script type="text/javascript" src="<%=path%>/js/wx/TouchSlide.1.1.js"></script>
    <script type="text/javascript" src="<%=path%>/js/jquery.cookie.js"></script>
    <script type="text/javascript" src="<%=path%>/js/address.js"></script>
    <link rel="stylesheet" href="<%=path%>/js/dist/dropload.css">
    <script src="<%=path%>/js/dist/dropload.min.js"></script>
    <style type="text/css">

        .copy-select input {
            width: 200px;
            height: 30px;
            outline: none;
            border: none;
            text-align: center;
        }

        .copy-select ul {
            position: absolute;
            top: 31px;
            left: 0;
            display: none;
            width: 200px;
            height: 500px;
            z-index: 9999;
            overflow-y: auto;
        }

        .copy-select ul li {
            list-style: none;
            height: 30px;
        }

        .copy-select ul li:nth-child(2n-1) {
            background-color: rgba(0, 0, 0, .3);
        }


        body {
            background: #F3F3F3;
        }

        .fillter1_item {
            width: 20%;

        }

        .on {
            color: #ff5200 !important;
        }

        .pullDown {
            display: none;
        }

        .home-wrapper {
            height: 700px;
        }

        .fillter_content {
            position: absolute;
            z-index: 999;
            width: 100%;
            background-color: #fff;
        }

        .w94 {
            position: absolute;
        }

        .operators-ul span {
            margin-left: 45%
        }
        .price-li{
            background: #eee;
            color: #767676;
            font-size: 10px;
            font-weight: 500;
            line-height: 50px;
            margin-bottom: 10px;
            text-align: center;
            width: 20%;
            display: inline-block;
        }
        .pull-li{
            width: 100%;
            text-align: center;
        }
        .price_span{
            width: 100%;
            text-align: center;
            align-items: center
        }


        ::-webkit-input-placeholder { /* WebKit, Blink, Edge */
            font-size: 12px;
            /*placeholder位置  *!*/
            text-align: center;
        }
        :-moz-placeholder { /* Mozilla Firefox 4 to 18 */
            font-size: 12px;
            /*placeholder位置  *!*/
            text-align: center;
        }
        ::-moz-placeholder { /* Mozilla Firefox 19+ */
            font-size: 12px;
            /*placeholder位置  *!*/
            text-align: center;
        }
        :-ms-input-placeholder { /* Internet Explorer 10-11 */
            font-size: 12px;
            /*placeholder位置  *!*/
            text-align: center;
        }

    </style>
    <script type="text/javascript">
        var curPage = 1;
        var pageRecordCount = 10;
        var uploadSuc = false;
        var upload = false;
        var meiWid = 0;
        var itemnum = 0;
        var searchType = "scalNum";
        var number = "";
        $(function () {
            loadData();
            $(window).bind("scroll", col_scroll);
            $.ajax({
                type: "post",
                url: "<%=path%>/hyuser/wxIndexType",
                dataType: "json",
                data: "",
                success: function (data) {
                    var pinWidth = window.screen.availWidth;
                    meiWid = (pinWidth - 10) / 5;

                    if (data != null && data.length > 0) {
                        $("#soldiv").css("display", "block");
                        var appStr = "";
                        for (var i = 0; i < data.length; i++) {
                            appStr += "<div  onclick=\"gotoTypeUrl('" + data[i].webUrl + "', '" + data[i].webUrl + "')\" style=\"width:20%;height:auto;\"><div style='width:100%; height:auto; float:left; display:inline'><img style=\"width:50px;height:50px;\" src=\"<%=path%>" + data[i].typeImg + "\"/></div><div style='width:100%; height:auto; float:left; display:inline'>" + data[i].typeName + "</div><div style=\"clear:both\"></div></div>";
                        }
                        $(".tuiguang_xuanxiang").append(appStr);
                        var num = data.length / 2;
                        num = num.toFixed(0);
                        itemnum = num;
                        var w = ((num * meiWid) + 20) > $(".tuiguang_xuanxiang").parent().width() ? ((num * meiWid) + 20 + "px") : "100%";
                        var chw = ((pinWidth * 100 / num * meiWid)).toFixed(0);
                        if (chw < 1) {
                            chw = 1;
                        }
                        var totalWid = $("#soldivnei").width();
                        $("#soldivnei").css("width", totalWid / chw + "px");
                    }
                }
            });
            $(".fillter1_item").on("click", function () {
                let index = $('.fillter1_item').index(this);
                if ($(".pullDown :eq(" + index + ")").is(":hidden")) {
                    $(".pullDown").hide();
                    $(".pullDown :eq(" + index + ")").show();
                    if (index === 1) {//guishudi
                        $(".pullDown").hide();
                        $(".pullDown :eq(" + index + ")").show();
                    }
                } else {
                    $(".pullDown").hide();
                }
            });
            $(".operators-ul li").on("click", function () {
                $(".operators-ul li").removeClass("on");
                $(this).addClass("on");
                $("#operators").addClass("on");
                $("#operators").html($(this).text());
                $(".pullDown").hide();
                curPage = 1;
                loadData();
                $("#ulid").empty();

            });
            $(".guilv-ul li").on("click", function () {
                $(".guilv-ul li").removeClass("on");
                $(this).addClass("on");
                $("#guilv").addClass("on");
                $("#guilv").html($(this).text());
                $(".pullDown").hide();
                curPage = 1;
                loadData();
                $("#ulid").empty();

            });
            $(".price-ul li").on("click", function () {
                $("#price_div").find('li.on').removeClass("on");
                $("#pianhao_div").find('li.on').removeClass("on");
                $(this).addClass("on");
                $("#price").addClass("on");
                $("#price").html($(this).text());
                $(".pullDown").hide();
                curPage = 1;
                loadData();
                $("#ulid").empty();
            });

            $(".paixu-ul li").on("click", function () {
                $(".paixu-ul").removeClass("on");
                $(this).addClass("on");
                $("#paixu").addClass("on");
                $("#paixu").html($(this).text());
                $(".pullDown").hide();
                curPage = 1;
                loadData();
                $("#ulid").empty();

            });

            $('#num-input').bind('input', function () {
                var num = $('#num-input').val();
                $("#price").html("不含" + num);
                $(".pullDown").hide();
                curPage = 1;
                loadData();
                $("#ulid").empty();
            });
        });
        $("#typediv").scroll(function () {
            var gun = $(this).scrollLeft();
            var chw = 1 - (gun * 100 / (itemnum * meiWid)).toFixed(0) / (window.screen.availWidth);
            $("#soldivnei").css("left", chw + "%");
        });
        $("#ulid").scroll(function () {
            var gun = $(this).scrollLeft();
            $("#ulid").css("left", "20%");
        });
        var txts = $(".accurate input");
        for (var i = 1; i < txts.length; i++) {
            var t = txts[i];
            t.index = i;
            t.onClick = function () {
                this.removeAttribute("readonly");
            }
            t.onkeyup = function () {
                this.value = this.value.replace(/^(.).*$/, '$1');
                var next = this.index + 1;
                if (next > txts.length - 1) return;
                txts[next].focus();
            }
        }
        ;
        $(function(){
            // $("#sn1").focus();
            // function device_verify(){
            //     console.log($("#sn1").val()+$("#sn2").val()+$("#sn3").val()+$("#sn4").val());
            // }

            //自动跳到下一个输入框
            $("input[name^='sn']").each(function(){
                $(this).keyup(function(e){
                    if($(this).val().length < 1){
                        $(this).prev().focus();
                    }else{
                        if($(this).val().length >= 1){
                            $(this).next().focus();
                        }
                    }
                });

            });

            $("input[type='text'][id^='sn']").bind('keyup',
                function() {
                    var len = $("#sn1").val().length + $("#sn2").val().length + $("#sn3").val().length + $("#sn4").val().length;
                    if (len == 4) device_verify();
                });
            loadData();
        });

        function searchNum(e) {
            curPage = 1;
            loadData(number, searchType);
            $("#ulid").empty();
        }

        function loadData() {
            if (searchType == "scalNum") {
                var txts = $(".accurate input");
                number = "1";
                for (var i = 1; i < txts.length; i++) {
                    var t = $(txts[i]).val();
                    if (t != null && t != "") {
                        number = number + t;
                    } else {
                        number = number + "_";
                    }
                }
            } else if (searchType == "anyNum") {
                var txts = $("#anyNumInp");
                number = txts.val();
            } else if (searchType == "endNum") {
                var txts = $("#endNumInp");
                number = txts.val();
            }
            if (number != null && number != "") {
                if (number == "undefined") {
                    number = "";
                }
            }
            //运营商
            let operator = $(".operators-ul li.on").attr("data-id");
            let province = $("#getProvinceValue").val() != "不限" ? $("#getProvinceValue").val() : "";
            let city = $("#getCityValue").val() != "不限" ? $("#getCityValue").val() : "";
            let val = document.getElementById("price").innerHTML;
            let startPrice = null;
            let endPrice = null;
            let pianhao = null;
            let free = null;
            if (val != null && val != undefined) {
                if(val.length == 3){
                    if(val =='风水号'){
                        free = 2;
                    }
                    pianhao = val.substring(2, 3)
                }else{
                    let p = val.split("-");
                    startPrice = p[0] != null && p[0] != '' && p[0] != '不限' && p[0] != '更多'? p[0] : null;
                    endPrice = p[1] != null && p[1] != '' && p[1] != '不限' ? p[1] : null;
                    if(val =='更多'){
                        pianhao = $('#num-input').val();
                    }else if(val =='5万以上'){
                        startPrice = 50000;
                    }else{
                        if(startPrice!= null && startPrice.indexOf("万") != -1){
                            startPrice = startPrice.replace("万","0000");
                        }
                        if(endPrice!= null &&endPrice.indexOf("万") != -1){
                            endPrice = endPrice.replace("万","0000");
                        }
                    }
                }
            }
            let order = "";
            let orderBy = "";
            let order_by = document.getElementById("paixu").innerHTML;
            if (order_by == '价格由低到高') {
                order = 'asc';
                orderBy = "price";
            }
            if (order_by == '价格由高到低') {
                order = 'desc';
                orderBy = "price";
            }
            if (order_by == '按更新时间') {
                order = 'desc';
                orderBy = "id";
            }

            let preference = [];
            let preferenceStr = "";
            $("input[name='preference']:checkbox").each(function (index) {
                if ($(this).prop("checked") === true) {
                    preference.push($(this).val());
                }
            });
            preferenceStr = preference.join(",");
            let law = document.getElementById("guilv").innerHTML;
            law = (law != '不限' && law != '规律') ? law:null;
            $("#note").show();
            $.ajax({
                type: "post",
                url: "<%=path%>/wxMobileSale/wxMobileSaleMainList",
                dataType: "json",
                data: {
                    "page.curPage": curPage,
                    "page.pageRecordCount": pageRecordCount,
                    "mobileSale.hasSale": 0,
                    "mobileSale.mobileNum": number,
                    "mobileSale.searchType": searchType,
                    "mobileSale.operator": operator,
                    "mobileSale.notLike": pianhao,
                    "page.order" : order,
                    "page.orderBy" : orderBy,
                    "mobileSale.hasSale":0,
                    "mobileSale.free":free,
                    "mobileSale.province":province,
                    "mobileSale.city":city,
                    "mobileSale.startPrice":startPrice,
                    "mobileSale.endPrice":endPrice,
                    "mobileSale.preferenceStr":preferenceStr,
                    "mobileSale.law":law,
                },
                success: function (data) {
                    $("#note").hide();
                    if (data != null && data.length > 0) {
                        var appStr = "";
                        for (var i = 0; i < data.length; i++) {
                            let operatorStr = "联通";
                            let operator = data[i].operator + '';
                            switch (operator) {
                                case '0':
                                    operatorStr = "移动";
                                    break;
                                case '2':
                                    operatorStr = "电信";
                                    break;
                                case '3':
                                    operatorStr = "虚商";
                                    break;
                            }
                            appStr += "<ul >";
                            appStr += "<a href=\"javascript:;\" onclick=\"showDetail('<%=path%>/wxMobileSale/wxMobileSaleDetail?mobileSale.id=" + data[i].id + "')\">";
                            appStr += "<li style='height: 8.533vw'>";
                            appStr += "<span class=\"index_p1\" >";
                            appStr += "<span >" + data[i].mobileNum + "</span>";
                            appStr += "</span>";
                            appStr += "<span class=\"index_p1\">";
                            appStr += "<span >" + data[i].province + data[i].city + "</span>";
                            appStr += "</span>";
                            appStr += "<span class=\"index_p1\" >";
                            appStr += "<span >" + operatorStr + "</span>";
                            appStr += "</span>";
                            appStr += "<span class=\"index_p1\" >";
                            appStr += "<span style=\"color: #e54c3f\" >" + "￥" + data[i].price + "</span>";
                            appStr += "</span>";
                            appStr += "</li>";
                            appStr += "</a>";
                            appStr += "</ul>";
                        }
                        $("#ulid").append(appStr);
                    } else {
                        appStr =null;
                        var noMuch = $("#noMuch").text();
                        if (noMuch == null || noMuch == '') {
                            appStr = "<span id= 'noMuch' style=\"text-align: center;display:block;margin-top:20px;color: #949494;\">没有更多数据了</span>";
                            $("#ulid").append(appStr);
                        }
                    }
                }
            });
        }

        function resetNum(e) {
            curPage = 1;
            if (searchType == "scalNum") {
                var txts = $(".accurate input");
                for (var i = 1; i < txts.length; i++) {
                    var t = $(txts[i]);
                    t.val("");
                }
            } else if (searchType == "anyNum") {
                var txts = $("#anyNumInp");
                txts.val("");
            } else if (searchType == "endNum") {
                var txts = $("#endNumInp");
                txts.val("");
            }
            number = "";
            loadData();
            $("#ulid").empty();
        }

        function showDetail(url) {
            window.open(url, "_self");
        }

        function gotoTypeUrl(typeName, webUrl) {
            window.open(webUrl, "_self");
        }
        //下拉到底部加载更多数据
        //加载函数
        let col_scroll = function () {
            if ($(document).height() - $(this).scrollTop() - $(this).height() < 10 && !upload) {
                if (!uploadSuc && !upload) {
                    upload = true;
                    //调用加载中样式
                    findData();
                }
            }
        }
        function findData() {
            curPage++;
            upload = false;
            loadData();
        }
    </script>
    <%--<script type="text/javascript">
      function insertcode() {
          var $body = $("body");
          $body.append('<div style=\" height:1000px; font-size:24px;\">新增项目</div>')
          $("#page_tag_load").hide();
      }
      $(document).ready(function () {

          $(window).scroll(function () {
              var $body = $("body");
              var $html = "";
              $html += "<br/>" + ($(window).height() + $(window).scrollTop());
              $html += "<br/>window.height: " + $(window).height();
              $html += "<br/>body.height: " + $body.height();
              $html += "<br/>window.scrollTop: " + $(window).scrollTop();
              $("#page_tag_bottom").html($html);

              /*判断窗体高度与竖向滚动位移大小相加 是否 超过内容页高度*/
              if (($(window).height() + $(window).scrollTop()) >= $body.height()) {
                  $("#page_tag_load").show();
                  //setTimeout(insertcode, 1000);/*IE 不支持*/
                  insertcode();
              }
          });
      });
  </script>--%>
</head>
<body id="homeContent">
<div class="tuiTitle">
    <div class="tuiTileCenter" style="background:#fff;color:black">选卡网</div>
</div>

<div data-v-2a84ec57="" id="homeWrapper" class="home-wrapper child-view" style="top:2px">
    <div id="focus" class="focus">
        <div class="hd">
            <ul></ul>
        </div>
        <div class="bd">
            <ul>
                <s:iterator value="lunimgList" id="item">
                    <li><a href="<s:property value="url" />" target="_blank"><img
                            src="<%=path%><s:property value="imagePath" />"/></a></li>
                </s:iterator>
            </ul>
        </div>
    </div>
    <div id="typediv" style="width: 100%;height:auto;overflow-x:scroll">
        <div class="tuiguang_xuanxiang">

        </div>
    </div>

    <div id="soldiv" style="background:white;padding-bottom:5px;display:none;">
        <div style="position:relative;margin-left:auto;margin-right:auto;width: 81%;background:#f3f3f3;height:3px;">
            <div id="soldivnei" style="position:absolute;left:0px;width: 81%;background:#fb543e;height:3px;">

            </div>
        </div>
    </div>
    <div data-v-2a84ec57="" class="card">
        <div data-v-2a84ec57="" class="selecter">
            <div class="tab">
                <div id="scalNum" class="tab-item tab-selected">精准搜号</div>
                <div id="anyNum" class="tab-item marginleft">任意搜号</div>
                <div id="endNum" class="tab-item marginleft">末位搜号</div>
            </div>
            <div class="swiper-container swiper-container-horizontal">
                <div class="swiper-wrapper" style="transform: translate3d(0px, 0px, 0px); transition-duration: 0ms;">
                    <div id="scalNumDiv" class="swiper-no-swiping swiper-slide swiper-slide-active"
                         style="width: 100%;">
                        <div class="content"><p>*请在指定位置上填写数字，无要求的位置可留空</p>
                            <div class="mobile-input">
                                <div class="accurate">
                                    <input type="tel" disabled="disabled" maxlength="1" value="1">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn1" id="sn1">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn2" id="sn2">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn3" id="sn3">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn4" id="sn4">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn5" id="sn5">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn6" id="sn6">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn7" id="sn7">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn8" id="sn8">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn9" id="sn9">
                                    <input type="tel" maxlength="1" autocomplete="false" autocorrect="off"
                                           autocapitalize="off" spellcheck="false" name="sn11" id="sn11">
                                </div>
                            </div> <!---->
                            <footer><label class="reset" onclick="resetNum(this)">
                                重置
                            </label> <label class="submit" onclick="searchNum(this)">
                                搜索
                            </label></footer>
                        </div>
                    </div>
                    <div id="anyNumDiv" class="swiper-no-swiping swiper-slide swiper-slide-next" style="width: 100%;">
                        <div class="content"><p>*11位手机号码任意位置匹配数字搜索</p>
                            <div class="mobile-input">
                                <div class="blurry"><label>
                                    <input id="anyNumInp" type="tel" placeholder="请输入喜欢的数字" maxlength="11"> <!---->
                                </label></div>
                            </div> <!---->
                            <footer><label class="reset" onclick="resetNum(this)">
                                重置
                            </label> <label class="submit" onclick="searchNum(this)">
                                搜索
                            </label></footer>
                        </div>
                    </div>
                    <div id="endNumDiv" class="swiper-no-swiping swiper-slide" style="width: 100%;">
                        <div class="content"><p>*11位手机号码末尾数字匹配搜索</p>
                            <div class="mobile-input">
                                <div class="blurry"><label>
                                    <input id="endNumInp" type="tel" placeholder="请输入喜欢的数字" maxlength="11"></label>
                                </div>
                            </div> <!---->
                            <footer><label class="reset" onclick="resetNum(this)">
                                重置
                            </label> <label class="submit" onclick="searchNum(this)">
                                搜索
                            </label></footer>
                        </div>
                    </div>
                </div>
                <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span></div> <!---->
        </div>
    </div>
    <div class="index_nr">
        <div id="fixBox">
            <div class="fillter_title">
                <div class="fillter1">
                    <div class="fillter1_item">
                        <div class="fillter1_text">
                            <span id="operators">运营商</span>
                        </div>
                    </div>
                    <div class="fillter1_item">
                        <div id="gsd" class="fillter1_text">
                            <span id="guishudi" class="a">归属地</span>
                        </div>
                    </div>
                    <div class="fillter1_item">
                        <div class="fillter1_text">
                            <span id="guilv">规律</span>
                        </div>
                    </div>
                    <div class="fillter1_item">
                        <div class="fillter1_text borderrn">
                            <span id="price">更多</span>
                        </div>
                    </div>
                    <div class="fillter1_item">
                        <div class="fillter1_text borderrn">
                            <span id="paixu">排序</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="fillter_content">
                <div class="pullDown">
                    <div class="single">
                        <div class="pullDown-group operators"
                             style="transition-timing-function: cubic-bezier(0.165, 0.84, 0.44, 1); transition-duration: 0ms; transform: translate(-150px, 0px) scale(1) translateZ(0px);">
                            <ul class="pull-ul operators-ul" style="pointer-events: auto;">
                                <li class="pull-li on" data-id="-1"><span>不限</span></li>
                                <li class="pull-li" data-id="0"><span>移动</span></li>
                                <li class="pull-li" data-id="1"><span>联通</span></li>
                                <li class="pull-li" data-id="2"><span>电信</span></li>
                                <li class="pull-li" data-id="3"><span>虚商</span></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div id="linkage" class="pullDown" style="height: 216px;" >
                    <div class="single">
                        <div class="pullDown-group province"
                             style="transition-timing-function: cubic-bezier(0.165, 0.84, 0.44, 1); transition-duration: 0ms; transform: translate(0px, 0px) scale(1) translateZ(0px);">
                            <div class="pull-ul-province" id="province" style="width: 50px; height:20%; display: block">
                                <input type="hidden" name="province" id="getProvinceValue" readonly value="不限">
                                <ul class="pull-ul province-ul" style="pointer-events: auto;overflow-y: auto;height: 216px;"></ul>
                            </div>
                        </div>
                    </div>
                    <div class="single">
                        <div class="pullDown-group operators"
                             style="transition-timing-function: cubic-bezier(0.165, 0.84, 0.44, 1); transition-duration: 0ms; transform: translate(80px, -217px) scale(1) translateZ(0px);">
                            <div class="pull-ul-address" id="city">
                                <input type="hidden" name="city" id="getCityValue" readonly value="不限">
                                <ul class="pull-ul address-ul" style="pointer-events: auto;overflow-y: auto;height: 216px;"></ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="fillter_content">
                    <div class="pullDown">
                        <div class="single">
                            <div class="pullDown-group guilv"
                                 style="transition-timing-function: cubic-bezier(0.165, 0.84, 0.44, 1); transition-duration: 0ms; transform: translate(0px, 0px) scale(1) translateZ(0px)">
                                <ul class="pull-ul  guilv-ul" style="pointer-events: auto;overflow-y: auto;height: 216px;">
                                    <li class="pull-li on"><span>不限</span></li></span>
                                    <li class="pull-li"><span>尾数AAA</span></li>
                                    <li class="pull-li"><span>尾数AAAA</span></li>
                                    <li class="pull-li"><span>尾数AAAAA</span></li>
                                    <li class="pull-li"><span>尾数AAAAAA</span></li>
                                    <li class="pull-li"><span>尾数AAAAAA+</span></li>
                                    <li class="pull-li"><span>尾数AABBB</span></li>
                                    <li class="pull-li"><span>尾数AAABB</span></li>
                                    <li class="pull-li"><span>尾数AAAB</span></li>
                                    <li class="pull-li"><span>尾数AABBCC</span></li>
                                    <li class="pull-li"><span>尾数AAAAAB</span></li>
                                    <li class="pull-li"><span>尾数AAAAAAB</span></li>
                                    <li class="pull-li"><span>尾数AAAAAAAB</span></li>
                                    <li class="pull-li"><span>尾数AABB</span></li>
                                    <li class="pull-li"><span>尾数ABBA</span></li>
                                    <li class="pull-li"><span>尾数AAAAB</span></li>
                                    <li class="pull-li"><span>尾数ABAB</span></li>
                                    <li class="pull-li"><span>尾数ABCDABCD</span></li>
                                    <li class="pull-li"><span>尾数连续ABCDE+</span></li>
                                    <li class="pull-li"><span>尾数ABCDE</span></li>
                                    <li class="pull-li"><span>尾数AAAABCCCCD</span></li>
                                    <li class="pull-li"><span>尾数AAABBBCCC</span></li>
                                    <li class="pull-li"><span>尾数AABBCCDD</span></li>
                                    <li class="pull-li"><span>尾数AAABCCCD</span></li>
                                    <li class="pull-li"><span>尾数AABBCDDD</span></li>
                                    <li class="pull-li"><span>尾数ABABCDDD</span></li>
                                    <li class="pull-li"><span>尾数ABBBCDDD</span></li>
                                    <li class="pull-li"><span>尾数AABBCCCC</span></li>
                                    <li class="pull-li"><span>尾数ABABCCCC</span></li>
                                    <li class="pull-li"><span>尾数AAABBBCC</span></li>
                                    <li class="pull-li"><span>尾数AAABCCCC</span></li>
                                    <li class="pull-li"><span>尾数AAABAAAB</span></li>
                                    <li class="pull-li"><span>尾数AAABBBBB</span></li>
                                    <li class="pull-li"><span>尾数AAAAABAA</span></li>
                                    <li class="pull-li"><span>尾数AAAAAABB</span></li>
                                    <li class="pull-li"><span>尾数AAAABBBB</span></li>
                                    <li class="pull-li"><span>尾数ABBBABBB</span></li>
                                    <li class="pull-li"><span>尾数AABBABBB</span></li>
                                    <li class="pull-li"><span>尾数ABABABBB</span></li>
                                    <li class="pull-li"><span>尾数ABABABAB</span></li>
                                    <li class="pull-li"><span>中间ABABABAB</span></li>
                                    <li class="pull-li"><span>中间AAAABBBB</span></li>
                                    <li class="pull-li"><span>尾数AAAAABB</span></li>
                                    <li class="pull-li"><span>尾数AAABBBB</span></li>
                                    <li class="pull-li"><span>尾数AAAABB</span></li>
                                    <li class="pull-li"><span>尾数AAABBB</span></li>
                                    <li class="pull-li"><span>尾数ABABABA</span></li>
                                    <li class="pull-li"><span>尾数ABCABC</span></li>
                                    <li class="pull-li"><span>尾数ABABAB</span></li>
                                    <li class="pull-li"><span>尾数ABCDEABCDE</span></li>
                                    <li class="pull-li"><span>尾数ABACADAE</span></li>
                                    <li class="pull-li"><span>尾数ABCD</span></li>
                                    <li class="pull-li"><span>尾数连续ABC</span></li>
                                    <li class="pull-li"><span>尾数ABCDDCBA</span></li>
                                    <li class="pull-li"><span>尾数ABCDAABB</span></li>
                                    <li class="pull-li"><span>尾数ABABACAC</span></li>
                                    <li class="pull-li"><span>中间AAABBBCCC</span></li>
                                    <li class="pull-li"><span>中间AABBCCC</span></li>
                                    <li class="pull-li"><span>中间AAAAAAA+</span></li>
                                    <li class="pull-li"><span>中间AAABBB</span></li>
                                    <li class="pull-li"><span>中间AABBCC</span></li>
                                    <li class="pull-li"><span>中间AAAAAA</span></li>
                                    <li class="pull-li"><span>中间AAAAA</span></li>
                                    <li class="pull-li"><span>中间AABBB</span></li>
                                    <li class="pull-li"><span>中间AAABB</span></li>
                                    <li class="pull-li"><span>中间AABB</span></li>
                                    <li class="pull-li"><span>中间AAAA</span></li>
                                    <li class="pull-li"><span>中间ABCDABCD</span></li>
                                    <li class="pull-li"><span>中间ABABABA</span></li>
                                    <li class="pull-li"><span>中间ABCABC</span></li>
                                    <li class="pull-li"><span>中间ABABAB</span></li>
                                    <li class="pull-li"><span>中间AAA</span></li>
                                    <li class="pull-li"><span>中间连续ABCDE+</span></li>
                                    <li class="pull-li"><span>中间连续ABCDE</span></li>
                                    <li class="pull-li"><span>中间连续ABCD</span></li>
                                    <li class="pull-li"><span>尾数ABCDE</span></li>
                                    <li class="pull-li"><span>尾数AAAABCCCCD</span></li>
                                    <li class="pull-li"><span>尾数AAABBBCCC</span></li>
                                    <li class="pull-li"><span>尾数AABBCCDD</span></li>
                                    <li class="pull-li"><span>尾数AAABCCCD</span></li>
                                    <li class="pull-li"><span>尾数AABBCDDD</span></li>
                                    <li class="pull-li"><span>尾数ABABCDDD</span></li>
                                    <li class="pull-li"><span>尾数ABBBCDDD</span></li>
                                    <li class="pull-li"><span>尾数AABBCCCC</span></li>
                                    <li class="pull-li"><span>尾数ABABCCCC</span></li>
                                    <li class="pull-li"><span>尾数AAABBBCC</span></li>
                                    <li class="pull-li"><span>尾数AAABCCCC</span></li>
                                    <li class="pull-li"><span>尾数AAABAAAB</span></li>
                                    <li class="pull-li"><span>尾数AAABBBBB</span></li>
                                    <li class="pull-li"><span>尾数AAAAABAA</span></li>
                                    <li class="pull-li"><span>尾数AAAAAABB</span></li>
                                    <li class="pull-li"><span>尾数AAAABBBB</span></li>
                                    <li class="pull-li"><span>尾数ABBBABBB</span></li>
                                    <li class="pull-li"><span>尾数AABBABBB</span></li>
                                    <li class="pull-li"><span>尾数ABABABBB</span></li>
                                    <li class="pull-li"><span>尾数ABABABAB</span></li>
                                    <li class="pull-li"><span>中间ABABABAB</span></li>
                                    <li class="pull-li"><span>中间AAAABBBB</span></li>
                                    <li class="pull-li"><span>尾数AAAAABB</span></li>
                                    <li class="pull-li"><span>尾数AAABBBB</span></li>
                                    <li class="pull-li"><span>尾数AAAABB</span></li>
                                    <li class="pull-li"><span>尾数AAABBB</span></li>
                                    <li class="pull-li"><span>尾数ABABABA</span></li>
                                    <li class="pull-li"><span>尾数ABCABC</span></li>
                                    <li class="pull-li"><span>尾数ABABAB</span></li>
                                    <li class="pull-li"><span>尾数ABCDEABCDE</span></li>
                                    <li class="pull-li"><span>尾数ABACADAE</span></li>
                                    <li class="pull-li"><span>尾数ABCD</span></li>
                                    <li class="pull-li"><span>尾数连续ABC</span></li>
                                    <li class="pull-li"><span>尾数ABCDDCBA</span></li>
                                    <li class="pull-li"><span>尾数ABCDAABB</span></li>
                                    <li class="pull-li"><span>尾数ABABACAC</span></li>
                                    <li class="pull-li"><span>中间AAABBBCCC</span></li>
                                    <li class="pull-li"><span>中间AABBCCC</span></li>
                                    <li class="pull-li"><span>中间AAAAAAA+</span></li>
                                    <li class="pull-li"><span>中间AAABBB</span></li>
                                    <li class="pull-li"><span>中间AABBCC</span></li>
                                    <li class="pull-li"><span>中间AAAAAA</span></li>
                                    <li class="pull-li"><span>中间AAAAA</span></li>
                                    <li class="pull-li"><span>中间AABBB</span></li>
                                    <li class="pull-li"><span>中间AAABB</span></li>
                                    <li class="pull-li"><span>中间AABB</span></li>
                                    <li class="pull-li"><span>中间AAAA</span></li>
                                    <li class="pull-li"><span>中间ABCDABCD</span></li>
                                    <li class="pull-li"><span>中间ABABABA</span></li>
                                    <li class="pull-li"><span>中间ABCABC</span></li>
                                    <li class="pull-li"><span>中间ABABAB</span></li>
                                    <li class="pull-li"><span>中间AAA</span></li>
                                    <li class="pull-li"><span>中间连续ABCDE+</span></li>
                                    <li class="pull-li"><span>中间连续ABCDE</span></li>
                                    <li class="pull-li"><span>中间连续ABCD</span></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="pullDown">
                    <div class="single">
                        <div class="pullDown-group price"
                             style="transition-timing-function: cubic-bezier(0.165, 0.84, 0.44, 1); transition-duration: 0ms; transform: translate(0px, 0px) scale(1) translateZ(0px);">
                            <ul class="pull-ul price-ul" style="pointer-events: auto;">
                                <div class="text" style="width: 100%; text-align: left;">
                                    <li style="font-size: 14px;font-weight: 500;">
                                        <span style="width: 100%;text-align: left;" >价格</span></li>
                                </div>
                                <div id ="price_div" style="line-height: 32px;padding-right: 0px;text-align: left;width: 100%">
                                    <div class="price-li"><li class="pull-li" ><span class="price_span" >不限</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">0-100</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">100-200</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">200-300</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">300-500</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">500-1000</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">1000-2000</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">2000-5000</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">5000-1万</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">1万-2万</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">2万-3万</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">3万-5万</span></li></div>
                                    <div class="price-li"><li class="pull-li"><span class="price_span">5万以上</span></li></div>
                                </div>>
                            </ul>
                            <ul class="pull-ul price-ul" style="pointer-events: auto;">
                                <div class="text" style="width: 100%; text-align: left;">
                                    <li style="font-size: 14px;font-weight: 500;">
                                        <span style="width: 100%;text-align: left;" >偏好</span></li>
                                </div>
                                <div id="pianhao-div" style="line-height: 32px;padding-right: 0px;text-align: left;">
                                    <div  class="price-li"><li class="pull-li"><span class="price_span">不含3</span></li></div>
                                    <div  class="price-li"><li class="pull-li"><span class="price_span">不含4</span></li></div>
                                    <div  class="price-li"><li class="pull-li"><span class="price_span">不含7</span></li></div>
                                    <div  class="price-li"><li class="pull-li"><span class="price_span">风水号</span></li></div>
                                    <div id="num-div" style=" color: #767676;font-size: 16px;text-align: center;display: inline-block;" >
                                        <input style="display:block;margin-left:auto;margin-right:auto;text-align: center;text-align: center;width: 120px;height: 30px;border:1px solid;font-size: 16px;" placeholder="输入不想要的数字" type="text" id="num-input" name="num-input">
                                    </div>
                                </div>
                            </ul>
                        </div>
                    </div>
                </div>
                <div id="order by" class="pullDown">
                    <div class="single">
                        <div class="pullDown-group paixu"
                             style="transition-timing-function: cubic-bezier(0.165, 0.84, 0.44, 1); transition-duration: 0ms; transform: translate(0px, 0px) scale(1) translateZ(0px);">
                            <ul class="pull-ul paixu-ul" style="pointer-events: auto;">
                                <li class="pull-li on"><span>不</span></li>
                                <li class="pull-li"><span>默认排序</span></li>
                                <li class="pull-li"><span>价格由高到低</span></li>
                                <li class="pull-li"><span>价格由低到高</span></li>
                                <li class="pull-li"><span>按更新时间</span></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="w94" id="note" style="text-align:center;vertical-align:middle;display:none"><img
                src="<%=path%>/images/loader.gif"/></div>
    </div>
    <div class="index_nr ulid-div" style=" overflow-y:scroll; width:100%; height:535px;">
        <dvi id="ulid"></dvi>
        <%--<div style=" height:1000px; font-size:24px;">新增项目</div>
             <div id="page_tag_bottom" style=" width:100%; position:fixed; top:0px; background-color:#cccccc;height:100px;"></div>
             <div id="page_tag_load" style=" display:none; font-size:14px;position:fixed; bottom:0px; background-color:#cccccc;height:50px;">加载中...</div>--%>

    </div>

    <!--底部导航-->
    <div class="index_di2" style="
    width: 100%;
    height: 52px;
    background: #fff;
    border-top: 1px solid #DEDEDE;
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 999;
">
        <a href="<%=path%>/hyuser/wxIndex" style="width: 33.3%">
            <div class="hong"><img src="<%=path%>/images/home_on.png"/><br/>首页</div>
        </a>
        <a href="<%=path%>/wxMobileSale/wxCollectionNums" style="width: 33.3%">
            <div><img src="<%=path%>/images/ku.png"/><br/>收藏夹</div>
        </a>
        <a href="<%=path%>/wxMobileSale/wxConsultation?qr.type=2" style="width: 33.3%">
            <div style="position:relative"><img src="<%=path%>/images/mine.png"/><br/>咨询</div>
            <script type="text/javascript">

                $(function () {
                    //time是时间间隔，num是行数（修改num时需要修改$('#FontScroll')对应css的高度）
                    //$('#FontScroll').FontScroll({time: 3000,num: 1});

                    if ($(".hd ul li").length > 0) {
                        //轮播
                        TouchSlide({
                            slideCell: "#focus",
                            titCell: ".hd ul", //开启自动分页 autoPage:true ，此时设置 titCell 为导航元素包裹层
                            mainCell: ".bd ul",
                            effect: "leftLoop",//“left”为不循环
                            autoPlay: true,//自动播放
                            autoPage: true, //自动分页
                            switchLoad: "_src" //切换加载，真实图片路径为"_src"
                        });
                    }
                });

                $('#scalNum').click(function () {
                    $('#scalNum').attr("class", "tab-item tab-selected");
                    $('#anyNum').attr("class", "tab-item marginleft");
                    $('#endNum').attr("class", "tab-item marginleft");
                    $('#scalNumDiv').attr("class", "swiper-no-swiping swiper-slide swiper-slide-active");
                    $('#anyNumDiv').attr("class", "swiper-no-swiping swiper-slide swiper-slide-next");
                    $('#endNumDiv').attr("class", "swiper-no-swiping swiper-slide");
                    $('#scalNumDiv').parent().attr("style", "transform: translate3d(0px, 0px, 0px); transition-duration: 0ms;");
                    searchType = "scalNum"
                });
                $('#anyNum').click(function () {
                    $('#scalNum').attr("class", "tab-item");
                    $('#anyNum').attr("class", "tab-item marginleft tab-selected");
                    $('#endNum').attr("class", "tab-item marginleft");
                    $('#scalNumDiv').attr("class", "swiper-no-swiping swiper-slide");
                    $('#anyNumDiv').attr("class", "swiper-no-swiping swiper-slide swiper-slide-active");
                    $('#endNumDiv').attr("class", "swiper-no-swiping swiper-slide swiper-slide-next");
                    $('#anyNumDiv').parent().attr("style", "transform: translate3d(-100%, 0px, 0px); transition-duration: 0ms;");
                    searchType = "anyNum"
                });
                $('#endNum').click(function () {
                    $('#scalNum').attr("class", "tab-item");
                    $('#anyNum').attr("class", "tab-item marginleft");
                    $('#endNum').attr("class", "tab-item marginleft tab-selected");
                    $('#scalNumDiv').attr("class", "swiper-no-swiping swiper-slide swiper-slide-next");
                    $('#anyNumDiv').attr("class", "swiper-no-swiping swiper-slide");
                    $('#endNumDiv').attr("class", "swiper-no-swiping swiper-slide swiper-slide-active");
                    $('#endNumDiv').parent().attr("style", "transform: translate3d(-200%, 0px, 0px); transition-duration: 0ms;");
                    searchType = "endNum"
                });

                function Allsc() {
                    $("#homeContent").css("height", document.body.clientHeight+10);
                    var $w = document.body.clientWidth;
                }


                window.onload = function () {
                    Allsc();
                };

                window.onresize = function () {
                    //捕捉屏幕窗口变化，
                    Allsc();
                }

                function gotoUrl(url) {
                    location.href = url;
                }

                $(function () {
                    $("#linkage").linkage("#province", "#city", "", ".pull-ul-address");
                })
                $(function () {

                });
            </script>
        </a>
    </div>
</body>
</html>