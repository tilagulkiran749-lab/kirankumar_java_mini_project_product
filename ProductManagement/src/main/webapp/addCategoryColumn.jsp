<%@ page import="java.sql.*,product.DBConnection"%>
<html>
<head>
    <title>Add Category Column</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
            background-color: #f4f6f9;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .success {
            color: green;
            padding: 10px;
            background: #d4edda;
            border-radius: 4px;
            margin: 10px 0;
        }
        .error {
            color: red;
            padding: 10px;
            background: #f8d7da;
            border-radius: 4px;
            margin: 10px 0;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #3f51b5;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Database Update Tool</h2>
    
    <%
        String action = request.getParameter("action");
        
        if("add".equals(action)) {
            Connection con = null;
            Statement st = null;
            
            try {
                con = DBConnection.getCon();
                st = con.createStatement();
                
                // Check if column already exists
                DatabaseMetaData meta = con.getMetaData();
                ResultSet rs = meta.getColumns(null, null, "products", "category");
                
                if(rs.next()) {
                    out.println("<div class='error'>Category column already exists!</div>");
                } else {
                    // Add the category column
                    String sql = "ALTER TABLE products ADD COLUMN category VARCHAR(100)";
                    st.executeUpdate(sql);
                    out.println("<div class='success'>✓ Category column added successfully!</div>");
                    out.println("<div class='success'>✓ You can now add products with categories!</div>");
                }
                rs.close();
                
            } catch(Exception e) {
                out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                e.printStackTrace();
            } finally {
                try {
                    if(st != null) st.close();
                    if(con != null) con.close();
                } catch(Exception e) {}
            }
        }
    %>
    
    <%
        if(!"add".equals(action)) {
    %>
        <p>The <strong>category</strong> column is missing from your products table.</p>
        <p>Click the button below to add it:</p>
        <a href="?action=add" class="btn">Add Category Column</a>
    <%
        } else {
    %>
        <a href="addProduct.jsp" class="btn">Go to Add Product</a>
        <a href="report.jsp" class="btn">Go to Report</a>
    <%
        }
    %>
</div>
</body>
</html>