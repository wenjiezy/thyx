<%@ page language="java" pageEncoding="gbk"%>
<%@ include file="/common/taglibs.jsp" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%-- ************************************
 * System:    ͨ�����й����������ϵͳ
 * Function�� ���мƻ�����ҳ��
 * Author:    �޷�÷
 * Copyright: ����������ϿƼ����޹�˾
 * Create:    VER1.00 2013.04.15
 * Modify:    
************************************ --%>
<!DOCTYPE html
      PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zh">
<head>
	
	<title>ͨ�����й����������ϵͳ</title>
    <meta http-equiv="content-type" content="text/html; charset=gb2312" />
    <meta http-equiv="content-language" content="zh" />
    <meta http-equiv="content-script-type" content="text/javascript" />
    <meta name="robots" content="none" />
    <meta name="author" content="luofengmei" />
    <meta name="copyright" content="2013, Beijing HATC Co., LTD" />
    <meta name="description" content="thyx" />
	<link href="css/skin2/thyx/fPlan.css" rel="stylesheet" type="text/css"/>
	<link href="css/skin2/thyx/fPlanContext.css" rel="stylesheet" type="text/css"/>
	<link href="css/skin2/common/showImg.css" rel="stylesheet" type="text/css"/>
	<link href="css/skin2/common/divWindow.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="<%=path %>/ad/jqueryPlus/autocomplete/jquery.autocomplete.css"/>
    <script src="js/flyPlan.js" type="text/javascript"></script>
    <script src="js/changePageSize.js" type="text/javascript"></script>
	<script src="js/jquery-1.9.1.js" type="text/javascript"></script>
	<script src="js/divWindow.js" type="text/javascript"></script>
	<script src="js/calendar/syjDT.js" type="text/javascript"></script>
	<script src="js/validata/validata.js" type="text/javascript"></script>
	<script type='text/javascript' src='<%=path %>/ad/jqueryPlus/autocomplete/js/jquery.autocomplete.js'></script>
	
	<script type="text/javascript">
		var selectArray = new Array(); 
		
		$(document).ready(function(){
			//��ɻ������ֻ���ICAO_CODE autocomplete
			$("#flyPlanAdepName").autocomplete('<%=path%>/adAction.do?op=getADJSONData', {
				minChars: 1,
				max:100,
				width: 142,
				formatItem: function(row){
								return " <strong>" + row[1] + "</strong>";
							},
				formatResult: function(row){
								return row[1].replace(/(<.+?>)/gi, '');
							}
			});
			
			//Ŀ�Ļ������ֻ���ICAO_CODE autocomplete
			$("#flyPlanAdesName").autocomplete('<%=path%>/adAction.do?op=getADJSONData', {
				minChars: 1,
				max:100,
				width: 142,
				formatItem: function(row){
								return " <strong>" + row[1] + "</strong>";
							},
				formatResult: function(row){
								return row[1].replace(/(<.+?>)/gi, '');
							}
			});
		});
		
		// ����ѡ�񴰿�
		//index ����������ɻ�����Ŀ�Ļ�����params �ؼ��ֲ�ѯ��Ӧ��Ԫ�����ƣ�
		function switchPopWin(index, params) {
			params = (params != null && params != "") ? params : "";
            //1 ��ʾ��ѯ����
			params = document.getElementById(params).value;
			showIframeDiv(320,500,'<c:url value="/adAction.do?op=getADInfo&isDep="/>' + index + '&adName=' + params,'iframe','������ѯ',60)
		} 
		
		// ����ѡ��ص����������÷���ֵ
		function setADInfo(flag,object) {
			if(flag == '1'){
				document.getElementById("flyPlanAdepName").value=object.name;
				document.getElementById("flyPlanAdep").value=object.id;
			}else {
				document.getElementById("flyPlanAdesName").value=object.name;
				document.getElementById("flyPlanAdes").value=object.id;
			}
		}
	/**
	   // �鿴���мƻ�
		function  viewFlyPlanInfo(planId) {
			showIframeDiv(800,600,'<c:url value="/flyPlanAction.do?method=viewFlyPlanInfo&planId="/>'+planId,'iframe','�鿴���мƻ�',60)
		}
	**/	
		
		// �鿴���мƻ�
		function  viewFlyPlanInfo(planid){
			// showIframeDiv(1200,835,'flyPlanAction.do?method=initFlyPlanBaseInfo&operFlag=view&planid='+planid,'iframe','�鿴���мƻ�',60);
			document.form1.action = 'flyPlanAction.do?method=initFlyPlanBaseInfo&searchType=activateQ&operFlag=view&planid='+planid;
			document.form1.submit();
		}
		
		// ����ƻ�
	  	function activateFlyPlan() {
		  	var checked = 0;
			for (i=0;i<document.form1.elements.length;i++){
			    if (document.form1.elements[i].name=="chkbox"){			    	
			    	if(document.form1.elements[i].checked == true) {
			    		checked ++;
			    	// �Ƿ�ɼ���üƻ����ж�
				    //	if(){
				    //	
				    //	}
			    	}
			    }
			}
			if(checked == 0) {
				showConfirmDiv(0,'������ѡ��һ�����мƻ���','��ʾ��Ϣ');
		  		return false;
		  	}
		  	
		  	showLocalDiv(280,240,'������мƻ�','activateDiv',60);
		}
	
		// ȷ�ϼ���
	  	function confirmActivatePlan() {
		  	showConfirmDiv(1,'��ȷ��Ҫ����÷��мƻ���','��ʾ��Ϣ',function(choose){
			  	if(choose=="yes"){
					document.form1.action='<c:url value="/flyPlanAction.do?method=updateFlyPlanState&operFlag=activate"/>' ;
					document.form1.submit();
				}else{
					return;
				}
			});
	  	}
  	
		//��ѯ
		function queryFlyPlanList() {
			startDate = document.getElementById("startDate");
			if(startDate.value != "") {
				if(!isShortDate(startDate, "-", "��ʼ����", "2")) {
					return false;
				}
			}
			endDate = document.getElementById("endDate");
			if(endDate.value != "") {
				if(!isShortDate(endDate, "-", "��������", "2")) {
					return false;
				}
			}
        	document.form1.action = '<c:url value="/flyPlanAction.do?method=searchFlyPlanList&searchType=activateQ"/>';
        	document.form1.submit();
		}
		
	 // 
    
	//���Ʊ����ʱ��IDҲ���
	function cleanIdValue(names) {
		document.getElementById(names).value = "";
  	}
  	
  	/*
	 * ��ղ�ѯ��������
	 * @return 
	 */
	function clearSelectCondition(){
		document.getElementById("flyPlanName").value="";
		document.getElementById("flyPlanCode").value="";
		// ��ɻ���
		document.getElementById("flyPlanAdep").value="";
		document.getElementById("flyPlanAdepName").value="";
		// Ŀ�Ļ���
		document.getElementById("flyPlanAdes").value="";
		document.getElementById("flyPlanAdesName").value="";
		
		document.getElementById("startDate").value="";
		document.getElementById("endDate").value="";
		document.getElementById("date").value="";
		document.getElementById("fplPlanClass").value="";
	}
    </script>
	
	</head>
	<body onload="resetSize();" onresize="resetSize();">
	<div class="globalDiv">
		<div class="navText">
			���мƻ�����&nbsp;�����мƻ������б�
		</div>
		<form method="post" name="form1" >
			<div class="fplanListCheckDiv">
				<table class="inputTable fPlanListTable">
					<tr>
						<td class="leftTd">�ƻ����:</td>
						<td class="rightTd fPlanListTableTd">
                    		<input id="flyPlanCode" name="flyPlanCode" type="text" class="selectText" value="${flyPlanCode}"/>
						</td>
						<td class="leftTd">�ƻ�����:</td>
						<td class="rightTd">
							<input id="flyPlanName" name="flyPlanName" type="text" class="selectText" value="${flyPlanName}" />
						</td>
						<td class="leftTd">��ɻ���:</td>
						<td class="rightTd">
							<input type="text" name="flyPlanAdepName" 	id="flyPlanAdepName" class="selectText" onchange="cleanIdValue('flyPlanAdep');"  value="${flyPlanAdepName}"/><input type="button" class="selectButton" value="" onclick="switchPopWin(1, 'flyPlanAdepName');" />
           					<input type="hidden" name="flyPlanAdep" id="flyPlanAdep" value="${flyPlanAdep}" />
						</td>
						<td class="leftTd">Ŀ�Ļ���:</td>
						<td class="rightTd">
							<input type="text" name="flyPlanAdesName" 	id="flyPlanAdesName" class="selectText" onchange="cleanIdValue('flyPlanAdes');"  value="${flyPlanAdesName}"/><input type="button" class="selectButton" value="" onclick="switchPopWin(0, 'flyPlanAdesName');" />
           					<input type="hidden" name="flyPlanAdes" id="flyPlanAdes" value="${flyPlanAdes}" />
						</td>
					</tr>
					<tr>
						<td class="leftTd">ʵʩ����:</td>
						<td class="rightTd">
						<input type="text" class="dateSelectText" name="startDate" id="startDate" value="${startDate}" onfocus="syjDate(this)"/>
						��
						<input type="text" class="dateSelectText" name="endDate" id="endDate" value="${endDate}" onfocus="syjDate(this)"/>
							<select id="date" name="qDate" onchange="changePeriod()">
                                <option value="">
                                     ȫ��
                                </option>
                                <c:forEach items="${autoPeriodList}" var="item">
                                    <c:choose>
                                        <c:when test="${qDate == item.code_id}">
                                            <option value="<c:out value="${item.code_id}"/>" selected="selected">
                                                <c:out value="${item.name}" />
                                            </option>
                                        </c:when>
                                        <c:otherwise>
                                          <option value="<c:out value="${item.code_id}"/>">
	                                             <c:out value="${item.name}" />
    	                                     </option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                           </td>
						<td class="leftTd">�ƻ����:</td>
						<td class="rightTd">
							<select name="fplPlanClass" id="fplPlanClass" class="">
								<option value="">ȫ��</option>
		                    	<c:forEach var="item" items="${flyPlanKindList}">
		                    		<option value="${item.code_id}" 
		                    		<c:if test="${fplPlanClass eq item.code_id}">selected="selected" </c:if> >
		                    		${item.name}</option>
		                    	</c:forEach>
	                        </select>
						</td>
						<td colspan="3"></td>
						<td class="leftTd">
							<input type="button" value="�� ѯ" onclick="javascript:queryFlyPlanList();" class="setupLineButton" />&nbsp;&nbsp;<input name="button" type="button" class="setupLineButton" onclick="clearSelectCondition();" value="��&nbsp;��"/>
						</td>
					</tr>
				</table>
			</div>
			<div class="fplanListDivLine"></div>
			<div class="fPlanListDiv" id="">
				<table class="lineTable fPlanListTable">
                	<tr class="lineTableTitle">
						<td style="width: 3%;">
							<input id="checkall" type="checkbox" onclick="checkedAll(this.form,'checkall','chkbox');" />
						</td>
		               	<td style="width: 12%;">�ƻ����</td>
		               	<td style="width: 17%;">�ƻ�����</td> 
		               	<td style="width: 10%;">Ԥ�����ʱ��</td>
		               	<td style="width: 10%;">����ʱ��</td>
		               	<td style="width: 12%;">��ɻ���</td>
		               	<td style="width: 12%;">Ŀ�Ļ���</td>
						<td style="width: 14%;">�ƻ����</td>
						<td style="width: 10%;">�ƻ�״̬</td>
					</tr>
                   	<c:forEach var="flyPlan" items="${flyPlanList}" varStatus="status">
		    		    <c:choose>
		    		        <c:when test="${status.index % 2 == 0}">
		    		            <c:set var="tr_class" value="twoTdClass" scope="page" />
		    		        </c:when>
		    		        <c:otherwise>
		    		            <c:set var="tr_class" value="oneTdClass" scope="page" />
		    		        </c:otherwise>
		    		    </c:choose>
	    		    	<tr class="${tr_class}">
		    		    	<td>
		    		    		<input name="chkbox" type="checkbox" class="inputCheckbox" value="${flyPlan[0]}" />
								<input id="${flyPlan[0]}_fstate" type="hidden" value="${flyPlan[12]}" /> 
								<input id="${flyPlan[0]}_delFlag" type="hidden" value="${flyPlan[17]}" /> 
								<input id="${flyPlan[0]}_upFlag" type="hidden" value="${flyPlan[18]}" /> 
		    		    	</td>
		    		    	<td>
		    		    		<a href="#" onclick="viewFlyPlanInfo('<c:out value="${flyPlan[0]}" />');">
		    		    			<c:out value="${flyPlan[1]}" />
		    		    		</a> 
		    		    	</td>
		    		    	<td>
		    		    		<span class="fontblue" title="<c:out value="${flyPlan[2]}" />">
		    		    			<string-truncation:truncation value="${flyPlan[2]}" length="18"/>
		    		    		</span>
		    		    	</td>
		    		    	<td>
		    		    		<c:out value="${flyPlan[3]}" />
			    		    	<c:if test="${!empty impPlan[3] && !empty impPlan[4] }">:</c:if>
			    		    	<c:out value="${flyPlan[4]}" />
		    		    	</td>
		    		    	<td>
	   		    				<c:out value="${flyPlan[5]}" />
		    		    	</td>
		    		    	<td>
	    		    			 <c:out value="${flyPlan[7]}" />
		    		    	</td>
		    		    	<td>
		    		    		<c:out value="${flyPlan[9]}" />
		    		    	</td>
		    		    	<td>
		    		    		<span class="fontblue" title="<c:out value="${flyPlan[20]}" />">
		    		    			<string-truncation:truncation value="${flyPlan[20]}" length="12"/>
		    		    		</span>
		    		    	</td>
		    		    	<td>
		    		    		<c:out value="${flyPlan[13]}" />
		    		    	</td>
		    		    </tr>
	    			</c:forEach>
		    		<!--  �������  -->
		    		<c:if test="${rollPage.pagePer - rollPage.currentlyPagePer > 0}">
		    		<c:forEach begin="${rollPage.currentlyPagePer}" end="${rollPage.pagePer-1}" step="1" varStatus="status">
		    			<c:choose>
	                        <c:when test="${(status.index) % 2 == 0}">
	                            <c:set var="tr_class" value="twoTdClass" scope="page" />
	                        </c:when>
	                        <c:otherwise>
	                            <c:set var="tr_class" value="oneTdClass" scope="page" />
	                        </c:otherwise>
	                    </c:choose>
	                    <tr class="${tr_class}">
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    	<td></td>
	                    </tr>
		    		</c:forEach>
		    		</c:if>
				</table>
				<!-- ����ҳ���ҳ�������� -->	
				<div class="pageDiv">
					<c:import url="/common/rollpage.jsp" />
			    </div>
			    <div class="fplanListCheckButton">
					<input name="Bnfp006" class="setupLineButton" type="button" value="����ƻ�" onclick="activateFlyPlan();"/>
				</div>
			</div>
				<!-- �����ı�ע��-->                      
   				<div id="activateDiv" style="display:none; ">
   				<table style="align:center;">
	            	<tr>
						<td style="height: 5px;" colspan="3"></td>
					</tr>
	    		    <tr >
	    		    	<td style="height: 25px;width: 10px;text-align: left;"></td>
	                    <td style="width: 30px;">
	                    	˵��:
	                    </td>
	                    <td>
							<textarea id="remark" name="remark" style="height:150px; width: 200px;"> </textarea>
						</td>
	    		  	</tr>
	    		  	<tr>
						<td style="height: 5px;" colspan="3"></td>
					</tr>
					<tr>
						<td style="text-align: center;" colspan="3">
							&nbsp;&nbsp;&nbsp;<input type="button" id="confirmBtn" value="ȷ  ��" class="setupLineButton" onclick="confirmActivatePlan()"/>&nbsp;&nbsp;&nbsp;<input type="button" value="ȡ  ��" class="setupLineButton" onclick="closeSDiv()"/>
			           </td>
					</tr>
				</table>
				</div>
	     </form>
    </div>
	</body>
</html>