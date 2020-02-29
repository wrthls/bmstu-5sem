// 1) Определяемую пользователем скалярную функцию CLR,
using Microsoft.SqlServer.Server;   // ссылка для доступа к атрибутам
using System.Data.SqlClient;        // ссылка для доступа к пространству имен ADO.NET
  
public class T
{  
    [SqlFunction(DataAccess = DataAccessKind.Read)]     // описание вида доступа к функции
    public static int ret()
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))   // использование созданного соединения
        {  
            conn.Open();            // установка соединения с сервером
            SqlCommand cmd = new SqlCommand("select COUNT(*) from VinylShop.dbo.Shops", conn);  // создание запроса в базе
            return (int)cmd.ExecuteScalar();  // метод команды executescalar возвращает int на основе запроса cmd
        }  
    }  
}  