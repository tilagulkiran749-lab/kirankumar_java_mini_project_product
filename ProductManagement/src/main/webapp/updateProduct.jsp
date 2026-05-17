<%@ page import="java.sql.*,product.DBConnection" %>

<%
String idParam = request.getParameter("id");
ResultSet rs = null;
boolean found = false;

if (idParam != null && !idParam.isEmpty()) {
    try {
        int id = Integer.parseInt(idParam);

        Connection con = DBConnection.getCon();

        PreparedStatement ps = con.prepareStatement(
            "select * from products where id=?"
        );

        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            found = true;
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Invalid ID format</p>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Update Product</title>

<style>
body{
font-family:Arial;
background:#f2f7ff;
margin:0;
padding:0;
}

.box{
width:450px;
margin:60px auto;
background:white;
padding:25px;
border-radius:10px;
box-shadow:0 0 10px gray;
}

h2{
text-align:center;
}

/* MESSAGE */
.msg{
padding:10px;
margin-bottom:10px;
text-align:center;
border-radius:6px;
font-weight:bold;
}

.success{
background:#d4edda;
color:#155724;
}

.error{
background:#f8d7da;
color:#721c24;
}

.warn{
background:#fff3cd;
color:#856404;
}

input{
width:100%;
padding:10px;
margin:8px 0;
}

input[type=submit]{
background:blue;
color:white;
border:none;
cursor:pointer;
}

/* HOME BUTTON */
.home-btn{
padding:10px 20px;
background:green;
color:white;
border:none;
border-radius:5px;
cursor:pointer;
}
</style>

</head>
<body>

<div class="box">

<h2>Update Product</h2>

<%
String msg = request.getParameter("msg");

if ("updated".equals(msg)) {
%>
<div class="msg success">Product Updated Successfully</div>
<%
} else if ("notfound".equals(msg)) {
%>
<div class="msg warn">Product ID Not Found</div>
<%
} else if ("fail".equals(msg)) {
%>
<div class="msg error">Invalid Input or Operation Failed</div>
<%
}
%>

<form method="get">
    Enter ID:
    <input type="number" name="id" required>
    <input type="submit" value="Search">
</form>

<hr>

<%
if (idParam != null) {
    if (found) {
%>

<h2>Edit Product</h2>

<form action="UpdateProductServlet" method="post">

ID:
<input type="text" name="id" value="<%=rs.getInt("id")%>" readonly>

Name:
<input type="text" name="name" value="<%=rs.getString("name")%>" required>

Price:
<input type="number" name="price" value="<%=rs.getDouble("price")%>" required>

Quantity:
<input type="number" name="quantity" value="<%=rs.getInt("quantity")%>" required>

<input type="submit" value="Update Product">

</form>

<%
    } else {
%>
<p style="color:red;text-align:center;">Product Not Found</p>
<%
    }
}
%>

<br>

<center>
    <a href="dashboard.jsp">
        <button class="home-btn">Home</button>
    </a>
</center>

</div>

</body>
</html>