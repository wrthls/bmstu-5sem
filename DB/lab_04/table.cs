// 3) Определяемую пользователем табличную функцию CLR,
using System;  
using System.Data.Sql;  
using Microsoft.SqlServer.Server;  
using System.Collections;  
using System.Data.SqlTypes;  
using System.Diagnostics;  

namespace pow2
{
    public class TableValuedFunction
    {
        [SqlFunction(FillRowMethodName = "GenerateIntervalFillRow")]

        // IEnumerable объект, возвращаемый управляемой функции напрямую, вызывается планом 
        // выполнения запроса, который вызывает функцию с табличным, и эти результаты используются в инкрементном режиме.
        public static IEnumerable GenerateInterval(SqlInt32 To)
        {
            int[] items = new int[To.Value+1];
    		int s = 1;
            for (int i = 0; i <= To.Value; i++)
            {
    			s *= 2;
    			items[i] = s;
    		}
            return items;
        }

        // переводит массив item в sql таблицу
        public static void GenerateIntervalFillRow(object o, out SqlInt32 item)
        {
            item = new SqlInt32((int)o);
        }
    }
}