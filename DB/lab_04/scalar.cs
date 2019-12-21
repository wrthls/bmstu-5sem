// 1) Определяемую пользователем скалярную функцию CLR,
using Microsoft.SqlServer.Server;  
using System.Data.SqlClient;  
  
public class T
{  
    [SqlFunction(DataAccess = DataAccessKind.Read)]  
    public static int ret()  
    {  
        using (SqlConnection conn   
            = new SqlConnection("context connection=true"))  
        {  
            conn.Open();  
            SqlCommand cmd = new SqlCommand(  
                "select COUNT(*) from VinylShop.dbo.Shops", conn);  
            return (int)cmd.ExecuteScalar();  
        }  
    }  
}  