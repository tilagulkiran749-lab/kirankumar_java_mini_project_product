<%@ page import="javax.servlet.http.*" %>

<%
HttpSession session1 = request.getSession();

Integer id = (Integer) session1.getAttribute("pid");
String name = (String) session1.getAttribute("pname");
Double price = (Double) session1.getAttribute("pprice");
Integer qty = (Integer) session1.getAttribute("pqty");
%>

<!DOCTYPE html>
<html>
<head>
<title>Delete Product</title>

<style>
body{
font-family:Arial;
background:linear-gradient(to right,#ffecd2,#fcb69f);
margin:0;
padding:0;
}

.container{
width:450px;
margin:60px auto;
background:white;
padding:25px;
border-radius:12px;
box-shadow:0 0 15px gray;
text-align:center;
}

h2{
color:#333;
}

/* MESSAGE BOX */
.msg{
padding:10px;
border-radius:6px;
margin:10px 0;
font-weight:bold;
}

.success{background:#d4edda;color:#155724;border:1px solid #c3e6cb;}
.error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;}
.warn{background:#fff3cd;color:#856404;border:1px solid #ffeeba;}

/* PRODUCT BOX */
.box{
background:#f8f9fa;
padding:12px;
border-radius:8px;
margin:15px 0;
text-align:left;
}

/* INPUT */
input{
width:100%;
padding:10px;
margin:8px 0;
box-sizing:border-box;
}

/* BUTTONS */
button{
width:100%;
padding:10px;
border:none;
cursor:pointer;
font-size:16px;
margin-top:10px;
}

.search{
background:#007BFF;
color:white;
}

.delete{
background:red;
color:white;
}

.home{
background:green;
color:white;
}
</style>

</head>
<body>

<div class="container">

<h2>Delete Product Module</h2>

<!-- MESSAGE -->
<%
String msg = request.getParameter("msg");

if("found".equals(msg)){
%>
<div class="msg warn">
Product Found. Please review before deleting.
</div>
<%
}else if("deleted".equals(msg)){
%>
<div class="msg success">
Product Deleted Successfully
</div>
<%
}else if("notfound".equals(msg)){
%>
<div class="msg error">
Product Not Found
</div>
<%
}else if("fail".equals(msg)){
%>
<div class="msg error">
Something Went Wrong
</div>
<%
}
%>

<!-- SEARCH -->
<form method="post" action="DeleteProductServlet">
    <input type="text" name="id" placeholder="Enter Product ID" required>
    <button class="search" type="submit" name="action" value="search">
        Search
    </button>
</form>

<hr>

<!-- PRODUCT DISPLAY -->
<%
if(id != null){
%>

<div class="box">
<p><b>ID:</b> <%=id%></p>
<p><b>Name:</b> <%=name%></p>
<p><b>Price:</b> <%=price%></p>
<p><b>Quantity:</b> <%=qty%></p>
</div>

<!-- DELETE -->
<form method="post" action="DeleteProductServlet"
      onsubmit="return confirm('Are you sure you want to delete this product?');">

<input type="hidden" name="id" value="<%=id%>">

<button class="delete" type="submit" name="action" value="delete">
Delete Product
</button>

</form>

<%
}
%>

<!-- HOME -->
<a href="dashboard.jsp">
<button class="home">Home</button>
</a>

</div>

</body>
</html>