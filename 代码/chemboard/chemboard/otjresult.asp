<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<STYLE type="text/css">
<!--
input { border: 1 double black }
table { background-color:#f2e7db; border-collapse: collapse; border: 1px double brown }
td { font-size:9 pt; border: 1px double brown }
-->
</STYLE>
<title>统计结果</title>
<LINK href="common.css" rel="stylesheet" type="text/css">
<script language=javascript>
<!--
	function viewlist(sqlstr)
	{
		document.sqlform.sqlstring.value=sqlstr;
		document.sqlform.submit();
	}
-->
</script>
<%
	dim i
	dim num
	dim fieldnum
	
    dim selectStr
    dim fromStr
    dim whereStr
    dim groupStr
    
    dim qtype
    dim per
    if request.form("QueryType")="0" then
	qtype="="
	else 
	qtype=" like "
	per="%"
	end if
///////////////////////	
'实验对象
	'二级表 /要注意开始计数vb从0，html从1
	dim sectab(6,2)
	
	sectab(0,0)="HUAXCFFL"
	sectab(0,1)="FENLWMC"
	sectab(1,0)="HUAXCFHC"
	sectab(1,1)="HECWMC"
	sectab(2,0)="HUAXCFCH"
	sectab(2,1)="CHUNHWMC"
	sectab(3,0)="HUAXCFTQ"
	sectab(3,1)="TIQWMC"
	sectab(4,0)="HUAXCFJD"
	sectab(4,1)="JIANDWMC"
	sectab(5,0)="HANLCD"
	sectab(5,1)="JIANCPMC"
	
	'实验室
	dim labtab(4)
	
	labtab(0)="SHIYSMC"
	labtab(1)="DIZ"
	labtab(2)="MIANJ"
	labtab(3)="SHIYSJB"
    '其他
    dim qttab(5)
    
    qttab(0)="SHIYFF"
    qttab(1)="HUAXSYMC"
    qttab(2)="SHIYDXLYCD"
    qttab(3)="SHIYDXLYBW"
    qttab(4)="SHIYDXLYKS"
    '实验结果
    dim jgtab(21,2)
    
    jgtab(0,0)="HUAXCFCH"
    jgtab(0,1)="RONGD"
    jgtab(1,0)="HUAXCFCH"
    jgtab(1,1)="CHUNHHX"
    jgtab(2,0)="HUAXCFCH"
    jgtab(2,1)="CHUNHPL"
    jgtab(3,0)="HUAXCFCH"
    jgtab(3,1)="XUANGD"
    jgtab(4,0)="HUAXCFCH"
    jgtab(4,1)="HUISL"
    jgtab(5,0)="HUAXCFCH"
    jgtab(5,1)="CHUND"
    jgtab(6,0)="HUAXCFFL"
    jgtab(6,1)="CHENJPH"
    jgtab(7,0)="HUAXCFFL"
    jgtab(7,1)="CHENJXS"
    jgtab(8,0)="HUAXCFFL"
    jgtab(8,1)="CHENJSD"
    jgtab(9,0)="HUAXCFFL"
    jgtab(9,1)="CHENJSJ"
    jgtab(10,0)="HUAXCFFL"
    jgtab(10,1)="K"
    jgtab(11,0)="HUAXCFTQ"
    jgtab(11,1)="ZHONGL"
    jgtab(12,0)="HUAXCFTQ"
    jgtab(12,1)="SHOUL"
    jgtab(13,0)="HANLCD"
    jgtab(13,1)="JIANCPHL"
    jgtab(14,0)="HANLCD"
    jgtab(14,1)="JINGMDCD"
    jgtab(15,0)="HANLCD"
    jgtab(15,1)="XIANXGX"
    jgtab(16,0)="HANLCD"
    jgtab(16,1)="WUNDXSY"
    jgtab(17,0)="HANLCD"
    jgtab(17,1)="CHONGXXSY"
    jgtab(18,0)="HANLCD"
    jgtab(18,1)="XIANGDBZPC"
    jgtab(19,0)="HANLCD"
    jgtab(19,1)="CDHUISL"
    jgtab(20,0)="HANLCD"
    jgtab(20,1)="BIAOZQX"
    
    //查找出满足关键字条件的sql语句
    dim okeyword
    dim selectSYstr
    dim secUnitstr
    
    okeyword=request.form("okeyword")
    
    selectSYstr="select GID from CHOUXHXSY where "
    
    if request.form("tabselect").count<>0 then
    	selectSYstr=selectSYstr&" exists( "
    	num =request.form("tabselect")(1)-1
    	secUnitstr="(select GID from "&sectab( num,0)&" where ( "&sectab( num,1)&" "&qtype&" '"&per&okeyword&per&"' or GONGSP "&qtype&" '"&per&okeyword&per&"' ) and "&sectab( num,0)&".GID=CHOUXHXSY.GID )"
    	selectSYstr =selectSYstr&secUnitstr
        if  request.form("tabselect").count>1 then 
        for i=2 to request.form("tabselect").count
        		num =request.form("tabselect")(i)-1
        		secUnitstr="union (select GID from "&sectab( num,0)&" where ( "&sectab( num,1)&" "&qtype&" '"&per&okeyword&per&"' or GONGSP "&qtype&" '"&per&okeyword&per&"' ) and "&sectab( num,0)&".GID=CHOUXHXSY.GID )"
        		selectSYstr =selectSYstr&secUnitstr
        	next
        end if
        selectSYstr =selectSYstr&")"
    end if   
    
    //完整的sql语句
    selectStr ="select SHIYWMC"
    fromStr =" from SHIYANSTJ natural inner join  HUAXUESY natural inner join CHOUXHXSY natural inner join HUAXSYBZ "
    whereStr =" where GID in( "&selectSYstr&" ) "
    groupStr =" group by SHIYWMC"
    '实验室
    if request.form("labselect").count<>0 then
    	for i=1 to request.form("labselect").count
    		num =request.form("labselect")(i)-1
    		selectStr =selectStr&" , "&labtab(num)
    		groupStr =groupStr&" , "&labtab(num)
    	next
    end if
    '其他
    if request.form("syqtselect").count<>0 then
    	for i=1 to request.form("syqtselect").count
    		num =request.form("syqtselect")(i)-1
    		selectStr =selectStr&" , "&qttab(num)
    		groupStr =groupStr&" , "&qttab(num)
    	next
    end if
    '实验结果
    if request.form("syjgselect").count<>0 then
    	for i=1 to request.form("syjgselect").count
    		num =request.form("syjgselect")(i)-1
    		selectStr =selectStr&" , "&jgtab(num,1)
    		groupStr =groupStr&" , "&jgtab(num,1)
    	next
    end if

    selectStr =selectStr&" , count(*) "

    dim recordnum
    dim oraDB
	dim oraRS
	dim strSQL
	set oraDB=OraSession.GetDatabaseFromPool(10)	
	strSQL =selectStr &fromStr &whereStr &groupStr &" order by count(*) desc "
	
	set oraRS=oraDB.CreateDynaset(strSQL,0)
	
	fieldnum=request.form("labselect").count+request.form("syqtselect").count+request.form("syjgselect").count+1
//	response.write strSQL
	recordnum =oraRS.recordcount
    
%>
</head>

<body bgcolor="#ebdac7">
<%
dim strtemp
dim oraRST

%>
<CENTER><H2><FONT face="楷体_GB2312" color="brown">统计的结果共有<%=recordnum%>条</FONT></H2><HR color=BRown><BR>
<table cellSpacing=1 cellPadding=3 width="100%">
<tr bgcolor=#cc9966>
<td nowrap><font color=white><b>实验对象</b></font></td>
<%
//实验室
if request.form("labselect").count<>0 then
	for i=1 to request.form("labselect").count
		num =request.form("labselect")(i)-1
		strtemp="select COMMENTS from ALL_COL_COMMENTS where OWNER ='TCM_BASIC' and TABLE_NAME='SHIYANSTJ' and COLUMN_NAME='" &labtab(num)&"'"
		set oraRST=oraDB.CreateDynaset(strtemp,0)
%>
<td><font color=white><b><%=oraRST.fields(0).value%></b></font></td>	
<%
	next	
end if

//实验其他
qttab(0)="CEDFF"
if request.form("syqtselect").count<>0 then
	for i=1 to request.form("syqtselect").count
		num =request.form("syqtselect")(i)-1
		strtemp="select COMMENTS from ALL_COL_COMMENTS where OWNER ='TCM_BASIC' and TABLE_NAME='HUAXUESY' and COLUMN_NAME='" &qttab(num)&"'"
		set oraRST=oraDB.CreateDynaset(strtemp,0)
%>
<td><font color=white><b><%=oraRST.fields(0).value%></b></font></td>	
<%
	next	
end if
qttab(0)="SHIYFF"

//实验结果
jgtab(19,1)="HUISL"
if request.form("syjgselect").count<>0 then
	for i=1 to request.form("syjgselect").count
		num =request.form("syjgselect")(i)-1
		strtemp="select COMMENTS from ALL_COL_COMMENTS where OWNER ='TCM_BASIC' and TABLE_NAME='"&jgtab(num,0)&"' and COLUMN_NAME='" &jgtab(num,1)&"'"
		set oraRST=oraDB.CreateDynaset(strtemp,0)
%>
<td><font color=white><b><%=oraRST.fields(0).value%></b></font></td>	
<%
	next	
end if
jgtab(19,1)="CDHUISL"
%>
<td nowrap><font color=white><b>统计次数</b></font></td>
<td align=center width=30 nowrap><font color=white><b>原文</b></font></td>
</tr>
<%
if oraRS.recordcount<>0 then

oraRS.movefirst
Do Until oraRS.EOF
%>
<tr>
<%
	for i=1 to fieldnum
		num=i-1
%>
<td><%=oraRS.fields(num).value%></td>
<%	next

//拼接sql语句
dim strT

strT= "select distinct HUAXSYMC,HUAXSY_ID,SHIYS_ID,SHIYDX,SHIYJG from SHIYANSTJ natural inner join HUAXUESY natural inner join CHOUXHXSY natural inner join HUAXSYBZ "
//实验对象约束条件
strT=strT&" where  SHIYWMC = '"&oraRS.fields(0)&"' and GID in( "&selectSYstr&" ) "

//实验室约束条件
if request.form("labselect").count<>0 then
	for i=1 to request.form("labselect").count
		num =request.form("labselect")(i)-1
		strT=strT&" and "&labtab(num)
		num =i
		if IsNull(oraRS.fields(num).value) then
			strT=strT&" is null "
		else	
			strT= strT&" = '范宽"&oraRS.fields(num).value&"' "
		end if
	next
end if
//实验其他约束条件
if request.form("syqtselect").count<>0 then
	for i=1 to request.form("syqtselect").count
		num =request.form("syqtselect")(i)-1
		strT= strT&" and "&qttab(num)
		num =request.form("labselect").count +i
		if IsNull(oraRS.fields(num).value) then
			strT=strT&" is null "
		else	
			strT= strT&" = '范宽"&oraRS.fields(num).value&"' "
		end if
	next
end if
//实验结果约束条件
if request.form("syjgselect").count<>0 then
	for i=1 to request.form("syjgselect").count
		num =request.form("syjgselect")(i)-1
		strT= strT&" and "&jgtab(num,1)
		num =request.form("labselect").count +request.form("syqtselect").count +i
		if IsNull(oraRS.fields(num).value) then
			strT=strT&" is null "
		else	
			strT= strT&" = '范宽"&oraRS.fields(num).value&"'"
		end if
	next
end if

strT =Replace(strT,"'","&#039")
%>
<td><%=oraRS.fields(fieldnum).value%></td>
<td><a href='javascript:viewlist("<%=strT%>")'>查看</a></td>
</tr>
<%
oraRS.movenext
loop

end if//是否有数据纪录
%>
</table><BR>
<form method="post" action="tjlist.asp?offset=1" target=self name=sqlform >
<input type=hidden name="sqlstring">
</form>
<a href="javascript:history.back()">返回</a><HR color=BRown>
<FONT color=BRown size=2>*****中医药科技信息数据库*****</FONT>
</body>

</html>