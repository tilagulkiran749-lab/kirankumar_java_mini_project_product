<%@ page import="java.sql.*,product.DBConnection"%>

<html>
<head>
<title>Product Report</title>

<style>
body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f4f6f9;
}

.container{
    width:90%;
    margin:40px auto;
    background:#fff;
    padding:30px;
    border-radius:8px;
    box-shadow:0 4px 10px rgba(0,0,0,0.1);
}

h1{
    text-align:center;
    margin-bottom:25px;
}

.filter-section{
    background:#f1f3f6;
    padding:20px;
    border-radius:8px;
    margin-bottom:20px;
}

form{
    display:flex;
    gap:15px;
    flex-wrap:wrap;
    margin-bottom:15px;
}

.filter-group{
    flex:1;
    min-width:200px;
}

.filter-group label{
    font-weight:bold;
    display:block;
    margin-bottom:5px;
}

.filter-group input,
.filter-group select{
    width:100%;
    padding:8px;
    border:1px solid #ddd;
    border-radius:4px;
}

button{
    padding:10px 20px;
    border:none;
    color:#fff;
    cursor:pointer;
    border-radius:4px;
}

.btn-category{ background:#3f51b5; }
.btn-price{ background:#009688; }
.btn-qty{ background:#ff9800; }

.btn-home{
    background:#e91e63;
    color:#fff;
    padding:10px 20px;
    text-decoration:none;
    border-radius:4px;
}

.warning{
    background:#ffebee;
    color:red;
    padding:10px;
    border-radius:5px;
    text-align:center;
    font-weight:bold;
}

table{
    width:100%;
    border-collapse:collapse;
}

th{
    background:#3f51b5;
    color:#fff;
    padding:10px;
}

td{
    text-align:center;
    padding:10px;
    border-bottom:1px solid #ddd;
}

tr:nth-child(even){
    background:#f9f9f9;
}

.summary{
    margin-top:20px;
    padding:15px;
    background:#f1f3f6;
}

.center{
    text-align:center;
    margin-top:20px;
}
</style>
</head>

<body>

<div class="container">

<h1>Product Report</h1>

<%
String category = request.getParameter("category");
if(category == null) category = "";

String minPriceStr = request.getParameter("minPrice");
String topNStr = request.getParameter("topN");

double minPrice = -1;
int topN = -1;

if(minPriceStr != null && !minPriceStr.isEmpty())
    minPrice = Double.parseDouble(minPriceStr);

if(topNStr != null && !topNStr.isEmpty())
    topN = Integer.parseInt(topNStr);
%>

<div class="filter-section">

<!-- CATEGORY -->
<form method="get" action="report.jsp">

<div class="filter-group">
<label>Category</label>

<select name="category">
<option value="">All</option>

<%
Connection c1 = DBConnection.getCon();
Statement s1 = c1.createStatement();
ResultSet r1 = s1.executeQuery("SELECT DISTINCT category FROM products");

while(r1.next()){
    String cat = r1.getString("category");
    String sel = category.equals(cat) ? "selected" : "";
%>

<option value="<%=cat%>" <%=sel%>><%=cat%></option>

<%
}
r1.close();
s1.close();
c1.close();
%>

</select>
</div>

<div class="filter-group">
<label>&nbsp;</label>
<button class="btn-category">Filter Category</button>
</div>

</form>

<!-- PRICE -->
<form method="get" action="report.jsp">

<input type="hidden" name="category" value="<%=category%>">
<input type="hidden" name="topN" value="<%=topN%>">

<div class="filter-group">
<label>Price > </label>
<input type="number" name="minPrice" value="<%=minPrice>=0?minPrice:""%>">
</div>

<div class="filter-group">
<label>&nbsp;</label>
<button class="btn-price">Filter Price</button>
</div>

</form>

<!-- QUANTITY -->
<form method="get" action="report.jsp">

<input type="hidden" name="category" value="<%=category%>">
<input type="hidden" name="minPrice" value="<%=minPrice>=0?minPrice:""%>">

<div class="filter-group">
<label>Top Quantity</label>
<input type="number" name="topN" value="<%=topN>0?topN:""%>">
</div>

<div class="filter-group">
<label>&nbsp;</label>
<button class="btn-qty">Filter Quantity</button>
</div>

</form>

</div>

<table>

<tr>
<th>ID</th>
<th>Name</th>
<th>Category</th>
<th>Price</th>
<th>Quantity</th>
<th>Total</th>
</tr>

<%
Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

double grand=0;
int count=0;

try{
con = DBConnection.getCon();

String sql="SELECT * FROM products WHERE 1=1";

if(!category.isEmpty())
sql += " AND category=?";

if(minPrice>=0)
sql += " AND price>?";

if(topN>0)
sql += " AND quantity>=?";

sql += " ORDER BY id ASC";

ps = con.prepareStatement(sql);

int i=1;

if(!category.isEmpty())
ps.setString(i++,category);

if(minPrice>=0)
ps.setDouble(i++,minPrice);

if(topN>0)
ps.setInt(i++,topN);

rs = ps.executeQuery();

boolean found=false;

while(rs.next()){
found=true;

int id=rs.getInt("id");
String name=rs.getString("name");
String cat=rs.getString("category");
double price=rs.getDouble("price");
int qty=rs.getInt("quantity");

double total=price*qty;
grand+=total;
count++;
%>

<tr>
<td><%=id%></td>
<td><%=name%></td>
<td><%=cat%></td>
<td><%=price%></td>
<td><%=qty%></td>
<td><%=total%></td>
</tr>

<%
}

if(!found){
%>

<tr>
<td colspan="6" class="warning">No Product Found</td>
</tr>

<%
}

}catch(Exception e){
out.println("<tr><td colspan='6' class='warning'>"+e.getMessage()+"</td></tr>");
}finally{
try{
if(rs!=null) rs.close();
if(ps!=null) ps.close();
if(con!=null) con.close();
}catch(Exception e){}
}
%>

</table>

<div class="summary">
<p><b>Total Products:</b> <%=count%></p>
<p><b>Grand Total:</b> <%=grand%></p>
</div>

<div class="center">
<a href="dashboard.jsp" class="btn-home">Back Home</a>
</div>

</div>

</body>
</html>