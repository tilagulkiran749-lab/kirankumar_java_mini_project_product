<%@ page import="java.sql.*,product.DBConnection"%>

<html>
<head>
<title>Product List</title>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background-color: #f4f6f9;
    }

    .container {
        width: 80%;
        margin: 50px auto;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    h1 {
        text-align: center;
        color: #333333;
        margin-bottom: 20px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th {
        background-color: #3f51b5;
        color: #ffffff;
        padding: 12px;
        text-align: center;
    }

    td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #dddddd;
    }

    tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    tr:hover {
        background-color: #eeeeee;
    }

    .btn {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 20px;
        background-color: #3f51b5;
        color: #ffffff;
        text-decoration: none;
        border-radius: 4px;
    }

    .btn:hover {
        background-color: #303f9f;
    }

    .center {
        text-align: center;
    }
</style>

</head>

<body>

<div class="container">

<h1>Product List</h1>

<table>

<tr>
<th>ID</th>
<th>Name</th>
<th>Category</th>
<th>Price</th>
<th>Quantity</th>
</tr>

<%
Connection con = DBConnection.getCon();
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("select * from products");

while(rs.next()){
%>

<tr>
    <td><%= rs.getInt(1) %></td>        <!-- id -->
    <td><%= rs.getString(2) %></td>     <!-- name -->
    <td><%= rs.getString(3) %></td>     <!-- category -->
    <td><%= rs.getDouble(4) %></td>     <!-- price -->
    <td><%= rs.getInt(5) %></td>        <!-- quantity -->
</tr>

<%
}
%>

</table>

<div class="center">
<a href="dashboard.jsp" class="btn">Back</a>
</div>

</div>

</body>
</html>
