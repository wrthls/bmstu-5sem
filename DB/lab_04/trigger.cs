// 5) Триггер CLR
using System;  
using System.Data;  
using System.Data.Sql;  
using Microsoft.SqlServer.Server;  
using System.Data.SqlClient;  
using System.Data.SqlTypes;  
using System.Xml;  
using System.Text.RegularExpressions;  
  
public class CLRTriggers  
{  
   public static void DropTableTrigger()  
   {  
       SqlTriggerContext triggContext = SqlContext.TriggerContext;             
  
       switch(triggContext.TriggerAction)  
       {  
           case TriggerAction.Delete:  
           SqlContext.Pipe.Send("String was not deleted! I cant let you do that!");
           break;  
  
           default:  
           SqlContext.Pipe.Send("Something happened!");
           break;  
       }  
   }  
}  