<%@ page import="java.sql.*,product.DBConnection" %>

<%
int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnection.getCon();

PreparedStatement ps = con.prepareStatement(
"select * from products where id=?"
);

ps.setInt(1,id);

ResultSet rs = ps.executeQuery();

rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Product</title>
</head>
<body>

<h2>Edit Product</h2>

<form action="UpdateProductServlet" method="post">

ID:
<input type="text" name="id"
value="<%=rs.getInt("id")%>" readonly><br><br>

Name:
<input type="text" name="name"
value="<%=rs.getString("name")%>" required><br><br>

Price:
<input type="number" name="price" min="0" step="0.01"
value="<%=rs.getDouble("price")%>" required><br><br>

Quantity:
<input type="number" name="quantity" min="0"
value="<%=rs.getInt("quantity")%>" required><br><br>

<input type="submit" value="Update Product">

</form>

</body>
</html>