// 4) Хранимую процедуру CLR
using System;
using System.Data.SqlTypes;  
using System.Data.SqlClient;  
using Microsoft.SqlServer.Server;   

// поиск суммы веса всех дисков
public class StoredProcedures
{  
   [Microsoft.SqlServer.Server.SqlProcedure]  
   public static void RamSum(out SqlInt32 value)
   {  
      using(SqlConnection connection = new SqlConnection("context connection=true"))   
      {  
         value = 0;  
         connection.Open();  
         SqlCommand command = new SqlCommand("SELECT Weight FROM Disks", connection);  
         // Предоставляет способ чтения потока строк последовательного доступа из базы данных SQL Server.
         SqlDataReader reader = command.ExecuteReader();
  
         using (reader) 
         {  
            while(reader.Read())  // чтение из потока
            {  
               value += reader.GetSqlInt32(0);  
            }  
         }           
      }  
   }  
}  